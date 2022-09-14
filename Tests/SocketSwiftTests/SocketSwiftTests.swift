//
//  SocketSwiftTests.swift
//  SocketSwiftTests
//
//  Created by Orkhan Alikhanov on 7/5/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import XCTest
import Dispatch
@testable import SocketSwift

class SocketSwiftTests: XCTestCase {

    func testClientServerReadWrite() {
        let server = try! Socket.tcpListening(port: 8090)
        
        let client = try! Socket(.inet)
        try! client.connect(port: 8090)
        
        let writableClient = try! server.accept()
        try! writableClient.write("Hello World".bytes)
        writableClient.close()
        AssertReadStringEqual(socket: client, string: "Hello World")
        
        client.close()
        server.close()
    }
    
    func testSetOption() throws {
        //testing only SO_RCVTIMEO
        
        let server = try Socket.tcpListening(port: 8090)
        let client = try Socket(.inet)
        #if canImport(ObjectiveC)
        try client.set(option: .receiveTimeout, TimeValue(seconds: 0, microseconds: 50*1000))
        #else
        try client.set(option: .receiveTimeout, TimeValue(tv_sec: 0, tv_usec: 50*1000))
        #endif
        try client.connect(port: 8090)
        
        XCTAssertThrowsError(try client.read(), "Should throw timeout error") { err in
            XCTAssertEqual(err as? Socket.Error, Socket.Error(errno: EWOULDBLOCK))
        }
        client.close()
        server.close()
    }
    
    func testError() {
        let server = try? Socket.tcpListening(port: 80)
        XCTAssertThrowsError(try Socket.tcpListening(port: 80), "Should throw") { err in
            XCTAssert(err is Socket.Error)
            let socketError = err as! Socket.Error
            XCTAssert(socketError == Socket.Error(errno: EADDRINUSE) || socketError == Socket.Error(errno: EACCES))
        }
        
        server?.close()
    }
    
    func testPort() throws {
        let server = try Socket.tcpListening(port: 8090)
        XCTAssertEqual(try server.port(), 8090)
        server.close()
    }

    func testGetAvailableInterfaces() {
        let addresses = Socket.availableInterfacesAndIpAddresses(family: .inet)
        //print("Available interfaces & addresses: \(addresses)")
        XCTAssertTrue(!addresses.isEmpty)
        addresses.values.forEach { address in
            XCTAssertEqual(address.components(separatedBy: ".").count, 4)
        }
    }
}

private extension String {
    var bytes: [Byte] {
        return [Byte](self.utf8)
    }
}

private extension Array where Element == Byte {
    var string: String? {
        return String(bytes: self, encoding: .utf8)
    }
}

private func AssertReadStringEqual(socket: Socket, string: String, file: StaticString = #file, line: UInt = #line) {
    var buff = [Byte](repeating: 0, count: string.count)
    let bytesRead = try! socket.read(&buff, size: string.count)
    XCTAssertEqual(bytesRead, string.count, file: file, line: line)
    XCTAssertEqual(buff.string, string, file: file, line: line)
}

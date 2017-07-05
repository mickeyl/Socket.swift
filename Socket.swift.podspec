Pod::Spec.new do |s|
    s.name             = 'Socket.swift'
    s.version          = '1.0'
    s.summary          = 'A POSIX socket wrapper written in swift.'
    s.homepage         = 'https://github.com/BiAtoms/Socket.swift'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Orkhan Alikhanov' => 'orkhan.alikhanov@gmail.com' }
    s.source           = { :git => 'https://github.com/BiAtoms/Socket.swift.git', :tag => s.version.to_s }
    s.module_name      = 'SocketSwift'

    s.ios.deployment_target = '8.0'
    s.source_files = 'Sources/*.swift'
end
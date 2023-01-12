Pod::Spec.new do |s|
    s.name             = 'EncryptingSwift'
    s.version          = '1.0.0'
    s.summary          = 'Encrypting library in Swift'
    
    # s.description      = <<-DESC
    # TODO: Add long description of the pod here.
    #                      DESC
    
    s.homepage         = 'https://github.com/sublabdev/encrypting-swift'
    s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
    s.author           = { 'Tigran Iskandaryan' => 'tiger@sublab.dev' }
    s.source           = { :git => 'https://github.com/sublabdev/encrypting-swift.git', :tag => s.version.to_s }
    s.ios.deployment_target = '13.0'
    s.source_files = 'EncryptingSwift/Classes/**/*'
    s.dependency 'HashingSwift'
    s.dependency 'secp256k1.swift'
    s.dependency 'ed25519swift', '~> 1.2.8'
    s.dependency 'CommonSwift'
    s.dependency 'Sr25519', '~> 0.1.3'
    s.dependency 'MnemonicKit', '1.3.9'
    
end

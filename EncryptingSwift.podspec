Pod::Spec.new do |s|
    s.name             = 'EncryptingSwift'
    s.version          = '1.0.0'
    s.summary          = 'Encrypting library in Swift'
    s.homepage         = 'https://github.com/sublabdev/encrypting-swift'
    s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
    s.author           = { 'Substrate Laboratory LLC' => 'info@sublab.dev' }
    s.source           = { :git => 'https://github.com/sublabdev/encrypting-swift.git', :tag => s.version.to_s }
    s.ios.deployment_target = '13.0'
    s.source_files = 'EncryptingSwift/Classes/**/*'
    s.dependency 'CommonSwift', '~> 1.0.0'
    s.dependency 'HashingSwift', '~> 1.0.0'
    s.dependency 'secp256k1.swift', '~> 0.1.4'
    s.dependency 'ed25519swift', '~> 1.2.8'
    s.dependency 'Sr25519', '~> 0.1.3'
    s.dependency 'Bip39.swift', '~> 0.1.1'
    s.dependency 'UncommonCrypto', '~> 0.1.3'    
end

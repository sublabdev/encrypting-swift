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
s.source_files = 'HashingSwift/Classes/**/*'

end

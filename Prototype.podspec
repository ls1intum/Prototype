Pod::Spec.new do |spec|
  spec.name             = 'Prototype'
  spec.version          = '0.1'
  spec.summary          = 'Framework to integrate prototypes into iOS, macOS or tvOS applications'

  spec.description      = <<-DESC
The prototype framework allows you to integrate .prototype files created with the macOS Prototype-Application into your iOS, macOS or tvOS application. You can configure and inspect the `PrototypeView` using the Xcode Interface Builder with ease.
                       DESC

  spec.homepage         = 'https://twitter.com/PSchmiedmayer'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'Paul Schmiedmayer' => 'paul.schmiedmayer@tum.de' }
  spec.source           = { :git => 'https://github.com/ls1intum/prototype.git', :tag => spec.version.to_s }
  spec.social_media_url = 'https://twitter.com/PSchmiedmayer'
  spec.ios.deployment_target  = '10.0'
  spec.osx.deployment_target  = '10.12'
  spec.tvos.deployment_target = '10.0'
  spec.source_files     = 'Prototype/**/*'
end

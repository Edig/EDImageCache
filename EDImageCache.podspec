Pod::Spec.new do |spec|
    spec.name                   = 'EDImageCache'
    spec.version                = '1.0'
    spec.license                = { :type => 'MIT' }
    spec.homepage               = 'https://github.com/Edig/EDImageCache'
    spec.authors                = { 'Eduardo Iglesias' => 'edig50@gmail.com' }
    spec.summary                = 'Simple Image cache in Swift '
    spec.source                 = { :git => 'https://github.com/Edig/EDImageCache.git', :tag => '1.0' }
    spec.source_files           = 'EDImageCache/*'
    spec.framework              = 'UIKit'
    spec.requires_arc           = true
    spec.ios.deployment_target  = "8.0"
end
Pod::Spec.new do |spec|
    spec.name                   = 'EDImageCache'
    spec.version                = '1.1'
    spec.license                = { :type => 'MIT' }
    spec.homepage               = 'https://github.com/Edig/EDImageCache'
    spec.authors                = { 'Eduardo Iglesias' => 'edig50@gmail.com' }
    spec.social_media_url       = "http://twitter.com/Eduardo"
    spec.summary                = 'Simple Image cache written in Swift'
    spec.source                 = { :git => 'https://github.com/Edig/EDImageCache.git', :tag => '1.0' }
    spec.source_files           = '*.{swift}'
    spec.framework              = 'UIKit', 'ImageIO'
    spec.requires_arc           = true
    spec.ios.deployment_target  = "8.0"
end
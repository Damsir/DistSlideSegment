Pod::Spec.new do |s|

  s.name         = "DistSlideSegment"
  s.version      = "1.0.4"
  s.summary      = "分段滑动组件：1、导航栏样式 2、普通样式"
  s.author       = { "Damrin" => "75081647@qq.com" }
  s.homepage    = 'https://github.com/Damsir/DistSlideSegment'
  s.source      = { :git => 'https://github.com/Damsir/DistSlideSegment.git', :tag => s.version }
  s.license = "MIT"
  s.platform = :ios, "8.0"
  s.requires_arc = true
  s.source_files = "DistSlideSegment", "DistSlideSegment/**/*.{h,m,xib}"
  # s.public_header_files = "DistSlideSegment/*.h"
  s.framework = 'UIKit'
  s.ios.deployment_target = "8.0"

end

Pod::Spec.new do |s|

  s.name         = "DistSlideSegment"
  s.version      = "1.0.0"
  s.summary      = "A short description of DistSlideSegment."
  s.author       = { "Damrin" => "75081647@qq.com" }
  s.homepage    = 'https://github.com/Damsir/DistSlideSegment'
  s.source      = { :git => 'https://github.com/Damsir/DistSlideSegment.git', :tag => "v#{s.version}" }
  s.license = "MIT"
  s.platform = :ios, "8.0"
  s.requires_arc = true
  s.source_files = "DistSlideSegment/*.{h,m,xib}"
  # s.public_header_files = "DistSlideSegment/*.h"
  s.framework = 'UIKit'
  s.ios.deployment_target = "8.0"

end

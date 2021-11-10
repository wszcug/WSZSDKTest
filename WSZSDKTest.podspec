#
#  Be sure to run `pod spec lint WSZSDKTest.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|



  spec.name         = "WSZSDKTest"
  spec.version      = "0.0.3"
  spec.summary      = "开发测试开发测试发开发"


  spec.homepage     = "https://github.com/wszcug/WSZSDKTest.git"

  spec.license      = "MIT"


  spec.author       = { "wszcug" => "272327827@qq.com" }
 

  spec.platform     = :ios, "9.0"
  
  spec.requires_arc = true
  spec.frameworks = 'SystemConfiguration', 'Security', 'CoreGraphics', 'AVFAudio', 'AVFoundation', 'CoreTelephony','WebKit'
  spec.libraries = 'z', 'c++', 'sqlite3.0', 'iconv'
  spec.vendored_frameworks    = 'WSZSDKTest/QPlayerSDK.framework'
 

  spec.source       = { :git => "https://github.com/wszcug/WSZSDKTest.git", :tag => "#{spec.version}" }
  spec.xcconfig	   = { 'OTHER_LDFLAGS' => '-ObjC -all_load -fobjc-arc' }

  spec.dependency "Masonry", "~> 1.0.0"    #所依赖的第三方库，没有就不用写

	
 

end

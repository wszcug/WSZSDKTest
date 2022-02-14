
Pod::Spec.new do |spec|


spec.name         	= "WSZSDKTest"
spec.version      	= "1.1.3"
spec.summary      	= "仅用于测试"
spec.license      	= "MIT"
spec.author       	= { "wszcug" => "272327827@qq.com" }
spec.homepage     	= "https://github.com/wszcug/WSZSDKTest.git"
spec.documentation_url 	= 'http://Xinguang.github.io/WechatKit/index.html'
spec.source       	= { :git => "https://github.com/wszcug/WSZSDKTest.git", :tag => "#{spec.version}" }

spec.platform     	= :ios, "10.0"
spec.requires_arc 	= true

spec.frameworks 		= 'SystemConfiguration', 'Security', 'CoreGraphics', 'AVFoundation', 'CoreTelephony', 'WebKit'
spec.libraries 		= 'z', 'c++', 'sqlite3.0', 'iconv'

spec.vendored_frameworks 	= 'WSZSDKTest/QMOpenApiSDK.framework'
 
spec.xcconfig	   	= { 'OTHER_LDFLAGS' => '-ObjC -all_load -fobjc-arc' }

spec.dependency 'WechatOpenSDK','~> 1.8.7'
end

#
#  Be sure to run `pod spec lint WSZSDKTest.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|



  spec.name         = "WSZSDKTest"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of WSZSDKTest."


  spec.description  = <<-DESC
                   DESC

  spec.homepage     = "http://EXAMPLE/WSZSDKTest"

  spec.license      = "MIT (example)"


  spec.author             = { "wszcug" => "272327827@qq.com" }
 

  spec.platform     = :ios, "9.0"

 

  spec.source       = { :git => "https://github.com/wszcug/WSZSDKTest.git", :tag => "#{spec.version}" }


  spec.source_files  = "WSZSDKTest", "WSZSDKTest/**"
spec.dependency "Masonry", "~> 1.0.0"    #所依赖的第三方库，没有就不用写


 

end

Pod::Spec.new do |s|
  s.name = "JADYun"
  s.version = "2.0.0"
  s.summary = "AN SDK."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"shuaishuai331"=>"wangshuai331@jd.com"}
  s.homepage = "https://github.com/JAD-FE-TEAM/JADYunIOS"
  s.description = "JD Ad SDK Project."
  s.frameworks = 'CoreServices', 'AssetsLibrary', 'Photos', 'Accelerate', 'ImageIO', 'WebKit', 'SystemConfiguration', 'CoreTelephony', 'AdSupport', 'MapKit', 'CoreLocation'
  s.libraries = ["z", "sqlite3"]
  s.source = { :http => 'https://storage.jd.com/ios-sdk-libs/single_package/'+s.version.to_s+'/JADYun.framework.zip'}
  
  s.ios.deployment_target    = '9.0'
  s.swift_version = '4.0'
  s.ios.vendored_framework   = 'JADYun.framework'

  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end

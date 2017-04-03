Pod::Spec.new do |s|
  s.name         = "YKLaunchAd"
  s.version      = "1.0.0"
  s.summary      = "几行代码接入启动页广告，自带图片下载、缓存功能，无任何第三方依赖，支持GIF、自定义广告frame，支持自定义广告结束转场动画，支持iPhone/iPad等功能"
  s.homepage     = "https://github.com/jinstar520/YKLaunchAdDemo"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "jinstar520" => "jinstar520@yeah.net"}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/jinstar520/YKLaunchAdDemo.git", :tag => s.version }
  s.source_files = "YKLaunchAd/**/*.{h,m}"
  s.requires_arc = true
end
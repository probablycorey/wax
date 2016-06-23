Pod::Spec.new do |s|

  s.name         = "wax"
  s.version      = "1.0.0"
  s.summary      = "wax Source"

  s.description  = <<-DESC
                   Wax is a framework that lets you write native iPhone apps in Lua. It bridges Objective-C and Lua using the Objective-C runtime. With Wax, anything you can do in Objective-C is automatically available in Lua! What are you waiting for, give it a shot!
                   DESC

  s.homepage     = "https://github.com/alibaba/wax"

  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
           MIT License
    LICENSE
  }

  s.author             = { "probablycorey" => "probablycorey@gmail.com" }
  s.source   = { :git => 'https://github.com/alibaba/wax.git', :tag => s.version.to_s}

  s.platform     = :ios

  #  When using multiple platforms
  s.ios.deployment_target = '4.3'

  s.source_files  = 'lib/*.{h,m}', 'lib/adaptation/*.{h,m}','lib/lua/*.{h,m,c}', 'lib/extensions/block/*.{h,m}', 'lib/extensions/capi/**/*.{h,m,c}', 'lib/extensions/CGAffine/*.{h,m}','lib/extensions/CGContext/*.{h,m}','lib/extensions/filesystem/*.{h,m}' ,'lib/extensions/HTTP/*.{h,m}','lib/extensions/ivar/*.{h,m}','lib/extensions/json/**/*.{h,m,c}','lib/extensions/SQLite/**/*.{h,m}','lib/extensions/xml/**/*.{h,m}'
  s.library = "xml2","sqlite3"
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '${SDK_DIR}/usr/include/libxml2' }

  s.requires_arc = false

end

Pod::Spec.new do |s|

  s.name         = "mobdebug"
  s.version      = "1.0.0"
  s.summary      = "mobdebug"

  s.description  = <<-DESC
                   Lua remote debug
                   DESC

  s.homepage     = "https://github.com/alibaba/wax"

  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
           MIT License
    LICENSE
  }

  s.author             = { "junzhan" => "junzhan.yzw@taobao.com" }
  s.source   = { :git => 'https://github.com/alibaba/wax.git', :tag => s.version.to_s}
  s.platform     = :ios

  #  When using multiple platforms
  s.ios.deployment_target = '4.3'

  s.source_files  = 'mobdebug/*.{h,m,c}', 'mobdebug/luasocket/*.{h,m,c}'

  s.requires_arc = false

end

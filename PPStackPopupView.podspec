#
# Be sure to run `pod lib lint PPStackPopupView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PPStackPopupView'
  s.version          = '0.1.0'
  s.summary          = '弹窗队列视图管理'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
管理弹出的弹窗视图，可以设置优先级。
                       DESC

  s.homepage         = 'https://github.com/PP-Rabbit/PPStackPopupView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PP-Rabbit' => '13370155475@163.cn' }
  s.source           = { :git => 'https://github.com/PP-Rabbit/PPStackPopupView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'PPStackPopupView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PPStackPopupView' => ['PPStackPopupView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry'
end

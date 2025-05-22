#
# Be sure to run `pod lib lint OC_MarkdownView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OC_MarkdownView'
  s.version          = '0.1.0'
  s.summary          = 'MarkdownView is a markdown render like swift-markdown-ui but write in ObjectiveC.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  MarkdownView is simple and easy to use markdown render view for iOS. which is writen in Objective-C. And support most of the GFM markdown style.The whole project is referencing the [swift-markdown-ui]( https://github.com/gonzalezreal/swift-markdown-ui). thanks for the author. And I am just a little helper to express the swift-markdown-ui in ObjectiveC.
                       DESC

  s.homepage         = 'https://github.com/ximmyxiao/OC_MarkdownView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ximmyxiao' => 'ximmyxiao@tencent.com' }
  s.source           = { :git => 'https://github.com/ximmyxiao/OC_MarkdownView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '17.0'

  s.source_files = 'OC_MarkdownView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'OC_MarkdownView' => ['OC_MarkdownView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'libcmark_gfm'
  s.prefix_header_contents = '#import "MarkdownViewHeader.h"'
end

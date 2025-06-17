#
# Be sure to run `pod lib lint OC_MarkdownView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OC_MarkdownView'
  s.version          = '0.1.18'
  s.summary          = 'MarkdownView is a markdown render like swift-markdown-ui but write in ObjectiveC.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  MarkdownView is a simple and easy-to-use Markdown rendering view for iOS, written in Objective-C. It supports most of the GFM Markdown styles. The project references [swift-markdown-ui]( https://github.com/gonzalezreal/swift-markdown-ui). Thanks to the author of swift-markdown-ui; this project aims to provide similar functionality in Objective-C.
                       DESC

  s.homepage         = 'https://github.com/ximmyxiao/OC_MarkdownView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ximmyxiao' => 'ximmyxiao@gmail.com' }
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

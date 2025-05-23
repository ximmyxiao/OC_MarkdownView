# OC_MarkdownView

  MarkdownView is a simple and easy-to-use Markdown rendering view for iOS, written in Objective-C. It supports most of the GFM Markdown styles. The project references [swift-markdown-ui]( https://github.com/gonzalezreal/swift-markdown-ui). Thanks to the author of swift-markdown-ui; this project aims to provide similar functionality in Objective-C.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
    MarkdownView *markdownView = [[MarkdownView alloc] initWithFrame:self.view.bounds];
    markdownView.markdownText = @"# Hello World\n\nThis is a Markdown text.\n\n- Item 1\n- Item 2\n- Item 3";
    [self.view addSubview:markdownView];

## Requirements
- iOS 17.0 or later
## Installation

OC_MarkdownView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'OC_MarkdownView'
```

## Author

ximmyxiao, ximmyxiao@tencent.com

## License

OC_MarkdownView is available under the MIT license. See the LICENSE file for more info.

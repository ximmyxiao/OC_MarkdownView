//
//  MarkdownViewStyleManager.m
//  OC_MarkdownView_Example
//
//  Created by 肖潇 on 2025/6/17.
//  Copyright © 2025 ximmyxiao. All rights reserved.
//

#import "MarkdownViewStyleManager.h"
#import "UIImage+Ex.h"

@implementation MarkdownViewStyleManager
//singleton
+ (instancetype)sharedInstance {
    static MarkdownViewStyleManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mainFontSize = 17;
        [self resetStyles];
    }
    return self;
}

- (void)setMainFontSize:(CGFloat)mainFontSize {
    _mainFontSize = mainFontSize;
    [self resetStyles];
}

- (void)resetStyles {
    
    self.mainTextColor = [UIColor labelColor];
    
    self.inlineTextHeadingTextColor = [UIColor labelColor];
    
    self.codeBlockFontSize = ceilf(self.mainFontSize * 0.85);
    self.codeBlockLineSpacing = ceilf(0.225 * self.mainFontSize);
    self.codeblockScrollEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16);
    self.codeBlockScrollBgCornerRadius = 6;
    self.codeBlockScrollBgColor = UIColorFromRGB(0xF7F7F9);
    
    self.inlineTextLineSpacingScale = 0.125;
    self.inlineTextLineSpacingScaleInHeadingLevel1 = 1.125;
    self.inlineTextLineSpacingScaleInHeadingLevel2 = 2.125;
    self.inlineTextCodeTextColor = [UIColor labelColor];
    self.inlineTextCodeTextBackgroundColor = UIColorFromRGB(0xf7f7f9);
    self.inlineTextCodeFontSize = ceilf(self.mainFontSize * 0.85);
    
    self.inlineTextFontSizeOfHeadingLevel1 = ceilf(self.mainFontSize * 2);
    self.inlineTextFontSizeOfHeadingLevel2 = ceilf(self.mainFontSize * 1.5);
    self.inlineTextFontSizeOfHeadingLevel3 = ceilf(self.mainFontSize * 1.25);
    self.inlineTextFontSizeOfHeadingLevel4 = ceilf(self.mainFontSize * 1);
    self.inlineTextFontSizeOfHeadingLevel5 = ceilf(self.mainFontSize * 0.85);
    self.inlineTextFontSizeOfHeadingLevel6 = ceilf(self.mainFontSize * 0.85);
    
    self.listSpacingBetweenItems = 5;
    self.listImageMarkerWidth = 19;
    UIImage* image = [UIImage systemImageNamed:@"circle.fill"];
    image = [image imageWithZoomScale:0.3];
    self.bulletedListImageMarker = image;
    self.taskListImageMarkerForCompleted = [UIImage systemImageNamed:@"checkmark.square.fill"];
    self.taskListImageMarker = [UIImage systemImageNamed:@"square"];
    
    self.spacingBetweenListImageMarkerAndText = 5;
    
    self.quoteMarkerCornerRadius = 5;
    self.quoteMarkerWidth = 4;
    
    self.tableBorderWidth = 1;
    self.tableCornerRadius = 5;
    self.tableBorderColor = UIColorFromRGB(0xe4e4e8);
    self.tableColumnContentEdgeInsets = UIEdgeInsetsMake(6, 13, 13, 6);

    
}
@end

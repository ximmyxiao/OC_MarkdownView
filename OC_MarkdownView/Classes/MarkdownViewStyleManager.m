//
//  MarkdownViewStyleManager.m
//  OC_MarkdownView_Example
//
//  Created by 肖潇 on 2025/6/17.
//  Copyright © 2025 ximmyxiao. All rights reserved.
//

#import "MarkdownViewStyleManager.h"

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
        self.codeBlockFontSize = ceilf(self.mainFontSize * 0.85);
        self.codeBlockLineSpacing = ceilf(0.225 * self.mainFontSize);
    }
    return self;
}
@end

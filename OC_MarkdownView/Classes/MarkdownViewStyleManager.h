//
//  MarkdownViewStyleManager.h
//  OC_MarkdownView_Example
//
//  Created by 肖潇 on 2025/6/17.
//  Copyright © 2025 ximmyxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarkdownViewStyleManager : NSObject
+ (instancetype)sharedInstance;
@property(nonatomic,assign) CGFloat mainFontSize;

@property(nonatomic,assign) CGFloat codeBlockFontSize;
@property(nonatomic,assign) CGFloat codeBlockLineSpacing;

@end

NS_ASSUME_NONNULL_END

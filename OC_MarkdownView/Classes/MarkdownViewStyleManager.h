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
@property(nonatomic,assign) UIEdgeInsets codeblockScrollEdgeInsets;
@property(nonatomic,assign) CGFloat codeBlockScrollBgCornerRadius;
@property(nonatomic,strong) UIColor* codeBlockScrollBgColor;

@property(nonatomic,assign) CGFloat inlineTextLineSpacingScale;
@property(nonatomic,assign) CGFloat inlineTextLineSpacingScaleInHeadingLevel1;
@property(nonatomic,assign) CGFloat inlineTextLineSpacingScaleInHeadingLevel2;
@property(nonatomic,strong) UIColor* inlineTextCodeTextColor;
@property(nonatomic,assign) CGFloat inlineTextCodeFontSize;
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel1;
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel2;
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel3;
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel4;
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel5;
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel6;

@property(nonatomic,assign) CGFloat listSpacingBetweenItems;

@end

NS_ASSUME_NONNULL_END

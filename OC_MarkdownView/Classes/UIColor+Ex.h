//
//  UIColor+Ex.h
//  testSSE
//
//  Created by ximmy on 2025/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Ex)
+ (UIColor*)colorWithHex:(NSInteger)rgb;
+ (UIColor*)borderColor;
+ (UIColor*)secondaryTextColor;
@end

NS_ASSUME_NONNULL_END

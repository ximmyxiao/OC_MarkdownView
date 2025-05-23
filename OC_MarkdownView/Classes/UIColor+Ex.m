//
//  UIColor+Ex.m
//  testSSE
//
//  Created by ximmy on 2025/4/23.
//

#import "UIColor+Ex.h"

@implementation UIColor (Ex)
+ (UIColor*)colorWithHex:(NSInteger)rgb
{

    NSInteger blueValue = rgb & 0x0000FF;
    NSInteger greenValue = (rgb & 0x00FF00) >> 8;
    NSInteger redValue = (rgb & 0xFF0000) >> 16;

    return [UIColor colorWithRed:redValue / 255.0 green:greenValue / 255.0 blue:blueValue / 255.0 alpha:1];
}
+ (UIColor*)borderColor
{
    return [UIColor colorWithDynamicProvider:^UIColor* _Nonnull(UITraitCollection* _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor colorWithHex:0x42444E]; // White for dark mode
        } else {
            return [UIColor colorWithHex:0xE4E4E8]; // Black for light mode
        }
    }];
}

+ (UIColor*)secondaryTextColor
{
    return [UIColor colorWithDynamicProvider:^UIColor* _Nonnull(UITraitCollection* _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor colorWithHex:0x9294A0]; // White for dark mode
        } else {
            return [UIColor colorWithHex:0x6B6E7B]; // Black for light mode
        }
    }];
}
@end

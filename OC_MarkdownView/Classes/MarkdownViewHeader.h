//
//  MarkdownContentViewHeader.h
//  libcmark_gfm
//
//  Created by 肖潇 on 2025/5/21.
//

#ifndef MarkdownContentViewHeader_h
#define MarkdownContentViewHeader_h

#import "UIColor+Ex.h"
#define kURLInMarkDownKey @"kURLInMarkDownKey"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#define STYLE_TEXT_ATTRIBUTE_KEY_NAME @"STYLE_TEXT_ATTRIBUTE_KEY_NAME"
#endif /* MarkdownContentViewHeader_h */

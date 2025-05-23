//
//  InlineTextStyleManager.m
//  testSSE
//
//  Created by ximmy on 2025/4/29.
//

#import "InlineTextStyleManager.h"

@interface InlineTextStyleManager ()
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) UIFont* styleFont;
@property (nonatomic, assign) BOOL isTableHeaderRow;
@end

@implementation InlineTextStyleManager
- (instancetype)initWithTableHeaderRow
{
    self = [super init];
    if (self) {
        self.isTableHeaderRow = YES;
    }

    return self;
}
- (instancetype)initWithHeadingLevel:(NSInteger)level
{
    self = [super init];
    if (self) {
        [self configWithHeadingLevel:level];
    }

    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fontSize = 17;
        self.styleFont = [UIFont systemFontOfSize:self.fontSize];
    }
    return self;
}

- (instancetype)initWithFontSize:(CGFloat)fontSize
{
    self = [super init];
    if (self) {
        self.fontSize = fontSize;
        self.styleFont = [UIFont systemFontOfSize:self.fontSize];
    }
    return self;
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
}

- (NSParagraphStyle*)defaultParagraphStyle
{
    NSMutableParagraphStyle* ps = [NSMutableParagraphStyle new];

    CGFloat lineSpacingScale = 0.125;
    if (self.level == 1) {
        lineSpacingScale = 1.125;
    } else if (self.level == 2) {
        lineSpacingScale = 2.125;
    }
    ps.lineSpacing = self.fontSize * lineSpacingScale;

    return [ps copy];
}

- (NSDictionary*)strikethoughtAttributes
{
    NSDictionary* textAttribute = [self textAttributes];
    NSMutableDictionary* strikethoughtAttri = [textAttribute mutableCopy];
    [strikethoughtAttri setObject:@(NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
    return [strikethoughtAttri copy];
}

- (NSDictionary*)textAttributes
{

    NSDictionary* textAttri = @{
        NSFontAttributeName : [UIFont systemFontOfSize:self.fontSize],
        NSParagraphStyleAttributeName : [self defaultParagraphStyle]
    };

    if ([self.defaultAttributes isKindOfClass:[NSDictionary class]]) {
        NSDictionary* defautTextAttri = self.defaultAttributes[STYLE_TEXT_ATTRIBUTE_KEY_NAME];
        if ([defautTextAttri isKindOfClass:[NSDictionary class]]) {
            // merge default attributes
            NSMutableDictionary* textAttriMutable = [textAttri mutableCopy];
            [textAttriMutable addEntriesFromDictionary:defautTextAttri];
            textAttri = [textAttriMutable copy];
        }
    }

    if (self.level > 0) {
        textAttri = @{ NSFontAttributeName : [UIFont systemFontOfSize:self.fontSize weight:UIFontWeightSemibold], NSParagraphStyleAttributeName : [self defaultParagraphStyle] };
    } else if (self.isTableHeaderRow == YES) {
        textAttri = @{ NSFontAttributeName : [UIFont systemFontOfSize:self.fontSize weight:UIFontWeightSemibold], NSParagraphStyleAttributeName : [self defaultParagraphStyle] };
    }
    return textAttri;
}

- (NSDictionary*)codeAttributes
{
    NSDictionary* codeAttri = @{
        NSFontAttributeName : [UIFont systemFontOfSize:ceilf(self.fontSize * 0.85)],
        NSBackgroundColorAttributeName : UIColorFromRGB(0xF7F7F9),
        NSParagraphStyleAttributeName : [self defaultParagraphStyle],
    };

    return codeAttri;
}

- (NSDictionary*)linkAttributes
{
    NSDictionary* linkAttri = @{
        NSFontAttributeName : [UIFont italicSystemFontOfSize:ceilf(self.fontSize)],
        NSForegroundColorAttributeName : [UIColor blueColor],
        NSParagraphStyleAttributeName : [self defaultParagraphStyle],
    };

    return linkAttri;
}

- (void)configWithHeadingLevel:(NSInteger)level
{
    NSArray* scaleArray = @[ @(2), @(1.5), @(1.25), @(1), @(0.875), @(0.85) ];
    CGFloat scale = [scaleArray[level - 1] floatValue];
    self.fontSize = ceilf(17 * scale);
}
@end

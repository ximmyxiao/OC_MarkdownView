//
//  InlineTextStyleManager.m
//  testSSE
//
//  Created by ximmy on 2025/4/29.
//

#import "InlineTextStyleManager.h"
#import "MarkdownViewStyleManager.h"

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
        self.fontSize = [MarkdownViewStyleManager sharedInstance].mainFontSize;
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

    CGFloat lineSpacingScale = [MarkdownViewStyleManager sharedInstance].inlineTextLineSpacingScale;
    if (self.level == 1) {
        lineSpacingScale = [MarkdownViewStyleManager sharedInstance].inlineTextLineSpacingScaleInHeadingLevel1;
    } else if (self.level == 2) {
        lineSpacingScale = [MarkdownViewStyleManager sharedInstance].inlineTextLineSpacingScaleInHeadingLevel2;
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
        NSParagraphStyleAttributeName : [self defaultParagraphStyle],
        NSForegroundColorAttributeName : [MarkdownViewStyleManager sharedInstance].mainTextColor
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
        textAttri = @{ NSFontAttributeName : [UIFont systemFontOfSize:self.fontSize weight:UIFontWeightSemibold], NSParagraphStyleAttributeName : [self defaultParagraphStyle], NSForegroundColorAttributeName : [MarkdownViewStyleManager sharedInstance].inlineTextHeadingTextColor};
    } else if (self.isTableHeaderRow == YES) {
        textAttri = @{ NSFontAttributeName : [UIFont systemFontOfSize:self.fontSize weight:UIFontWeightSemibold], NSParagraphStyleAttributeName : [self defaultParagraphStyle]};
    }
    return textAttri;
}

- (NSDictionary*)codeAttributes
{
    NSDictionary* codeAttri = @{
        NSFontAttributeName : [UIFont systemFontOfSize:[MarkdownViewStyleManager sharedInstance].inlineTextCodeFontSize],
        NSForegroundColorAttributeName : [MarkdownViewStyleManager sharedInstance].inlineTextCodeTextColor,
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
    NSArray* headingFontSizeArray = @[ @([MarkdownViewStyleManager sharedInstance].inlineTextFontSizeOfHeadingLevel1),
                                       @([MarkdownViewStyleManager sharedInstance].inlineTextFontSizeOfHeadingLevel2),
                                       @([MarkdownViewStyleManager sharedInstance].inlineTextFontSizeOfHeadingLevel3),
                                       @([MarkdownViewStyleManager sharedInstance].inlineTextFontSizeOfHeadingLevel4),
                                       @([MarkdownViewStyleManager sharedInstance].inlineTextFontSizeOfHeadingLevel5),
                                       @([MarkdownViewStyleManager sharedInstance].inlineTextFontSizeOfHeadingLevel6)
    ];
    self.fontSize = [headingFontSizeArray[level - 1] floatValue];
}
@end

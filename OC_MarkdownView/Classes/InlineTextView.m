//
//  InlineTextView.m
//  testSSE
//
//  Created by ximmy on 2025/4/25.
//

#import "InlineTextView.h"
#import "InlineTextStyleManager.h"

@interface InlineTextView () <NSTextContentStorageDelegate, NSTextLayoutManagerDelegate>
@property (nonatomic, strong) NSTextLayoutManager* textLayoutManager;
@property (nonatomic, strong) NSTextContentStorage* textContentManager;
@property (nonatomic, strong) NSTextContainer* textContainer;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, strong) InlineTextStyleManager* styleManager;

@end

@implementation InlineTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setFrame:(CGRect)frame
{
    if (!CGSizeEqualToSize(self.frame.size, frame.size)) {
        //        NSLog(@"original frame:%@,new frame:%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(frame));
        [super setFrame:frame];
        [self relayoutText];
        [self invalidateIntrinsicContentSize];
    } else {
        [super setFrame:frame];
    }
}
- (void)setBounds:(CGRect)bounds
{
    if (!CGSizeEqualToSize(self.bounds.size, bounds.size)) {
        //        NSLog(@"original bounds:%@,new bounds:%@",NSStringFromCGRect(self.bounds),NSStringFromCGRect(bounds));
        [super setBounds:bounds];
        [self relayoutText];
        [self invalidateIntrinsicContentSize];
    } else {
        [super setBounds:bounds];
    }
}

- (void)relayoutText
{
    [self.textContainer setSize:CGSizeMake(self.bounds.size.width, 10000000)];

    [self.textLayoutManager ensureLayoutForRange:self.textContentManager.documentRange];

    //    CFAbsoluteTime begin = CFAbsoluteTimeGetCurrent();
    //    NSLog(@"relayoutText begin");
    [self.textLayoutManager enumerateTextLayoutFragmentsFromLocation:self.textContentManager.documentRange.location
                                                             options:NSTextLayoutFragmentEnumerationOptionsEnsuresLayout
                                                          usingBlock:^BOOL(NSTextLayoutFragment* _Nonnull layoutFragment) {
                                                              CGFloat width = CGRectGetMaxX(layoutFragment.layoutFragmentFrame);
                                                              if (width > self.contentWidth) {
                                                                  self.contentWidth = width;
                                                              }

                                                              self.contentHeight = CGRectGetMaxY(layoutFragment.layoutFragmentFrame);
                                                              return YES;
                                                          }];
    //    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    //    NSLog(@"relayoutText end,cost:%f",end - begin);
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self.textLayoutManager enumerateTextLayoutFragmentsFromLocation:self.textContentManager.documentRange.location
                                                             options:NSTextLayoutFragmentEnumerationOptionsEnsuresLayout
                                                          usingBlock:^BOOL(NSTextLayoutFragment* _Nonnull layoutFragment) {
                                                              [layoutFragment drawAtPoint:layoutFragment.layoutFragmentFrame.origin inContext:context];
                                                              return YES;
                                                          }];
}

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.textLayoutManager = [[NSTextLayoutManager alloc] init];
    self.textLayoutManager.delegate = self;
    self.textContentManager = [[NSTextContentStorage alloc] init];
    [self.textContentManager addTextLayoutManager:self.textLayoutManager];
    self.textContentManager.delegate = self;
    self.textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(400, 0)];
    self.textContainer.lineFragmentPadding = 0;
    self.textLayoutManager.textContainer = self.textContainer;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setAttributedText:(NSAttributedString*)attributedText
{
    _attributedText = attributedText;
    [self.textContentManager performEditingTransactionUsingBlock:^{
        self.textContentManager.attributedString = self.attributedText;
    }];
    [self relayoutText];
}

- (CGSize)intrinsicContentSize
{

    CGSize size = CGSizeMake(ceilf(self.bounds.size.width), ceilf(self.contentHeight));
    if (self.bounds.size.width == 0) {
        size = CGSizeMake(ceilf(self.contentWidth), ceilf(self.contentHeight));
    }

    return size;
}

- (void)setupStyleManagerWithNode:(CMarkNode*)blockNode withDefaultAttributes:(NSDictionary* _Nullable)defaultAttributes
{
    if ([blockNode headingLevel] >= 1) {
        self.styleManager = [[InlineTextStyleManager alloc] initWithHeadingLevel:blockNode.headingLevel];
    } else if ([blockNode isTableCellInHeader] == YES) {
        self.styleManager = [[InlineTextStyleManager alloc] initWithTableHeaderRow];
    } else {
        self.styleManager = [InlineTextStyleManager new];
    }

    self.styleManager.defaultAttributes = defaultAttributes;
}

- (void)buildFromBlockNode:(CMarkNode*)node
{
    [self buildFromBlockNode:node withAttributes:@{}];
}

- (void)buildFromBlockNode:(CMarkNode*)blockNode withAttributes:(NSDictionary*)predefinedAttributes
{
    [self setupStyleManagerWithNode:blockNode withDefaultAttributes:predefinedAttributes];

    NSDictionary* textAttri = [self.styleManager textAttributes];
    NSDictionary* codeAttri = [self.styleManager codeAttributes];
    NSDictionary* linkAttri = [self.styleManager linkAttributes];
    NSDictionary* strikethroughAttri = [self.styleManager strikethoughtAttributes];

    NSMutableAttributedString* result = [NSMutableAttributedString new];

    for (CMarkNode* node in [blockNode children]) {
        [self processNode:node
               intoString:result
               attributes:@{
                   @"text" : textAttri,
                   @"code" : codeAttri,
                   @"link" : linkAttri,
                   @"strikethrough" : strikethroughAttri,
               }];
    }

    self.attributedText = result;
}

- (NSDictionary*)strongifyTextAttributes:(NSDictionary*)textAttributes
{
    NSMutableDictionary* mutableTextAttri = [textAttributes mutableCopy];
    // get font
    UIFont* font = mutableTextAttri[NSFontAttributeName];
    if ([font isKindOfClass:[UIFont class]]) {
        UIFontDescriptor* fontDescriptor = [font fontDescriptor];
        UIFontDescriptorSymbolicTraits orginalTraits = [fontDescriptor symbolicTraits];
        UIFontDescriptorSymbolicTraits newTraits = orginalTraits | UIFontDescriptorTraitBold;
        UIFontDescriptor* newFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:newTraits];
        font = [UIFont fontWithDescriptor:newFontDescriptor size:0];
    }
    mutableTextAttri[NSFontAttributeName] = font;
    return [mutableTextAttri copy];
}

- (NSDictionary*)emphasisTextAttributes:(NSDictionary*)textAttributes
{
    NSMutableDictionary* mutableTextAttri = [textAttributes mutableCopy];
    // get font
    UIFont* font = mutableTextAttri[NSFontAttributeName];
    if ([font isKindOfClass:[UIFont class]]) {
        UIFontDescriptor* fontDescriptor = [font fontDescriptor];
        UIFontDescriptorSymbolicTraits orginalTraits = [fontDescriptor symbolicTraits];
        UIFontDescriptorSymbolicTraits newTraits = orginalTraits | UIFontDescriptorTraitItalic;
        UIFontDescriptor* newFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:newTraits];
        font = [UIFont fontWithDescriptor:newFontDescriptor size:0];
    }
    mutableTextAttri[NSFontAttributeName] = font;
    return [mutableTextAttri copy];
}

- (void)setNumberOflines:(NSInteger)numberOflines
{
    self.textContainer.maximumNumberOfLines = numberOflines;
}

- (void)processNode:(CMarkNode*)node
         intoString:(NSMutableAttributedString*)result
         attributes:(NSDictionary<NSString*, NSDictionary*>*)attributes
{
    if ([[node nodeTypeName] isEqualToString:NodeTypeText]) {
        NSAttributedString* text = [[NSAttributedString alloc] initWithString:[node text] attributes:attributes[@"text"]];
        [result appendAttributedString:text];
    } else if ([[node nodeTypeName] isEqualToString:NodeTypeCode]) {
        NSAttributedString* code = [[NSAttributedString alloc] initWithString:[node text] attributes:attributes[@"code"]];
        [result appendAttributedString:code];
    } else if ([[node nodeTypeName] isEqualToString:NodeTypeStrong]) {
        NSMutableAttributedString* strong = [[NSMutableAttributedString alloc] init];

        for (CMarkNode* child in [node children]) {
            NSMutableDictionary* strongAttributes = [attributes mutableCopy];
            strongAttributes[@"text"] = [self strongifyTextAttributes:attributes[@"text"]];
            [self processNode:child intoString:strong attributes:[strongAttributes copy]];
        }
        [result appendAttributedString:strong];
    } else if ([[node nodeTypeName] isEqualToString:NodeTypeEmphasis]) {
        NSMutableAttributedString* emphasis = [[NSMutableAttributedString alloc] init];
        for (CMarkNode* child in [node children]) {
            NSMutableDictionary* emphasisAttributes = [attributes mutableCopy];
            emphasisAttributes[@"text"] = [self emphasisTextAttributes:attributes[@"text"]];

            [self processNode:child intoString:emphasis attributes:[emphasisAttributes copy]];
        }
        [result appendAttributedString:emphasis];
    } else if ([[node nodeTypeName] isEqualToString:NodeTypeStrikethrough]) {
        NSMutableAttributedString* strikethrough = [[NSMutableAttributedString alloc] init];
        for (CMarkNode* child in [node children]) {
            [self processNode:child intoString:strikethrough attributes:attributes];
        }
        [strikethrough addAttributes:attributes[@"strikethrough"] range:NSMakeRange(0, strikethrough.length)];
        [result appendAttributedString:strikethrough];
    } else if ([[node nodeTypeName] isEqualToString:NodeTypeLink]) {
        NSMutableAttributedString* link = [[NSMutableAttributedString alloc] init];
        for (CMarkNode* child in [node children]) {
            [self processNode:child intoString:link attributes:attributes];
        }
        [link addAttributes:attributes[@"link"] range:NSMakeRange(0, link.length)];
        NSString* url = [node nodeURL];
        [link addAttributes:@{ kURLInMarkDownKey : url } range:NSMakeRange(0, link.length)];
        [result appendAttributedString:link];
    } else if ([[node nodeTypeName] isEqualToString:NodeTypeLineBreak]) {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    CGPoint point = [touches.anyObject locationInView:self];
    NSTextLayoutFragment* fragment = [self.textLayoutManager textLayoutFragmentForPosition:point];

    NSLog(@"fragment:%@,element:%@", fragment, fragment.textElement);
    NSTextLineFragment* line = [fragment textLineFragmentForVerticalOffset:point.y - fragment.layoutFragmentFrame.origin.y requiresExactMatch:YES];
    NSLog(@"line:%@,attri:%@", line, line.attributedString);
    NSInteger index = [line characterIndexForPoint:point];
    NSLog(@"index:%ld", index);
    // 当点击在没有内容的区块时，如果是单行内容则会返回一个超大的整数，如果是多行内容，则index=该line的内容实际长度+1，所以需要避免这两个异常场景
    if (index >= 0 && index < [line.attributedString length]) {
        [line.attributedString enumerateAttribute:kURLInMarkDownKey
                                          inRange:NSMakeRange(0, [line.attributedString length])
                                          options:NSAttributedStringEnumerationReverse
                                       usingBlock:^(id _Nullable value, NSRange range, BOOL* _Nonnull stop) {
                                           NSLog(@"value:%@,range:%@", value, NSStringFromRange(range));
                                           if (value != nil) {
                                               NSDictionary* attributes = [line.attributedString attributesAtIndex:index effectiveRange:nil];
                                               NSString* url = @"";
                                               if ([attributes[kURLInMarkDownKey] isKindOfClass:[NSString class]]) {
                                                   url = attributes[kURLInMarkDownKey];
                                               } else if (index > range.location && index < range.location + range.length) {
                                                   NSLog(@"hit:%@", [line.attributedString attributedSubstringFromRange:range]);
                                                   url = [[line.attributedString attributedSubstringFromRange:range] string];
                                               }

                                               NSLog(@"url clicked:%@", url);
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                                               return;
                                           }
                                       }];
    }

    [super touchesEnded:touches withEvent:event];
}

- (UIFont*)firstLineFont
{
    if (self.textContentManager.attributedString.length == 0) {
        return nil; // No content, return nil
    }

    NSTextLayoutFragment* firstFrgment = [self.textLayoutManager textLayoutFragmentForLocation:self.textContentManager.documentRange.location];
    NSTextLineFragment* firstLine = [firstFrgment textLineFragmentForVerticalOffset:0 requiresExactMatch:YES];
    if ([firstLine isKindOfClass:[NSTextLineFragment class]]) {
        UIFont* firstLineFont = [firstLine.attributedString attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        return firstLineFont;
    }
    return nil; // No content, return nil
}

@end

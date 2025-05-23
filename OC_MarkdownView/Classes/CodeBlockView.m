//
//  CodeBlockView.m
//  testSSE
//
//  Created by ximmy on 2025/4/14.
//

#import "CodeBlockView.h"

@interface CodeBlockView ()
@property (nonatomic, strong) UIStackView* stackView;
@end

@implementation CodeBlockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)constructUI
{
    [self.stackView removeFromSuperview];
    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.stackView];
    [self addConstraints:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self constructUI];
    }
    return self;
}

- (void)commonInit
{
}

- (void)setNode:(CMarkNode*)node
{
    _node = node;
    [self updateUI];
}

- (void)updateUI
{
    // remove all arrangedSubviews from stackView
    [[self.stackView arrangedSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableAttributedString* result = [NSMutableAttributedString new];

    NSString* code = [self.node text];
    if ([code hasSuffix:@"\n"]) {
        code = [code substringToIndex:code.length - 1];
    }

    NSDictionary* attributes = [self getAttributes];
    NSAttributedString* text = [[NSAttributedString alloc] initWithString:code attributes:attributes];
    [result appendAttributedString:text];

    UILabel* label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    label.attributedText = result;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.contentInset = UIEdgeInsetsMake(16, 16, 16, 16);
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.backgroundColor = UIColorFromRGB(0xF7F7F9);
    scrollView.layer.cornerRadius = 6;
    scrollView.layer.masksToBounds = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView addSubview:label];

    CGFloat scrollViewHeight = ceilf(label.frame.size.height + 16 * 2);
    [scrollView addConstraints:@[
        [scrollView.contentLayoutGuide.topAnchor constraintEqualToAnchor:label.topAnchor
                                                                constant:0],
        [scrollView.contentLayoutGuide.leadingAnchor constraintEqualToAnchor:label.leadingAnchor
                                                                    constant:0],
        [scrollView.contentLayoutGuide.trailingAnchor constraintEqualToAnchor:label.trailingAnchor
                                                                     constant:0],
        [scrollView.contentLayoutGuide.bottomAnchor constraintEqualToAnchor:label.bottomAnchor
                                                                   constant:0],
        [scrollView.heightAnchor constraintEqualToConstant:scrollViewHeight],

    ]];

    [self.stackView addArrangedSubview:scrollView];
}

- (NSDictionary*)getAttributes
{

    NSMutableParagraphStyle* psDefault = [NSMutableParagraphStyle new];
    psDefault.lineSpacing = 0.225 * 17;
    NSDictionary* attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:ceil(17 * 0.85)],
        NSParagraphStyleAttributeName : psDefault,
    };
    return attributes;
}

@end

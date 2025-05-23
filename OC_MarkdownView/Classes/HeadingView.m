//
//  HeadingView.m
//  testSSE
//
//  Created by ximmy on 2025/4/14.
//

#import "HeadingView.h"
#import "InlineTextView.h"

@interface HeadingView ()
@property (nonatomic, strong) UIStackView* stackView;
@end

@implementation HeadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)constructUI
{
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
    InlineTextView* content = [InlineTextView new];
    content.translatesAutoresizingMaskIntoConstraints = NO;
    [content buildFromBlockNode:self.node];
    [self.stackView addArrangedSubview:content];

    if ([self.node headingLevel] >= 1 && [self.node headingLevel] <= 2) {
        UIView* separator = [UIView new];
        [separator addConstraint:[separator.heightAnchor constraintEqualToConstant:16]];
        separator.backgroundColor = [UIColor clearColor];
        [self.stackView addArrangedSubview:separator];

        UIView* separatorLine = [UIView new];
        [separatorLine addConstraint:[separatorLine.heightAnchor constraintEqualToConstant:1 / [UIScreen mainScreen].scale]];
        separatorLine.backgroundColor = [UIColor separatorColor];
        [self.stackView addArrangedSubview:separatorLine];
    }
}

@end

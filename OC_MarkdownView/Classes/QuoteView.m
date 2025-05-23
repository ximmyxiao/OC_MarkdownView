//
//  QuoteView.m
//  testSSE
//
//  Created by ximmy on 2025/5/19.
//

#import "QuoteView.h"
#import "NodeToViewManager.h"

@interface QuoteView ()
@property (nonatomic, strong) UIStackView* stackView;
@end

@implementation QuoteView

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
    self.stackView.spacing = 8;
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
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
        [self constructUI];
    }
    return self;
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
    UIView* quoteMarker = [UIView new];
    quoteMarker.backgroundColor = [UIColor borderColor];
    quoteMarker.layer.cornerRadius = 5;
    quoteMarker.layer.masksToBounds = YES;
    quoteMarker.translatesAutoresizingMaskIntoConstraints = NO;
    [quoteMarker addConstraint:[quoteMarker.widthAnchor constraintEqualToConstant:4]];
    [self.stackView addArrangedSubview:quoteMarker];

    UIView* view = [[NodeToViewManager sharedInstance] viewForNode:self.node withDefaultAttributes:@{ STYLE_TEXT_ATTRIBUTE_KEY_NAME : @ { NSForegroundColorAttributeName : [UIColor secondaryTextColor] } }];
    [self.stackView addArrangedSubview:view];

    UIView* contentView = [UIView new];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor redColor];
    [self.stackView addArrangedSubview:contentView];
}

@end

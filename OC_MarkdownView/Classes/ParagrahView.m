//
//  ParagrahView.m
//  testSSE
//
//  Created by ximmy on 2025/3/5.
//

#import "ParagrahView.h"
#import "InlineTextView.h"

@interface ParagrahView()
@property (nonatomic, strong) UIStackView *stackView;
@end

@implementation ParagrahView

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
        [self constructUI];
    }
    return self;
}
- (void)setNode:(CMarkNode *)node
{
    _node = node;
    [self updateUI];
}

- (void)updateUI
{
    //remove all arrangedSubviews from stackView
    [[self.stackView arrangedSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    UIView* topSeparator = [UIView new];
//    topSeparator.translatesAutoresizingMaskIntoConstraints = NO;
//    topSeparator.backgroundColor = [UIColor clearColor];
//    [topSeparator addConstraint:[topSeparator.heightAnchor constraintEqualToConstant:17]];
//    [self.stackView addArrangedSubview:topSeparator];
    
    InlineTextView* content = [InlineTextView new];
    content.translatesAutoresizingMaskIntoConstraints = NO;
    if ([self.defaultAttributes isKindOfClass:[NSDictionary class]])
    {
        [content buildFromBlockNode:self.node withAttributes:self.defaultAttributes];
    }
    else
    {
        [content buildFromBlockNode:self.node];
    }
    
    [self.stackView addArrangedSubview:content];

}
@end

//
//  TableColumnView.m
//  testSSE
//
//  Created by ximmy on 2025/4/22.
//

#import "TableColumnView.h"
#import "InlineTextView.h"

@interface TableColumnView ()
@property (nonatomic, strong) UIStackView* stackView;
@end

@implementation TableColumnView

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

- (void)setNodes:(NSArray<CMarkNode*>*)nodes
{
    _nodes = nodes;
    [self updateUI];
}

- (void)updateUI
{
    // remove all arrangedSubviews from stackView
    [[self.stackView arrangedSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    BOOL isFirstNode = YES;
    for (CMarkNode* node in self.nodes) {
        if (!isFirstNode) {
            UIView* separator = [UIView new];
            separator.translatesAutoresizingMaskIntoConstraints = NO;
            separator.backgroundColor = [UIColor borderColor];
            [separator addConstraint:[separator.heightAnchor constraintEqualToConstant:.5]];
            [self.stackView addArrangedSubview:separator];
        }

        if ([[node nodeTypeName] isEqualToString:NodeTypeTableCell]) {
            InlineTextView* lineView = [InlineTextView new];
            lineView.translatesAutoresizingMaskIntoConstraints = NO;
            [lineView setNumberOflines:1];
            [lineView buildFromBlockNode:node];

            UIView* wrapperView = [UIView new];
            wrapperView.translatesAutoresizingMaskIntoConstraints = NO;
            wrapperView.backgroundColor = [UIColor clearColor];
            [wrapperView addSubview:lineView];

            [wrapperView addConstraints:@[

                [lineView.topAnchor constraintEqualToAnchor:wrapperView.topAnchor
                                                   constant:6],
                [lineView.leadingAnchor constraintEqualToAnchor:wrapperView.leadingAnchor
                                                       constant:13],
                [wrapperView.trailingAnchor constraintEqualToAnchor:lineView.trailingAnchor
                                                           constant:13],
                [wrapperView.bottomAnchor constraintEqualToAnchor:lineView.bottomAnchor
                                                         constant:6]
            ]];
            [self.stackView addArrangedSubview:wrapperView];
            isFirstNode = NO;
        }
    }
}
@end

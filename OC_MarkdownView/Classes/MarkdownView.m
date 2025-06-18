//
//  SSEContentView.m
//  testSSE
//
//  Created by ximmy on 2025/2/26.
//

#import "MarkdownView.h"
#import "CMarkNode.h"
#import "NodeToViewManager.h"

@interface MarkdownView ()
@property (nonatomic, strong) UIStackView* contentStackView;
@property (nonatomic, strong) UIStackView* replyStackView;
@property (nonatomic, assign) cmark_list_type currentListType;
@property (nonatomic, assign) NSInteger currentListItemNumber;
@property (nonatomic, strong) CMarkNode* markdownNode;
@property (nonatomic, assign) CGSize layoutSize;
@property (nonatomic, assign) BOOL isBoundsSet;
@end

@implementation MarkdownView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (!CGSizeEqualToSize(self.frame.size, frame.size)) {
        //        NSLog(@"original frame:%@,new frame:%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(frame));
        [super setFrame:frame];
        [self relayoutSize];
    } else {
        [super setFrame:frame];
    }
}
- (void)setBounds:(CGRect)bounds
{
    self.isBoundsSet = YES;

    if (!CGSizeEqualToSize(self.bounds.size, bounds.size)) {
        //        NSLog(@"original bounds:%@,new bounds:%@",NSStringFromCGRect(self.bounds),NSStringFromCGRect(bounds));
        [super setBounds:bounds];
        [self relayoutSize];

    } else {
        [super setBounds:bounds];
    }
}

- (void)setupUI
{
    self.contentStackView = [[UIStackView alloc] init];
    self.contentStackView.axis = UILayoutConstraintAxisVertical;
    self.contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.contentStackView];
    [self addConstraints:@[
        [self.contentStackView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.contentStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.contentStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.contentStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];

    self.replyStackView = [[UIStackView alloc] init];
    self.replyStackView.axis = UILayoutConstraintAxisVertical;
    self.replyStackView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentStackView addArrangedSubview:self.replyStackView];
}

- (void)setMarkdownText:(NSString*)markdownText
{
    _markdownText = markdownText;

    NSLog(@"setMarkdownText:%@", markdownText);

    self.markdownNode = [[CMarkNode alloc] initWithMarkdownString:markdownText];
    [self.markdownNode printAST];
    [[self.replyStackView arrangedSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if ([self.markdownNode childCount] > 0) {
        UIView* view = [[NodeToViewManager sharedInstance] viewForNode:self.markdownNode];
        [self.replyStackView addArrangedSubview:view];
    }

    [self relayoutSize];
}

- (void)relayoutSize
{
    if (self.isBoundsSet == YES)
    {
        NSLog(@"resetLayoutSize self size :%@", NSStringFromCGSize(self.bounds.size));

        UIView* view2 = [[NodeToViewManager sharedInstance] viewForNode:self.markdownNode];

        [view2 addConstraints:@[ [view2.widthAnchor constraintEqualToConstant:self.bounds.size.width] ]];
        view2.bounds = self.bounds;
        [view2 layoutIfNeeded];
        CGSize size = [view2 systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        NSLog(@"print constraints:%@", [view2 constraintsAffectingLayoutForAxis:1]);
        NSLog(@"resetLayoutSize oldsize :%@", NSStringFromCGSize(size));

        self.layoutSize = [view2 systemLayoutSizeFittingSize:CGSizeMake(view2.bounds.size.width, 0) withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
        NSLog(@"resetLayoutSize :%@", NSStringFromCGSize(self.layoutSize));
        [self invalidateIntrinsicContentSize];
    }
    else
    {
        self.layoutSize = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
    }

}


/*
 Returning (-1, -1) fix the bug when the initial intrinsic size is incorrect (because the view's size is not set by the layout system, but rather by the XIB's size,so the layoutSize is not the correct size). The layout system uses this incorrect size as the cell's constraint for subsequent layouts. Returning (-1, -1) ensures that this incorrect value does not affect the layout constraints.  For example, if you create an invalid constraint with a height of 50, there will be a constraint like "height >= 50 @750". This constraint will influence the layout calculations.  However, if you set it to "height >= -1 @750", this constraint will still be part of the constraint equations group but will not have any actual effect. The layout system will use  other constraints to calculate the correct size.
 */

- (CGSize)intrinsicContentSize
{
    return self.layoutSize;
}

@end

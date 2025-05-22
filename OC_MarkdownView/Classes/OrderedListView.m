//
//  OrderedListView.m
//  testSSE
//
//  Created by ximmy on 2025/4/18.
//

#import "OrderedListView.h"
#import "NodeToViewManager.h"
#import "UIImage+Ex.h"

@interface OrderedListView()
@property (nonatomic, strong) UIStackView *stackView;
@end


@implementation OrderedListView

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

- (void)setNode:(CMarkNode *)node
{
    _node = node;
    [self updateUI];
}

- (void)updateUI
{
    //remove all arrangedSubviews from stackView
    [[self.stackView arrangedSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger index = 0;
    for (CMarkNode *child in [self.node children]) {
        index ++;
        if ([[child nodeTypeName] isEqualToString:NodeTypeItem]) {
            UIStackView* itemStackView = [[UIStackView alloc] init];
            itemStackView.axis = UILayoutConstraintAxisHorizontal;
            itemStackView.translatesAutoresizingMaskIntoConstraints = NO;

            UIFont* indexFont = [UIFont systemFontOfSize:17];
            UILabel* indexLabel = [[UILabel alloc] init];
            indexLabel.translatesAutoresizingMaskIntoConstraints = NO;
            indexLabel.text = [NSString stringWithFormat:@"%ld.", index];
            indexLabel.font = indexFont;
            [indexLabel setContentHuggingPriority:UILayoutPriorityDefaultLow + 1 forAxis:UILayoutConstraintAxisHorizontal];
            [indexLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1 forAxis:UILayoutConstraintAxisHorizontal];
//            [itemStackView addArrangedSubview:imageView];

            UIView* view = [[NodeToViewManager sharedInstance] viewForNode:child];
//            [itemStackView addArrangedSubview:view];
            
            UIView* wrapperView = [UIView new];
            wrapperView.translatesAutoresizingMaskIntoConstraints = NO;
            [wrapperView addSubview:indexLabel];
            [wrapperView addSubview:view];
           
            CGFloat lineHeight = [NodeToViewManager firstTextLineBaseOfView:view];

            
            if (lineHeight > 0)
            {
                [wrapperView addConstraints:@[
                    [indexLabel.leadingAnchor constraintEqualToAnchor:wrapperView.leadingAnchor],
                    [indexLabel.topAnchor constraintEqualToAnchor:wrapperView.topAnchor constant:lineHeight / 2 - [indexFont lineHeight] / 2],
                    [view.topAnchor constraintEqualToAnchor:wrapperView.topAnchor],
                    [view.leadingAnchor constraintEqualToAnchor:indexLabel.trailingAnchor constant:5],
                    [view.bottomAnchor constraintEqualToAnchor:wrapperView.bottomAnchor],
                    [view.trailingAnchor constraintEqualToAnchor:wrapperView.trailingAnchor],
                    
                ]];
            }
            else
            {
                [wrapperView addConstraints:@[
                    [indexLabel.leadingAnchor constraintEqualToAnchor:wrapperView.leadingAnchor],
                    [indexLabel.topAnchor constraintEqualToAnchor:wrapperView.topAnchor constant:0],
                    [view.topAnchor constraintEqualToAnchor:wrapperView.topAnchor],
                    [view.leadingAnchor constraintEqualToAnchor:indexLabel.trailingAnchor constant:5],
                    [view.bottomAnchor constraintEqualToAnchor:wrapperView.bottomAnchor],
                    [view.trailingAnchor constraintEqualToAnchor:wrapperView.trailingAnchor],
                    
                ]];
            }
            
            [self.stackView addArrangedSubview:wrapperView];
        }
    }
    
}

@end

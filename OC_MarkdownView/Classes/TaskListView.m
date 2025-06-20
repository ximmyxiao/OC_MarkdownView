//
//  TaskListView.m
//  testSSE
//
//  Created by ximmy on 2025/4/15.
//

#import "TaskListView.h"
#import "NodeToViewManager.h"
#import "MarkdownViewStyleManager.h"

@interface TaskListView ()
@property (nonatomic, strong) UIStackView* stackView;
@end

@implementation TaskListView

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
    for (CMarkNode* child in [self.node children]) {
        if ([[child nodeTypeName] isEqualToString:NodeTypeTaskListItem]) {
            UIStackView* itemStackView = [[UIStackView alloc] init];
            itemStackView.axis = UILayoutConstraintAxisHorizontal;
            itemStackView.translatesAutoresizingMaskIntoConstraints = NO;
            BOOL isCompleted = [child isTaskListItemChecked];
            UIImage* image = [MarkdownViewStyleManager sharedInstance].taskListImageMarker;
            if (isCompleted)
            {
                image = [MarkdownViewStyleManager sharedInstance].taskListImageMarkerForCompleted;
            }
            UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.contentMode = UIViewContentModeTop;
            [imageView addConstraints:@[ [imageView.widthAnchor constraintEqualToConstant:[MarkdownViewStyleManager sharedInstance].listImageMarkerWidth] ]];
            [itemStackView addArrangedSubview:imageView];

            UIView* view = [[NodeToViewManager sharedInstance] viewForNode:child];
            [itemStackView addArrangedSubview:view];

            [self.stackView addArrangedSubview:itemStackView];
        }
    }
}
@end

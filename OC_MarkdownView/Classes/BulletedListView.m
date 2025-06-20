//
//  BulletedListView.m
//  testSSE
//
//  Created by  ximmyxiao on 4/15/25.
//

#import "BulletedListView.h"
#import "NodeToViewManager.h"
#import "MarkdownViewStyleManager.h"

@interface BulletedListView ()
@property (nonatomic, strong) UIStackView* stackView;
@end

@implementation BulletedListView

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
        if ([[child nodeTypeName] isEqualToString:NodeTypeItem]) {
            UIStackView* itemStackView = [[UIStackView alloc] init];
            itemStackView.axis = UILayoutConstraintAxisHorizontal;
            itemStackView.translatesAutoresizingMaskIntoConstraints = NO;


            UIImage* markerImage = [MarkdownViewStyleManager sharedInstance].bulletedListImageMarker;
            UIImageView* imageView = [[UIImageView alloc] initWithImage:markerImage];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.contentMode = UIViewContentModeTop;
            [imageView addConstraints:@[ [imageView.widthAnchor constraintEqualToConstant:[MarkdownViewStyleManager sharedInstance].listImageMarkerWidth] ]];
            //            [itemStackView addArrangedSubview:imageView];

            UIView* view = [[NodeToViewManager sharedInstance] viewForNode:child];
            //            [itemStackView addArrangedSubview:view];

            UIView* wrapperView = [UIView new];
            wrapperView.translatesAutoresizingMaskIntoConstraints = NO;
            [wrapperView addSubview:imageView];
            [wrapperView addSubview:view];

            CGFloat lineHeight = [NodeToViewManager firstTextLineBaseOfView:view];

            if (lineHeight > 0) {
                [wrapperView addConstraints:@[
                    [imageView.leadingAnchor constraintEqualToAnchor:wrapperView.leadingAnchor],
                    [imageView.topAnchor constraintEqualToAnchor:wrapperView.topAnchor
                                                        constant:lineHeight / 2 - markerImage.size.height / 2],
                    [view.topAnchor constraintEqualToAnchor:wrapperView.topAnchor],
                    [view.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor
                                                       constant:[MarkdownViewStyleManager sharedInstance].spacingBetweenListImageMarkerAndText],
                    [view.bottomAnchor constraintEqualToAnchor:wrapperView.bottomAnchor],
                    [view.trailingAnchor constraintEqualToAnchor:wrapperView.trailingAnchor],

                ]];
            } else {
                [wrapperView addConstraints:@[
                    [imageView.leadingAnchor constraintEqualToAnchor:wrapperView.leadingAnchor],
                    [imageView.topAnchor constraintEqualToAnchor:wrapperView.topAnchor
                                                        constant:0],
                    [view.topAnchor constraintEqualToAnchor:wrapperView.topAnchor],
                    [view.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor
                                                       constant:[MarkdownViewStyleManager sharedInstance].spacingBetweenListImageMarkerAndText],
                    [view.bottomAnchor constraintEqualToAnchor:wrapperView.bottomAnchor],
                    [view.trailingAnchor constraintEqualToAnchor:wrapperView.trailingAnchor],

                ]];
            }

            [self.stackView addArrangedSubview:wrapperView];
        }
    }
}

@end

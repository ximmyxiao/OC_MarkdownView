//
//  TableView.m
//  testSSE
//
//  Created by ximmy on 2025/4/22.
//

#import "TableView.h"
#import "TableColumnView.h"

@interface TableView ()
@property (nonatomic, strong) UIStackView* stackView;
@property (nonatomic, strong) UIScrollView* scrollView;
@end

@implementation TableView

- (void)constructUI
{
    UIColor* borderColor = UIColorFromRGB(0xe4e4e8);
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;

    [self.scrollView removeFromSuperview];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.scrollView];
    [self addConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];

    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.stackView];
    [self addConstraints:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.stackView.heightAnchor constraintEqualToAnchor:self.scrollView.heightAnchor]
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
    // Remove all arrangedSubviews from stackView
    [[self.stackView arrangedSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    BOOL isFirstNode = YES;

    for (CMarkNode* child in [self.node children]) {
        if ([[child nodeTypeName] isEqualToString:NodeTypeTableHead]) {
            // Create a TableColumnView for each child node
            NSInteger headColumnCount = [child childCount];
            for (NSInteger i = 0; i < headColumnCount; i++) {
                if (!isFirstNode) {
                    UIView* separator = [UIView new];
                    separator.translatesAutoresizingMaskIntoConstraints = NO;
                    separator.backgroundColor = [UIColor borderColor];
                    [separator addConstraint:[separator.widthAnchor constraintEqualToConstant:0.5]];
                    [self.stackView addArrangedSubview:separator];
                }

                NSMutableArray* nodes = [NSMutableArray array];

                for (CMarkNode* child2 in [self.node children]) {
                    if ([[child2 children] count] > i) {
                        [nodes addObject:[child2 childAtIndex:i]];
                    } else {
                        CMarkNode* node = [[CMarkNode alloc] init];
                        [nodes addObject:node];
                    }
                }

                TableColumnView* columnView = [[TableColumnView alloc] init];
                columnView.nodes = nodes;
                [self.stackView addArrangedSubview:columnView];
                isFirstNode = NO;
            }

            return;
        }
    }
}

@end

//
//  NodeToViewManager.m
//  testSSE
//
//  Created by ximmy on 2025/4/15.
//

#import "NodeToViewManager.h"
#import "ParagrahView.h"
#import "HeadingView.h"
#import "CodeBlockView.h"
#import "TaskListView.h"
#import "BulletedListView.h"
#import "OrderedListView.h"
#import "TableView.h"
#import "InlineTextView.h"
#import "QuoteView.h"

@implementation NodeToViewManager
//share instance
+ (instancetype)sharedInstance {
    static NodeToViewManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (CGFloat)firstTextLineBaseOfView:(UIView*)containerView
{
    UIView* firstSubview = nil;
    if ([containerView isKindOfClass:[UIStackView class]])
    {
        firstSubview = [[(UIStackView*)containerView arrangedSubviews] firstObject];
    }
    else
    {
        firstSubview = [[containerView subviews] firstObject];
    }
    
    if (firstSubview == nil)
    {
        return 0;
    }
    
    if ([firstSubview isKindOfClass:[InlineTextView class]])
    {
        InlineTextView* inlineTextView = (InlineTextView*)firstSubview;
        UIFont* font = [inlineTextView firstLineFont];
        if (![font isKindOfClass:[UIFont class]])
        {
            return 0;
        }
        return font.lineHeight;
    }
    else
    {
        return [self firstTextLineBaseOfView:firstSubview];
    }
    
    return 0;
}

- (UIView*)viewForNode:(CMarkNode *)node withDefaultAttributes:(NSDictionary*)attributes
{
    // 根据节点类型处理内容
    UIStackView* resultStackView = [[UIStackView alloc] init];
    resultStackView.axis = UILayoutConstraintAxisVertical;
    resultStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CMarkNode* currentNode = [node childAtIndex:0];
    while (currentNode)
    {
        NSString* type = [currentNode nodeTypeName];
        if ([type isEqualToString:NodeTypeParagraph])
        {
            ParagrahView* paraView = [ParagrahView new];
            paraView.defaultAttributes = attributes;
            paraView.node = currentNode;
            [resultStackView addArrangedSubview:paraView];
            
        }
        else if ([type isEqualToString:NodeTypeHeading])
        {
            HeadingView* headingView = [HeadingView new];
            headingView.node = currentNode;
            [resultStackView addArrangedSubview:headingView];
        }
        else if ([type isEqualToString:NodeTypeCodeBlock])
        {
            CodeBlockView* codeBlockView = [CodeBlockView new];
            codeBlockView.node = currentNode;
            [resultStackView addArrangedSubview:codeBlockView];
        }
        else if ([type isEqualToString:NodeTypeList])
        {
            BOOL isTaskList = NO;

            for (CMarkNode* child in [currentNode children])
            {
                NSLog(@"child node type: %@", [child nodeTypeName]);
                if ([[child nodeTypeName] isEqualToString:NodeTypeTaskListItem])
                {
                    isTaskList = YES;
                    break;
                }
            }
            
            if (isTaskList)
            {
                TaskListView* taskListView = [TaskListView new];
                taskListView.node = currentNode;
                [resultStackView addArrangedSubview:taskListView];
            }
            else if ([currentNode listType] == CMARK_BULLET_LIST)
            {
                BulletedListView* bulletedListView = [BulletedListView new];
                bulletedListView.node = currentNode;
                [resultStackView addArrangedSubview:bulletedListView];
            }
            else if ([currentNode listType] == CMARK_ORDERED_LIST)
            {
                OrderedListView* orderedListView = [OrderedListView new];
                orderedListView.node = currentNode;
                [resultStackView addArrangedSubview:orderedListView];
            }
        }
        else if ([type isEqualToString:NodeTypeTable])
        {
            TableView* tableView = [TableView new];
            tableView.node = currentNode;
            [resultStackView addArrangedSubview:tableView];
        
        }
        else if ([type isEqualToString:NodeTypeThematicBreak])
        {
            UIView* separator = [UIView new];
            separator.translatesAutoresizingMaskIntoConstraints = NO;
            separator.backgroundColor = [UIColor borderColor];
            [separator addConstraint:[separator.heightAnchor constraintEqualToConstant:1]];
            [resultStackView addArrangedSubview:separator];

        }
        else if ([type isEqualToString:NodeTypeBlockquote])
        {
            QuoteView* quoteView = [QuoteView new];
            quoteView.node = currentNode;
            [resultStackView addArrangedSubview:quoteView];
        }
        else
        {
            UILabel* result = [UILabel new];
            result.backgroundColor = [UIColor greenColor];
            result.text = @"UNKNOWN";
            [resultStackView addArrangedSubview:result];
        }
        
        CGFloat bottomSeparatorHeight = 10;
        if ([[node nodeTypeName] isEqualToString:NodeTypeDocument])
        {
            bottomSeparatorHeight = 17;
        }
        
        UIView* bottomSeparator = [UIView new];
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = NO;
        bottomSeparator.backgroundColor = [UIColor clearColor];
        [bottomSeparator addConstraint:[bottomSeparator.heightAnchor constraintEqualToConstant:bottomSeparatorHeight]];
        [resultStackView addArrangedSubview:bottomSeparator];

        
        currentNode = [currentNode next];
    }
    
    if ([[node nodeTypeName] isEqualToString:NodeTypeDocument])
    {
        UIView* padView = [UIView new];
        padView.backgroundColor = [UIColor greenColor];
        [resultStackView addArrangedSubview:padView];
//        [self.stackView addArrangedSubview:padView];
    }
    
    return resultStackView;
}

- (UIView *)viewForNode:(CMarkNode *)node
{
    return [self viewForNode:node withDefaultAttributes:nil];
}

@end

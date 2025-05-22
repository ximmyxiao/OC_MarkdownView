//
//  CMarkNode.h
//  testSSE
//
//  Created by ximmy on 2025/3/5.
//

#ifndef CMarkNode_h
#define CMarkNode_h

#import <Foundation/Foundation.h>
#import <libcmark_gfm/libcmark_gfm.h>
typedef NSString *NodeType NS_STRING_ENUM;

// 基本类型
FOUNDATION_EXPORT NodeType const NodeTypeDocument;
FOUNDATION_EXPORT NodeType const NodeTypeBlockquote;
FOUNDATION_EXPORT NodeType const NodeTypeList;
FOUNDATION_EXPORT NodeType const NodeTypeItem;
FOUNDATION_EXPORT NodeType const NodeTypeCodeBlock;
FOUNDATION_EXPORT NodeType const NodeTypeHtmlBlock;
FOUNDATION_EXPORT NodeType const NodeTypeCustomBlock;
FOUNDATION_EXPORT NodeType const NodeTypeParagraph;
FOUNDATION_EXPORT NodeType const NodeTypeHeading;
FOUNDATION_EXPORT NodeType const NodeTypeThematicBreak;
FOUNDATION_EXPORT NodeType const NodeTypeText;
FOUNDATION_EXPORT NodeType const NodeTypeSoftBreak;
FOUNDATION_EXPORT NodeType const NodeTypeLineBreak;
FOUNDATION_EXPORT NodeType const NodeTypeCode;
FOUNDATION_EXPORT NodeType const NodeTypeHtml;
FOUNDATION_EXPORT NodeType const NodeTypeCustomInline;
FOUNDATION_EXPORT NodeType const NodeTypeEmphasis;
FOUNDATION_EXPORT NodeType const NodeTypeStrong;
FOUNDATION_EXPORT NodeType const NodeTypeLink;
FOUNDATION_EXPORT NodeType const NodeTypeImage;
FOUNDATION_EXPORT NodeType const NodeTypeInlineAttributes;
FOUNDATION_EXPORT NodeType const NodeTypeNone;
FOUNDATION_EXPORT NodeType const NodeTypeUnknown;

// 扩展类型
FOUNDATION_EXPORT NodeType const NodeTypeStrikethrough;
FOUNDATION_EXPORT NodeType const NodeTypeTable;
FOUNDATION_EXPORT NodeType const NodeTypeTableHead;
FOUNDATION_EXPORT NodeType const NodeTypeTableRow;
FOUNDATION_EXPORT NodeType const NodeTypeTableCell;
FOUNDATION_EXPORT NodeType const NodeTypeTaskListItem;

typedef NS_ENUM(NSUInteger, CMarkNodeType) {
    CMarkNodeTypeDocument,
    CMarkNodeTypeParagraph,
    CMarkNodeTypeHeading,
    CMarkNodeTypeText,
    CMarkNodeTypeBold,
    CMarkNodeTypeItalic,
    CMarkNodeTypeLink,
    CMarkNodeTypeImage,
    // 根据需要添加更多节点类型
};

@interface CMarkNode : NSObject

@property (nonatomic, readonly) cmark_node *node;

// 初始化方法
- (instancetype)initWithMarkdownString:(NSString *)markdown;
+ (instancetype)nodeWithMarkdownString:(NSString *)markdown;

// 节点操作
- (CMarkNode *)childAtIndex:(NSUInteger)index;
- (NSUInteger)childCount;
- (CMarkNode *)next;
- (CMarkNode *)previous;


- (NSString *)nodeTypeName;
// 获取文本内容
- (NSString *)text;
- (NSInteger)headingLevel;
- (BOOL)isTightList;
- (BOOL)isTaskListItemChecked;
- (cmark_list_type)listType;
- (NSString*)nodeURL;
- (BOOL)isTableCellInHeader;

- (void)printAST;
// 遍历
- (void)enumerateChildrenUsingBlock:(void (^)(CMarkNode *child, BOOL *stop))block;
- (NSArray<CMarkNode*>*)children;

@end
#endif /* CMarkNode_h */

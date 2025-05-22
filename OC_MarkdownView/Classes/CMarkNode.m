//
//  CMarkNode.m
//  testSSE
//
//  Created by ximmy on 2025/3/5.
//

#import <Foundation/Foundation.h>
#import "CMarkNode.h"

// 基本类型
NodeType const NodeTypeDocument = @"document";
NodeType const NodeTypeBlockquote = @"block_quote";
NodeType const NodeTypeList = @"list";
NodeType const NodeTypeItem = @"item";
NodeType const NodeTypeCodeBlock = @"code_block";
NodeType const NodeTypeHtmlBlock = @"html_block";
NodeType const NodeTypeCustomBlock = @"custom_block";
NodeType const NodeTypeParagraph = @"paragraph";
NodeType const NodeTypeHeading = @"heading";
NodeType const NodeTypeThematicBreak = @"thematic_break";
NodeType const NodeTypeText = @"text";
NodeType const NodeTypeSoftBreak = @"softbreak";
NodeType const NodeTypeLineBreak = @"linebreak";
NodeType const NodeTypeCode = @"code";
NodeType const NodeTypeHtml = @"html_inline";
NodeType const NodeTypeCustomInline = @"custom_inline";
NodeType const NodeTypeEmphasis = @"emph";
NodeType const NodeTypeStrong = @"strong";
NodeType const NodeTypeLink = @"link";
NodeType const NodeTypeImage = @"image";
NodeType const NodeTypeInlineAttributes = @"attribute";
NodeType const NodeTypeNone = @"NONE";
NodeType const NodeTypeUnknown = @"<unknown>";

// 扩展类型
NodeType const NodeTypeStrikethrough = @"strikethrough";
NodeType const NodeTypeTable = @"table";
NodeType const NodeTypeTableHead = @"table_header";
NodeType const NodeTypeTableRow = @"table_row";
NodeType const NodeTypeTableCell = @"table_cell";
NodeType const NodeTypeTaskListItem = @"tasklist";

@interface  CMarkNode()
@property (nonatomic, assign) CMarkNode *parentNode;
@property (nonatomic, strong) NSMutableArray<CMarkNode *> *children;
@end
@implementation CMarkNode

- (instancetype)initWithMarkdownString:(NSString *)markdown {
    self = [super init];
    if (self) {
        cmark_gfm_core_extensions_ensure_registered();
        cmark_parser *parser = cmark_parser_new(CMARK_OPT_DEFAULT);
        cmark_syntax_extension *tableExtension = cmark_find_syntax_extension("table");
        cmark_syntax_extension *taskListExtension = cmark_find_syntax_extension("tasklist");
        cmark_syntax_extension *autolinkExtension = cmark_find_syntax_extension("autolink");
        cmark_syntax_extension *strikeThroughExtension = cmark_find_syntax_extension("strikethrough");
        cmark_parser_attach_syntax_extension(parser, tableExtension);
        cmark_parser_attach_syntax_extension(parser, taskListExtension);
        cmark_parser_attach_syntax_extension(parser, autolinkExtension);
        cmark_parser_attach_syntax_extension(parser, strikeThroughExtension);
        
        NSData *data = [markdown dataUsingEncoding:NSUTF8StringEncoding];
        cmark_parser_feed(parser, data.bytes, data.length);
        cmark_node *document = cmark_parser_finish(parser);
        cmark_parser_free(parser);
        
        _node = document;
        [self convertToCMarkNodeTree:document parentNode:self];
    }
    return self;
}

- (void)convertToCMarkNodeTree:(cmark_node *)cmarkNode parentNode:(CMarkNode *)parentNode {
    cmark_node *child = cmark_node_first_child(cmarkNode);
    while (child != NULL) {
        CMarkNode *childNode = [[CMarkNode alloc] initWithNode:child parentNode:parentNode];
        childNode.parentNode = parentNode;
        [parentNode addChildNode:childNode];
        [self convertToCMarkNodeTree:child parentNode:childNode];
        child = cmark_node_next(child);
    }
}

- (void)addChildNode:(CMarkNode *)childNode {
    if (!_children) {
        _children = [NSMutableArray array];
    }
    [_children addObject:childNode];
}

+ (instancetype)nodeWithMarkdownString:(NSString *)markdown {
    return [[self alloc] initWithMarkdownString:markdown];
}

- (CMarkNode *)childAtIndex:(NSUInteger)index {
    return self.children[index];
}

- (NSUInteger)childCount {
    return [self.children count];
}

- (CMarkNode *)next {
    cmark_node *nextNode = cmark_node_next(self.node);
    if (nextNode) {
        for (CMarkNode *child in [self.parentNode children]) {
            if (child.node == nextNode) {
                return child;
            }
        }
    }
    return nil;
}

- (CMarkNode *)previous {
    cmark_node *nextNode = cmark_node_previous(self.node);
    if (nextNode) {
        for (CMarkNode *child in [self.parentNode children]) {
            if (child.node == nextNode) {
                return child;
            }
        }
    }
    return nil;
}

- (NSInteger)headingLevel
{
    return cmark_node_get_heading_level(self.node);
}

- (BOOL)isTightList
{
    return cmark_node_get_list_tight(self.node);
}

- (BOOL)isTaskListItemChecked
{
    return cmark_gfm_extensions_get_tasklist_item_checked(self.node);
}

- (cmark_list_type)listType
{
    return cmark_node_get_list_type(self.node)
;
}
- (NSString *)text {
    const char* literal = cmark_node_get_literal(self.node);
    if (literal != nil) {
        return [NSString stringWithUTF8String:literal];
    }
    return @"NULL";
}


- (void)enumerateChildrenUsingBlock:(void (^)(CMarkNode *child, BOOL *stop))block {

}

- (NSString*)nodeURL
{
    // 获取节点的URL
    const char* urlChar = cmark_node_get_url(self.node);
    if (urlChar != NULL)
    {
        NSString* url = [NSString stringWithUTF8String: urlChar];
        return url;
    }

    return @"";
}

- (NSString *) nodeTypeName
{
    NSString* type = [NSString stringWithUTF8String: cmark_node_get_type_string(self.node)];
    return type;
}



// 私有初始化方法，用于子节点
- (instancetype)initWithNode:(cmark_node *)node parentNode:(CMarkNode *)parentNode {
    self = [super init];
    if (self) {
        _node = node;
        // 如果需要，可以在这里处理 parentNode
    }
    return self;
}

- (void)printAST {
    [self printASTNode:self depth:0];
}

// Recursive method to print AST structure
- (void)printASTNode:(CMarkNode *)node depth:(int)depth {
    // Indentation to represent hierarchy
    for (int i = 0; i < depth; i++) printf("  ");

    // Get node type name
    NSString *typeName = [node nodeTypeName];
    printf("[%s]", [typeName UTF8String]);

    // Print additional information for specific node types
    if ([typeName isEqualToString:@"heading"]) {
        printf(" (level=%d)", cmark_node_get_heading_level(node.node));
    } else if ([typeName isEqualToString:@"list"]) {
        const char *listType = cmark_node_get_list_type(node.node) == CMARK_BULLET_LIST ? "bullet" : "ordered";
        printf(" (type=%s)", listType);
    }

    // Print literal content if available
    NSString *literal = [node text];
    if (literal != nil) {
        printf(" -> \"%s\"", [literal UTF8String]);
    }

    printf("\n");

    // Recursively traverse child nodes
    for (CMarkNode *child in node.children) {
        [self printASTNode:child depth:depth + 1];
    }
}

- (NSString*)debugDescription
{
    return [self nodeTypeName];
}

- (BOOL)isTableCellInHeader
{
    CMarkNode* parent = self.parentNode;
    if ([[parent nodeTypeName] isEqualToString:NodeTypeTableHead])
    {
        return YES;
    }
    return NO;
}

- (NSArray<CMarkNode*>*)children
{
    return _children;
}

- (void)dealloc {
    // cmark 节点由解析器管理，不需要手动释放
}

@end

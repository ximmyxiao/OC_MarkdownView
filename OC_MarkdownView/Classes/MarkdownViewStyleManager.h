
//
//  MarkdownViewStyleManager.h
//  OC_MarkdownView_Example
//
//  Created by 肖潇 on 2025/6/17.
//  Copyright © 2025 ximmyxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief A singleton manager that handles styling properties for Markdown view rendering.
 *
 * This class manages various style properties such as font sizes, spacing, colors, and visual elements
 * that control the appearance of rendered Markdown content.
 */
@interface MarkdownViewStyleManager : NSObject

/**
 * @brief Returns the shared instance of the style manager.
 *
 * @return The singleton instance of MarkdownViewStyleManager.
 */
+ (instancetype)sharedInstance;

/**
 * @brief The main text font size used for regular Markdown content. if  other fonts are not specified, most of them will reference this font size.
 */
@property(nonatomic,assign) CGFloat mainFontSize;

/**
 * @brief The text color used for the main text.
 */
@property(nonatomic,strong) UIColor* mainTextColor;

/**
 * @brief The font size used within code blocks.
 */
@property(nonatomic,assign) CGFloat codeBlockFontSize;

/**
 * @brief Line spacing value used within code blocks.
 */
@property(nonatomic,assign) CGFloat codeBlockLineSpacing;

/**
 * @brief Edge insets for the code block scroll view.
 */
@property(nonatomic,assign) UIEdgeInsets codeblockScrollEdgeInsets;

/**
 * @brief Corner radius of the code block scroll background.
 */
@property(nonatomic,assign) CGFloat codeBlockScrollBgCornerRadius;

/**
 * @brief Background color of the code block scroll view.
 */
@property(nonatomic,strong) UIColor* codeBlockScrollBgColor;

/**
 * @brief Scale factor for line spacing in inline text.
 */
@property(nonatomic,assign) CGFloat inlineTextLineSpacingScale;

/**
 * @brief Scale factor for line spacing in level 1 headings.
 */
@property(nonatomic,assign) CGFloat inlineTextLineSpacingScaleInHeadingLevel1;

/**
 * @brief Scale factor for line spacing in level 2 headings.
 */
@property(nonatomic,assign) CGFloat inlineTextLineSpacingScaleInHeadingLevel2;

/**
 * @brief Text color for inline code segments.
 */
@property(nonatomic,strong) UIColor* inlineTextCodeTextColor;

/**
 * @brief Background color for inline code segments.
 */
@property(nonatomic,strong) UIColor* inlineTextCodeTextBackgroundColor;

/**
 * @brief Font size for inline code segments.
 */
@property(nonatomic,assign) CGFloat inlineTextCodeFontSize;

/**
 * @brief Text color for headings.
 */
@property(nonatomic,strong) UIColor* inlineTextHeadingTextColor;

/**
 * @brief Font size for level 1 headings.
 */
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel1;

/**
 * @brief Font size for level 2 headings.
 */
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel2;

/**
 * @brief Font size for level 3 headings.
 */
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel3;

/**
 * @brief Font size for level 4 headings.
 */
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel4;

/**
 * @brief Font size for level 5 headings.
 */
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel5;

/**
 * @brief Font size for level 6 headings.
 */
@property(nonatomic,assign) CGFloat inlineTextFontSizeOfHeadingLevel6;

/**
 * @brief Vertical spacing between list items.
 */
@property(nonatomic,assign) CGFloat listSpacingBetweenItems;

/**
 * @brief Width of the image marker in lists.
 */
@property(nonatomic,assign) CGFloat listImageMarkerWidth;

/**
 * @brief Image used as a marker for bulleted lists.
 */
@property(nonatomic,strong) UIImage* bulletedListImageMarker;

/**
 * @brief Image used as a marker for uncompleted task list items.
 */
@property(nonatomic,strong) UIImage* taskListImageMarker;

/**
 * @brief Image used as a marker for completed task list items.
 */
@property(nonatomic,strong) UIImage* taskListImageMarkerForCompleted;

/**
 * @brief Horizontal spacing between list marker image and text content.
 */
@property(nonatomic,assign) CGFloat spacingBetweenListImageMarkerAndText;

/**
 * @brief Corner radius for quote markers.
 */
@property(nonatomic,assign) CGFloat quoteMarkerCornerRadius;

/**
 * @brief Width of quote markers.
 */
@property(nonatomic,assign) CGFloat quoteMarkerWidth;

/**
 * @brief Spacing around quote markers.
 */
@property(nonatomic,assign) CGFloat quoteMarkerSpacing;

/**
 * @brief Border width for table elements.
 */
@property(nonatomic,assign) CGFloat tableBorderWidth;

/**
 * @brief Corner radius for table elements.
 */
@property(nonatomic,assign) CGFloat tableCornerRadius;

/**
 * @brief Border color for table elements.
 */
@property(nonatomic,strong) UIColor* tableBorderColor;

/**
 * @brief Edge insets for content within table columns.
 */
@property(nonatomic,assign) UIEdgeInsets tableColumnContentEdgeInsets;

@end

NS_ASSUME_NONNULL_END


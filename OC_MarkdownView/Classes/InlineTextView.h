//
//  InlineTextView.h
//  testSSE
//
//  Created by ximmy on 2025/4/25.
//

#import <UIKit/UIKit.h>
#import "CMarkNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface InlineTextView : UIView
@property (nonatomic, strong) NSAttributedString* attributedText;
- (void)buildFromBlockNode:(CMarkNode*)node;
- (void)buildFromBlockNode:(CMarkNode*)blockNode withAttributes:(NSDictionary*)predefinedAttributes;
- (UIFont*)firstLineFont;
- (void)setNumberOflines:(NSInteger)numberOflines;

@end

NS_ASSUME_NONNULL_END

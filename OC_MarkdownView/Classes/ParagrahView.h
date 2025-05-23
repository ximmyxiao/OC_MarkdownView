//
//  ParagrahView.h
//  testSSE
//
//  Created by ximmy on 2025/3/5.
//

#import <UIKit/UIKit.h>
#import "CMarkNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParagrahView : UIView
@property (nonatomic, strong) CMarkNode* node;
@property (nonatomic, strong) NSDictionary* defaultAttributes;
@end

NS_ASSUME_NONNULL_END

//
//  CodeBlockView.h
//  testSSE
//
//  Created by ximmy on 2025/4/14.
//

#import <UIKit/UIKit.h>
#import "CMarkNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface CodeBlockView : UIView
@property(nonatomic,strong) CMarkNode* node;

@end

NS_ASSUME_NONNULL_END

//
//  NodeToViewManager.h
//  testSSE
//
//  Created by ximmy on 2025/4/15.
//

#import <Foundation/Foundation.h>
#import "CMarkNode.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeToViewManager : NSObject
+ (instancetype)sharedInstance;
- (UIView*)viewForNode:(CMarkNode*)node;
- (UIView*)viewForNode:(CMarkNode*)node withDefaultAttributes:(NSDictionary* _Nullable)attributes;
+ (CGFloat)firstTextLineBaseOfView:(UIView*)containerView;
@end

NS_ASSUME_NONNULL_END

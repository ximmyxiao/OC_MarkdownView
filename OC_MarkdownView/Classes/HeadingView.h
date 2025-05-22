//
//  HeadingView.h
//  testSSE
//
//  Created by ximmy on 2025/4/14.
//

#import <UIKit/UIKit.h>
#import "CMarkNode.h"
NS_ASSUME_NONNULL_BEGIN

@interface HeadingView : UIView
@property(nonatomic,strong) CMarkNode* node;
@property(nonatomic,assign) CGFloat firstLineCenter;
@end

NS_ASSUME_NONNULL_END

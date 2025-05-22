//
//  TableColumnView.h
//  testSSE
//
//  Created by ximmy on 2025/4/22.
//

#import <UIKit/UIKit.h>
#import "CMarkNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableColumnView : UIView
@property(nonatomic,strong) NSArray<CMarkNode*>* nodes;
@end

NS_ASSUME_NONNULL_END

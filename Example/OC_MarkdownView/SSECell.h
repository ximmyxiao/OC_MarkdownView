//
//  SSECell.h
//  testSSE
//
//  Created by ximmy on 2025/2/26.
//

#import <UIKit/UIKit.h>
#import "SSEContentViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SSECell : UITableViewCell
@property (nonatomic, strong) SSEContentViewModel* viewModel;
@end

NS_ASSUME_NONNULL_END

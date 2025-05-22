//
//  InlineTextStyleManager.h
//  testSSE
//
//  Created by ximmy on 2025/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InlineTextStyleManager : NSObject
@property(nonatomic,strong) NSDictionary* defaultAttributes;
- (instancetype)initWithHeadingLevel:(NSInteger)level;
- (instancetype)initWithTableHeaderRow;
- (NSDictionary*)textAttributes;
- (NSDictionary*)codeAttributes;
- (NSDictionary*)linkAttributes;
- (NSDictionary*)strikethoughtAttributes;

@end

NS_ASSUME_NONNULL_END

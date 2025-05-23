//
//  UIImage+Ex.h
//  QQTicket
//
//  Created by bright on 12-2-16.
//  Copyright (c) 2012年 gmail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Ex)

//创建一个纯色可伸缩图像
+ (UIImage*)imageWithColor:(UIColor*)color;
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
+ (UIImage*)imageWithColor:(UIColor*)color cornorRadius:(CGFloat)cornorRadius;
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size cornorRadius:(CGFloat)cornorRadius;

//创建一个以中间点伸缩的图像
+ (UIImage*)strechableImageWithName:(NSString*)name;

//改变透明度
- (UIImage*)imageByAlpha:(CGFloat)alpha;

//剪切图像
- (UIImage*)imageInRect:(CGRect)rect;

//只获取Aplha通道头像
- (UIImage*)imageOfAlphaChannel;

//图像变暗、变亮
- (UIImage*)imageDarkenWithAlpha:(CGFloat)alpha;
- (UIImage*)imageLightWithAlpha:(CGFloat)alpha;

//圆形图像
- (UIImage*)circleImage;

//圆角
- (UIImage*)imageWithCornorRadius:(CGFloat)cornorRadius;

//擦除图像部分内容
- (UIImage*)imageEraseContentInRect:(CGRect)rect;

//两幅图像合并
- (UIImage*)imageMergedWithImage:(UIImage*)image;

//图像缩放
- (UIImage*)imageWithZoomScale:(CGFloat)zoomScale;

//图像拉伸
- (UIImage*)imageScaledToSize:(CGSize)size;

//图像黑白化
- (UIImage*)soloColorImage;

@end

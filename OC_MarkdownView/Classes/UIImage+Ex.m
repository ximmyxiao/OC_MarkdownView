//
//  UIImage+Ex.m
//  QQTicket
//
//  Created by 启亮 谌 on 12-2-16.
//  Copyright (c) 2012年 gmail. All rights reserved.
//

#import "UIImage+Ex.h"

@implementation UIImage(Ex)

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)imageWithColor:(UIColor*)color cornorRadius:(CGFloat)cornorRadius{
    CGSize size = CGSizeMake(cornorRadius*2+2, cornorRadius*2+2);
    return [self imageWithColor:color size:size cornorRadius:cornorRadius];
}

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size cornorRadius:(CGFloat)cornorRadius{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [color setFill];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornorRadius];
    [bezierPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2];
}

+ (UIImage*)imageWithColor:(UIColor*)color{
    return [[self imageWithColor:color size:CGSizeMake(1, 1)] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
}

+ (UIImage*)strechableImageWithName:(NSString*)name{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:(int)(image.size.width/2) topCapHeight:(int)(image.size.height/2)];
}


- (UIImage*)imageByAlpha:(CGFloat)alpha{
    CGFloat scale = self.scale;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [self drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
    UIImage *image = [UIGraphicsGetImageFromCurrentImageContext() stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageInRect:(CGRect)rect
{
	
	CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(self.scale*rect.origin.x, self.scale*rect.origin.y, self.scale*rect.size.width, self.scale*rect.size.height));
	UIImage* subImage = [UIImage imageWithCGImage: imageRef scale:self.scale orientation:self.imageOrientation];
	CGImageRelease(imageRef);
	
	return subImage;
	
}

- (UIImage*)imageOfAlphaChannel{
    CGImageRef sourceImage = self.CGImage;
    CGFloat imageWidth = CGImageGetWidth(sourceImage);
    CGFloat imageHeight = CGImageGetHeight(sourceImage);
    CGContextRef context = CGBitmapContextCreateWithData(NULL, imageWidth, imageHeight, 8, imageWidth, NULL, kCGBitmapAlphaInfoMask&kCGImageAlphaOnly, NULL, NULL);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), sourceImage);
    CGImageRef outCGImage = CGBitmapContextCreateImage(context);
    UIImage *outImage = [UIImage imageWithCGImage:outCGImage scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(outCGImage);
    CGContextRelease(context);
    return outImage;
}

- (UIImage*)imageDarkenWithAlpha:(CGFloat)alpha{
    CGFloat scale = self.scale;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [self drawAtPoint:CGPointZero];
    [[UIColor blackColor] set];
    [[self imageOfAlphaChannel] drawAtPoint:CGPointZero blendMode:kCGBlendModeDarken alpha:alpha];
    UIImage *image = [UIGraphicsGetImageFromCurrentImageContext() stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)imageLightWithAlpha:(CGFloat)alpha{
    CGFloat scale = self.scale;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [self drawAtPoint:CGPointZero];
    [[UIColor whiteColor] set];
    [[self imageOfAlphaChannel] drawAtPoint:CGPointZero blendMode:kCGBlendModeLighten alpha:alpha];
    UIImage *image = [UIGraphicsGetImageFromCurrentImageContext() stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)circleImage{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)] addClip];
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)imageWithCornorRadius:(CGFloat)cornorRadius{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.size.width, self.size.height) cornerRadius:cornorRadius] addClip];
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)imageMergedWithImage:(UIImage*)mergeImage{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawAtPoint:CGPointZero];
    [mergeImage drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)imageEraseContentInRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawAtPoint:CGPointZero];
    [[UIColor blackColor] set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeClear);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)imageWithZoomScale:(CGFloat)zoomScale{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width*zoomScale, self.size.height*zoomScale), NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, self.size.width*zoomScale, self.size.height*zoomScale)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)imageScaledToSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, YES, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}


- (UIImage*)soloColorImage
{

    typedef enum {
        ALPHA = 0,
        BLUE = 1,
        GREEN = 2,
        RED = 3
    } PIXELS;
    
    CGSize size = [self size];
    int width = size.width;
    int height = size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

@end

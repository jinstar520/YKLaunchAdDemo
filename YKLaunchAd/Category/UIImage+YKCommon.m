//
//  UIImage+YKCommon.m
//  YKLaunchAd
//
//  Created by jinstar520 on 2017/4/2.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import "UIImage+YKCommon.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (YKCommon)

static NSTimeInterval _yy_CGImageSourceGetGIFFrameDelayAtIndex(CGImageSourceRef source, size_t index) {
    NSTimeInterval delay = 0;
    CFDictionaryRef dic = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    if (dic) {
        CFDictionaryRef dicGIF = CFDictionaryGetValue(dic, kCGImagePropertyGIFDictionary);
        if (dicGIF) {
            NSNumber *num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFUnclampedDelayTime);
            if (num.doubleValue <= __FLT_EPSILON__) {
                num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFDelayTime);
            }
            delay = num.doubleValue;
        }
        CFRelease(dic);
    }
    
    if (delay < 0.02) delay = 0.1;
    return delay;
}

+ (UIImage *)yk_imageWithSmallGIFData:(NSData *)data {
    return [UIImage yk_imageWithSmallGIFData:data scale:1.0];
}

+ (UIImage *)yk_imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)(data), NULL);
    if (!source) return nil;
    
    size_t count = CGImageSourceGetCount(source);
    if (count <= 1) {
        CFRelease(source);
        return [self.class imageWithData:data scale:1];
    }
    
    NSUInteger frames[count];
    double oneFrameTime = 1 / 50.0; // 50 fps
    NSTimeInterval totalTime = 0;
    NSUInteger totalFrame = 0;
    NSUInteger gcdFrame = 0;
    for (size_t i = 0; i < count; i++) {
        NSTimeInterval delay = _yy_CGImageSourceGetGIFFrameDelayAtIndex(source, i);
        totalTime += delay;
        NSInteger frame = lrint(delay / oneFrameTime);
        if (frame < 1) frame = 1;
        frames[i] = frame;
        totalFrame += frames[i];
        if (i == 0) gcdFrame = frames[i];
        else {
            NSUInteger frame = frames[i], tmp;
            if (frame < gcdFrame) {
                tmp = frame; frame = gcdFrame; gcdFrame = tmp;
            }
            while (true) {
                tmp = frame % gcdFrame;
                if (tmp == 0) break;
                frame = gcdFrame;
                gcdFrame = tmp;
            }
        }
    }
    NSMutableArray *array = [NSMutableArray new];
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!imageRef) {
            CFRelease(source);
            return nil;
        }
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        if (width == 0 || height == 0) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, bitmapInfo);
        CGColorSpaceRelease(space);
        if (!context) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef decoded = CGBitmapContextCreateImage(context);
        CFRelease(context);
        if (!decoded) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        UIImage *image = [UIImage imageWithCGImage:decoded scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        CGImageRelease(decoded);
        if (!image) {
            CFRelease(source);
            return nil;
        }
        for (size_t j = 0, max = frames[i] / gcdFrame; j < max; j++) {
            [array addObject:image];
        }
    }
    CFRelease(source);
    UIImage *image = [self.class animatedImageWithImages:array duration:totalTime];
    return image;
}

+ (float)yk_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    
    return frameDuration;
}

+ (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor rect:(CGRect)rect {
    return [UIImage imageWithBackgroundColor:backgroundColor rect:rect radius:0];
}

+ (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor rect:(CGRect)rect radius:(CGFloat)radius {
    return [UIImage imageWithBackgroundColor:backgroundColor size:CGSizeMake(1, 1) rect:rect borderWidth:0 boderColor:[UIColor clearColor] radius:radius];
}

+ (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor rect:(CGRect)rect borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)boderColor {
    return [UIImage imageWithBackgroundColor:backgroundColor size:CGSizeMake(1, 1) rect:rect borderWidth:borderWidth boderColor:boderColor radius:0];
}

+ (UIImage *)imageWithRect:(CGRect)rect borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)boderColor {
    return [UIImage imageWithRect:rect borderWidth:borderWidth boderColor:boderColor radius:0];
}

+ (UIImage *)imageWithRect:(CGRect)rect borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)boderColor radius:(CGFloat)radius {
    return [UIImage imageWithBackgroundColor:[UIColor clearColor] size:CGSizeMake(1, 1) rect:rect borderWidth:borderWidth boderColor:boderColor radius:radius];
}

+ (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor rect:(CGRect)rect borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)boderColor radius:(CGFloat)radius {
    return [UIImage imageWithBackgroundColor:backgroundColor size:CGSizeMake(1, 1) rect:rect borderWidth:borderWidth boderColor:boderColor radius:radius];
}

+ (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor size:(CGSize)size rect:(CGRect)rect borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)boderColor radius:(CGFloat)radius {
    if (!backgroundColor || size.width <= 0 || size.height <= 0) return nil;
    
    UIGraphicsBeginImageContext(rect.size);   //开始画线
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    // Draw background
    CGContextMoveToPoint(context, borderWidth, rect.size.height/2);
    CGContextAddArcToPoint(context, borderWidth, borderWidth, radius + borderWidth, borderWidth, radius);
    CGContextAddLineToPoint(context, rect.size.width - radius - borderWidth, borderWidth);
    CGContextAddArcToPoint(context, rect.size.width - borderWidth, borderWidth, rect.size.width - borderWidth, rect.size.height / 2, radius);
    CGContextAddArcToPoint(context, rect.size.width - borderWidth, rect.size.height - borderWidth, rect.size.width - radius - borderWidth, rect.size.height - borderWidth, radius);
    CGContextAddLineToPoint(context, radius + borderWidth, rect.size.height - borderWidth);
    CGContextAddArcToPoint(context, borderWidth, rect.size.height - borderWidth, borderWidth, rect.size.height/2, radius);
    CGContextFillPath(context);
    
    // Draw border
    if (borderWidth > 0) {
        CGContextSetLineWidth(context, borderWidth);
        if (boderColor) {
            CGContextSetStrokeColorWithColor(context, boderColor.CGColor);
        }
        
        CGContextMoveToPoint(context, borderWidth, rect.size.height/2);
        CGContextAddArcToPoint(context, borderWidth, borderWidth, radius + borderWidth, borderWidth, radius);
        CGContextAddLineToPoint(context, rect.size.width - radius - borderWidth, borderWidth);
        CGContextAddArcToPoint(context, rect.size.width - borderWidth, borderWidth, rect.size.width - borderWidth, rect.size.height / 2, radius);
        CGContextAddArcToPoint(context, rect.size.width - borderWidth, rect.size.height - borderWidth, rect.size.width - radius - borderWidth, rect.size.height - borderWidth, radius);
        CGContextAddLineToPoint(context, radius + borderWidth, rect.size.height - borderWidth);
        CGContextAddArcToPoint(context, borderWidth, rect.size.height - borderWidth, borderWidth, rect.size.height/2, radius);
        CGContextAddLineToPoint(context, borderWidth, rect.size.height/2);
        CGContextStrokePath(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//获取绘图
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

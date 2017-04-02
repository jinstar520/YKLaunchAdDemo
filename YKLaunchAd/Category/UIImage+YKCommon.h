//
//  UIImage+YKCommon.h
//  YKLaunchAd
//
//  Created by jinstar520 on 2017/4/2.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YKCommon)

+ (UIImage *)yk_imageWithSmallGIFData:(NSData *)data;
+ (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor rect:(CGRect)rect;
+ (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor rect:(CGRect)rect radius:(CGFloat)radius;
+ (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor rect:(CGRect)rect borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)boderColor;
+ (UIImage *)imageWithRect:(CGRect)rect borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)boderColor;
+ (UIImage *)imageWithRect:(CGRect)rect borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)boderColor radius:(CGFloat)radius;
+ (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor rect:(CGRect)rect borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)boderColor radius:(CGFloat)radius;
+ (UIImage *)imageWithBackgroundColor:(UIColor *)backgroundColor size:(CGSize)size rect:(CGRect)rect borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)boderColor radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END

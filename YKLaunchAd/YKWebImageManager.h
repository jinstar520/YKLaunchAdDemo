//
//  YKWebImageManager.h
//  YKLaunchAd
//
//  Created by jinstar520 on 2017/4/1.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, YKWebImageOptions) {
    /**
     *  使用缓存加载;没缓存先下载再缓存
     */
    YKWebImageUseNSURLCache = 1 << 0,
    
    /**
     *  只加载,不缓存
     */
    YKWebImageOnlyLoad = 1 << 1,
    
    /**
     *  先读缓存,再加载刷新图片和缓存
     */
    YKWebImageRefreshImageCache = 1 << 2
    
};

typedef void(^YKWebImageCompletionBlock)(UIImage *image, NSURL *url);

@interface YKWebImageManager : NSObject

+ (void)yk_requestImageWithURL:(NSURL *)url options:(YKWebImageOptions)options completion:(YKWebImageCompletionBlock)completion;

@end







//
//  UIImageView+YKWebCache.h
//  YKLaunchAd
//
//  Created by jinstar520 on 2017/4/2.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKWebImageManager.h"

@interface UIImageView (YKWebCache)

- (void)yk_setImageWithURL:(NSURL *)url;

- (void)yk_setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder;

- (void)yk_setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder completion:(YKWebImageCompletionBlock)completion;

/**
 *  异步加载网络图片/带本地缓存
 *
 *  @param url            图片url
 *  @param placeholder    默认图片
 *  @param options        缓存机制
 *  @param completion     加载完成回调
 */
- (void)yk_setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder options:(YKWebImageOptions)options completion:(YKWebImageCompletionBlock)completion;

@end

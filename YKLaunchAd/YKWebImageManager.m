//
//  YKWebImageManager.m
//  YKLaunchAd
//
//  Created by jinstar520 on 2017/4/1.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import "YKWebImageManager.h"
#import "YKImageCache.h"
#import "UIImage+YKCommon.h"

@implementation YKWebImageManager

+ (void)yk_requestImageWithURL:(NSURL *)url options:(YKWebImageOptions)options completion:(YKWebImageCompletionBlock)completion {
    if (!options) options = YKWebImageUseNSURLCache;
    if (options & YKWebImageOnlyLoad) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [self yk_requestImageWithURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(image, url);
                }
            });
        });
        
        return;
    } else {
        UIImage *image = [YKImageCache yk_fetchCacheImageWithURL:url];
        if (image && completion) {
            completion(image, url);
            
            if(options & YKWebImageUseNSURLCache) return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [self yk_requestImageAndCacheWithURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(image, url);
                }
            });
        });
    }
}

+ (UIImage *)yk_requestImageWithURL:(NSURL *)url {
    if (url == nil) return nil;
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage yk_imageWithSmallGIFData:data];
}

+ (UIImage *)yk_requestImageAndCacheWithURL:(NSURL *)url {
    if ( url == nil) return nil;
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    [YKImageCache yk_cacheImageData:data imageURL:url];
    
    return [UIImage yk_imageWithSmallGIFData:data];
}

@end






















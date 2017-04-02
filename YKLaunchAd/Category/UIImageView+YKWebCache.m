//
//  UIImageView+YKWebCache.m
//  YKLaunchAd
//
//  Created by jinstar520 on 2017/4/2.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import "UIImageView+YKWebCache.h"

@implementation UIImageView (YKWebCache)

- (void)yk_setImageWithURL:(NSURL *)url {
    [self yk_setImageWithURL:url placeholder:nil];
}

- (void)yk_setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder {
    [self yk_setImageWithURL:url placeholder:placeholder completion:nil];
}

- (void)yk_setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder completion:(YKWebImageCompletionBlock)completion {
    [self yk_setImageWithURL:url placeholder:placeholder options:YKWebImageUseNSURLCache completion:completion];
}

- (void)yk_setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder options:(YKWebImageOptions)options completion:(YKWebImageCompletionBlock)completion {
    if (placeholder) self.image = placeholder;
    
    if (url) {
        [YKWebImageManager yk_requestImageWithURL:url options:options completion:^(UIImage *image, NSURL *url) {
            if (!self) return;
            
            self.image = image;
            if (image && completion) {
                completion(image, url);
            }
        }];
    }
}

@end

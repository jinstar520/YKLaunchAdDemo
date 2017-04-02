//
//  YKImageCache.h
//  YKLaunchAd
//
//  Created by jinstar520 on 2017/4/2.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKImageCache : NSObject

+ (UIImage *)yk_fetchCacheImageWithURL:(NSURL *)url;

+ (void)yk_cacheImageData:(NSData *)data imageURL:(NSURL *)url;

+ (NSString *)yk_cacheImagePath;

@end

NS_ASSUME_NONNULL_END

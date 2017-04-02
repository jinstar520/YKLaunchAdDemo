//
//  YKImageCache.m
//  YKLaunchAd
//
//  Created by jinstar520 on 2017/4/2.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import "YKImageCache.h"
#import "UIImage+YKCommon.h"
#import "NSString+YKCommon.h"

@implementation YKImageCache

+ (UIImage *)yk_fetchCacheImageWithURL:(NSURL *)url {
    if (url == nil) return nil;
    
    NSString *directoryPath = [self yk_cacheImagePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@",directoryPath,[url.absoluteString yk_md5Str]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [UIImage yk_imageWithSmallGIFData:data];
}

+ (void)yk_cacheImageData:(NSData *)data imageURL:(NSURL *)url {
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self yk_cacheImagePath],[url.absoluteString yk_md5Str]];
    if (data) {
        BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        
        if (!isOk) NSLog(@"cache file error for URL: %@", url);
    }
}

+ (NSString *)yk_cacheImagePath {
    NSString *path =[NSHomeDirectory() stringByAppendingPathComponent:@"Library/YKLaunchAdCache"];
    [self yk_checkDirectory:path];
    
    return path;
}

+ (void)yk_checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [self yk_createDirectoryAtPath:path];
    } else {
        if (!isDirectory) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self yk_createDirectoryAtPath:path];
        }
    }
}

+ (void)yk_createDirectoryAtPath:(NSString *)path {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:@{NSFileCreationDate : [NSDate date]}
                                                    error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    } else {
        NSLog(@"YKLaunchAdCachePath:%@",path);
        [self yk_addDoNotBackupAttribute:path];
    }
}

+ (void)yk_addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }
}

@end

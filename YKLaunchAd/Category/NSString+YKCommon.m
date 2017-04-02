//
//  NSString+YKCommon.m
//  YKLaunchAd
//
//  Created by jinstar520 on 2017/4/1.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import "NSString+YKCommon.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (YKCommon)

- (NSString *)yk_md5Str {    
    const char *value = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), result);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",result[count]];
    }
    
    return outputString;
}

- (BOOL)checkUrlError {
    if (self==nil || self.length==0 || ![self hasPrefix:@"http"]) {
        NSLog(@"图片URL地址为nil,或者有误!");
        return YES;
    }
    
    return  NO;
}

@end

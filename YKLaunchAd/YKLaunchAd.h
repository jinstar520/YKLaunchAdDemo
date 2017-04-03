//
//  YKLaunchAd.h
//  YKLaunchAd
//
//  Created by 聂金星 on 2017/4/1.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+YKWebCache.h"

@class YKLaunchAd;

@protocol YKLaunchAdDelegate <NSObject>

@required

/**
 加载广告数据，在此方法内从服务器获取广告数据，并对“countdown”属性重新赋值

 @param launchAd self
 */
- (void)yk_willLoadAd:(YKLaunchAd *)launchAd;

/**
 倒计时结束回调
 */
- (void)yk_willAdCountdownEnding:(YKLaunchAd *)launchAd;

@optional

/**
 下载广告图完成后调用，在这里做修改adImage、countdown、adFrame、skipType等
 
 @param launchAd self
 */
- (void)yk_requestAdImageFinished:(YKLaunchAd *)launchAd;

/**
 点击广告回调
 */
- (void)yk_didAdClicked:(YKLaunchAd *)launchAd;

/**
 自定义倒计时结束后跳转动画

 @param animations block
 */
- (void)yk_customAdEndingAnimations:(void(^)())animations;

@end

typedef NS_ENUM(NSInteger, YKSkipType) {
    YKSkipTypeNone          = 1,        //无
    YKSkipTypeTimer         = 2,        //倒计时
    YKSkipTypeText          = 3,        //跳过
    YKSkipTypeTimerAndText  = 4,        //倒计时+跳过
};

@interface YKLaunchAd : UIViewController

@property (nonatomic, weak) id<YKLaunchAdDelegate> delegate;

@property (nonatomic, strong) UIButton *skipButton;

/**
 广告显示的大小，默认是[UIScreen mainScreen].bounds
 */
@property (nonatomic, assign) CGRect adFrame;

/**
 倒计时，默认3秒
 */
@property (nonatomic, assign) NSInteger countdown;



/**
 adClickCountdownEnding默认值为YES。adClickCountdownEnding=YES，当从广告页返回后，无论countdown是否为0，都会调用yk_willAdCountdownEnding；adClickCountdownEnding=no，如果countdown > 0，会继续倒计时，直到countdown==0时，再调用yk_willAdCountdownEnding。
 */
@property (nonatomic, assign) BOOL adClickCountdownEnding;

/**
 launchScreen.storyboard的文件名，默认从Assets中读取启动图。当启动图需要从launchScreen.storyboard读取时进行赋值
 */
@property (nonatomic, copy) NSString *launchScreenName;

/**
 广告图片下载地址
 */
@property (nonatomic, copy, readonly) NSURL *adImageUrl;

/**
 广告图片点击内容地址，需要赋值
 */
@property (nonatomic, copy) NSURL *adlinkUrl;

@property (nonatomic, strong) UIImage *adImage;

/**
 如果广告数据不止adlinkUrl和adImageUrl，用adRawData保存
 */
@property (nonatomic, copy) NSDictionary *adRawData;

/**
 开始倒计时
 */
- (void)start;

/**
 加载广告图，skipType为YKSkipTypeTimerAndText；options为YKWebImageUseNSURLCache

 @param imageUrl 广告图url
 */
- (void)setImageUrl:(NSURL *)imageUrl;

/**
 加载广告图,skipType为YKSkipTypeTimerAndText

 @param imageUrl 广告图url
 @param options 加载图片类型
 */
- (void)setImageUrl:(NSURL *)imageUrl
            options:(YKWebImageOptions)options;

/**
 加载广告图,options为YKWebImageUseNSURLCache

 @param imageUrl 广告图url
 @param skipType 跳过按钮显示类型
 */
- (void)setImageUrl:(NSURL *)imageUrl
           skipType:(YKSkipType)skipType;

/**
 加载广告图

 @param imageUrl 广告图url
 @param skipType 跳过按钮显示类型，默认不显示
 @param options  默认值YKWebImageUseNSURLCache
 */
- (void)setImageUrl:(NSURL *)imageUrl
           skipType:(YKSkipType)skipType
            options:(YKWebImageOptions)options;

@end






































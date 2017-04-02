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
 下载广告图完成后调用，在这里做修改adImage、countdown、adFrame等

 @param launchAd self
 @param adImage 广告图
 @param adUrl 广告图Url
 */
- (void)yk_requestAdImageFinished:(YKLaunchAd *)launchAd adImage:(UIImage *)adImage adUrl:(NSURL *)adUrl;

/**
 倒计时结束回调
 */
- (void)yk_willAdCountdownEnding;

@optional

/**
 点击广告回调
 */
- (void)yk_didAdClicked;

/**
 自定义倒计时结束后跳转动画

 @param animations block
 */
- (void)yk_customAdEndingAnimations:(void(^)())animations;

@end

typedef NS_ENUM(NSInteger, YKSkipType) {
    YKSkipTypeNone       = 1,        //无
    YKSkipTypeTimer      = 2,        //倒计时
    YKSkipTypeText       = 3,        //跳过
    YKSkipTypeTimerText  = 4,        //倒计时+跳过
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
 显示倒计时按钮类型，默认是YKSkipTypeTimerText
 */
@property (nonatomic, assign) YKSkipType skipType;

/**
 adClickCountdownEnding默认值为YES。adClickCountdownEnding=YES，当从广告页返回后，无论countdown是否为0，都会调用yk_willAdCountdownEnding；adClickCountdownEnding=no，如果countdown > 0，会继续倒计时，直到countdown==0时，再调用yk_willAdCountdownEnding。
 */
@property (nonatomic, assign) BOOL adClickCountdownEnding;

/**
 launchScreen.storyboard的文件名，默认从Assets中读取启动图。当启动图需要从launchScreen.storyboard读取时进行赋值
 */
@property (nonatomic, copy) NSString *launchScreenName;

/**
 开始倒计时
 */
- (void)start;

/**
 下载广告图

 @param imageUrl 广告图url
 @param countdown 倒计时长
 @param skipType 显示倒计时按钮类型
 @param options 广告图加载类型
 */
- (void)setImageUrl:(NSString *)imageUrl
          countdown:(NSInteger)countdown
           skipType:(YKSkipType)skipType
            options:(YKWebImageOptions)options;

@end






































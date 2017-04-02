//
//  YKLaunchAd.m
//  YKLaunchAd
//
//  Created by 聂金星 on 2017/4/1.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import "YKLaunchAd.h"
#import "YKImageCache.h"
#import "YKBundleInfoKeys.h"
#import "UIImage+YKCommon.h"
#import "NSString+YKCommon.h"

static NSInteger const YKDefaultWaitingForImageRequestCountdown = 3;
static NSInteger const YKDefaultAdCountdown = 4;

#define YKSkipButtonFrame CGRectMake([UIScreen mainScreen].bounds.size.width-70, 30, 60, 30)

@interface YKLaunchAd ()

@property (nonatomic, strong) UIImageView *launchImageView;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, copy) dispatch_source_t countdownTimer;

@end

@implementation YKLaunchAd {
    BOOL _adCountdownEnd;
    BOOL _adClick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.adClickCountdownEnding = YES;
    self.countdown = YKDefaultWaitingForImageRequestCountdown;
    _skipType = YKSkipTypeNone;
    _adFrame = [UIScreen mainScreen].bounds;
    [self.view addSubview:self.launchImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (_countdownTimer && self.countdown>0 && _adClick) {
        if (self.adClickCountdownEnding) {
            [self adCountdownEnding];
        } else {
            dispatch_resume(_countdownTimer);
        }
    }
    _adClick = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_countdownTimer && self.countdown>0 && _adClick) {
        dispatch_suspend(_countdownTimer);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImageUrl:(NSString *)imageUrl
          countdown:(NSInteger)countdown
           skipType:(YKSkipType)skipType
            options:(YKWebImageOptions)options
{
    if(_adCountdownEnd) return;
    if([imageUrl checkUrlError]) return;
    
    _countdown = countdown;
    _skipType = skipType;
    
    [self.view addSubview:self.adImageView];
    [self.view addSubview:self.skipButton];
    [self adAnimate];
    
    [self.adImageView yk_setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:nil options:options completion:^(UIImage *image, NSURL *url) {
        if ([self.delegate respondsToSelector:@selector(yk_requestAdImageFinished:adImage:adUrl:)]) {
            [self.delegate yk_requestAdImageFinished:self adImage:image adUrl:url];
        }
    }];
}

- (void)adAnimate {
    CGFloat duration = self.countdown;
    duration = duration/4.0;
    if(duration > 1.0) duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        self.adImageView.alpha = 1;
    } completion:^(BOOL finished) {}];
}

- (void)start {
    if ([self.delegate respondsToSelector:@selector(yk_willLoadAd:)]) {
        [self.delegate yk_willLoadAd:self];
    } else {
        NSAssert(NO, @"delegate必须要实现yk_willLoadAd:。");
    }
    
    if ([self.delegate respondsToSelector:@selector(yk_willAdCountdownEnding)]) {
        [self.delegate yk_willAdCountdownEnding];
    } else {
        NSAssert(NO, @"delegate必须要实现yk_willAdCountdownEnding。");
    }
    
    [[UIApplication sharedApplication].delegate window].rootViewController = self;
    [self refreshCountsownTimer];
}

#pragma mark - lazy

- (UIImageView *)launchImageView {
    if(_launchImageView == nil) {
        _launchImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _launchImageView.backgroundColor = [UIColor whiteColor];
        _launchImageView.image = [self fetchLaunchImage];
    }
    
    return _launchImageView;
}

- (UIImageView *)adImageView {
    if(_adImageView == nil) {
        _adImageView = [[UIImageView alloc] initWithFrame:_adFrame];
        _adImageView.backgroundColor = [UIColor whiteColor];
        _adImageView.userInteractionEnabled = YES;
        _adImageView.alpha = 0.2;
        UITapGestureRecognizer *adTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTapAction:)];
        [_adImageView addGestureRecognizer:adTap];
    }
    
    return _adImageView;
}

- (UIButton *)skipButton {
    if (_skipButton == nil) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = YKSkipButtonFrame;
        [_skipButton setBackgroundImage:[UIImage imageWithBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] rect:_skipButton.frame radius:14] forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
        if(!self.countdown || self.countdown<=0) self.countdown = YKDefaultAdCountdown;
        if(!_skipType) _skipType = YKSkipTypeTimerText;
    }
    
    return _skipButton;
}

- (void)setAdFrame:(CGRect)adFrame {
    _adFrame = adFrame;
    if (_adImageView) {
        _adImageView.frame = _adFrame;
    }
}

#pragma mark - Click Action

- (void)adTapAction:(UITapGestureRecognizer *)tap {
    if (self.countdown > 0) {
        if ([self.delegate respondsToSelector:@selector(yk_didAdClicked)]) {
            [self.delegate yk_didAdClicked];
        }
    }
}

- (void)skipAction {
    if (_skipType != YKSkipTypeTimer) {
        _adClick = NO;
        [self adCountdownEndingWithAnimations];
    }
}

#pragma mark - other

- (void)skipButtonTitleWithDuration:(NSInteger)duration {
    switch (_skipType) {
        case YKSkipTypeNone:
            _skipButton.hidden = YES;
            
            break;
        case YKSkipTypeTimer:
            [_skipButton setTitle:[NSString stringWithFormat:@"%ld S", (long)duration] forState:UIControlStateNormal];
            
            break;
        case YKSkipTypeText:
            [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
            
            break;
        case YKSkipTypeTimerText:
            [_skipButton setTitle:[NSString stringWithFormat:@"%ld 跳过", (long)duration] forState:UIControlStateNormal];
            
            break;
            
        default:
            break;
    }
}

- (UIImage *)fetchLaunchImage {
    UIImage *launchImage = [self launchImageWithLaunchImageOrientation:YKBundleInfoKeyPortrait];
    if(launchImage) return launchImage;
    
    launchImage = [self launchImageWithLaunchImageOrientation:YKBundleInfoKeyLandscape];
    if(launchImage) return launchImage;
    
    NSLog(@"YKLaunchAd：获取LaunchImage失败!请检查启动图是否添加正确");
    return nil;
}

- (UIImage *)launchImageWithLaunchImageOrientation:(NSString *)launchImageOrientation {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (self.launchScreenName.length > 0) {
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:self.launchScreenName bundle:nil];
        for (id obj in loginStoryboard.instantiateInitialViewController.view.subviews) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)obj;
                
                return imageView.image;
            }
        }
    } else {
        NSString *launchImageName = nil;
        NSArray *launchImages = [[[NSBundle mainBundle] infoDictionary] valueForKey:YKBundleInfoKeyUILaunchImages];
        if (launchImages.count > 0) {
            for (NSDictionary *imageDic in launchImages) {
                CGSize imageSize = CGSizeFromString(imageDic[YKBundleInfoKeyUILaunchImageSize]);
                
                if ([launchImageOrientation isEqualToString:imageDic[YKBundleInfoKeyUILaunchImageOrientation]]) {
                    if ([imageDic[YKBundleInfoKeyUILaunchImageOrientation] isEqualToString:YKBundleInfoKeyLandscape]) {
                        imageSize = CGSizeMake(imageSize.height, imageSize.width);
                    }
                    
                    if (CGSizeEqualToSize(imageSize, screenSize)) {
                        launchImageName = imageDic[YKBundleInfoKeyUILaunchImageName];
                        UIImage *image = [UIImage imageNamed:launchImageName];
                        
                        return image;
                    }
                }
            }
        }
    }
    
    return nil;
}

- (void)refreshCountsownTimer {
    if (!_countdownTimer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _countdownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_countdownTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    }
    
    dispatch_source_set_event_handler(_countdownTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self skipButtonTitleWithDuration:self.countdown];
            if (self.countdown == 0) {
                [self adCountdownEndingWithAnimations];
            }
            
            self.countdown--;
        });
    });
    dispatch_resume(_countdownTimer);
}

- (void)adCountdownEndingWithAnimations {
    if (_countdownTimer) dispatch_source_cancel(_countdownTimer);
    
    if ([self.delegate respondsToSelector:@selector(yk_customAdEndingAnimations:)]) {
        [self.delegate yk_customAdEndingAnimations:^{
            [self adCountdownEnding];
        }];
    } else {
        [UIView transitionWithView:[[UIApplication sharedApplication].delegate window] duration:0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            BOOL oldState = [UIView areAnimationsEnabled];
            [UIView setAnimationsEnabled:NO];
            [self adCountdownEnding];
            [UIView setAnimationsEnabled:oldState];
        } completion:NULL];
    }
}

- (void)adCountdownEnding {
    _adCountdownEnd = YES;
    if ([self.delegate respondsToSelector:@selector(yk_willAdCountdownEnding)]) {
        [self.delegate yk_willAdCountdownEnding];
    }
}

@end

































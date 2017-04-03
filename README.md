# YKLaunchAdDemo

一个支持显示GIF、静态图，自定义广告视图frame，自带图片下载、缓存，支持自定义广告结束转场动画，支持iPhone、iPad的开机启动广告。

显示广告过程中的回调通过delegate，共有五个回调方法，使用delegate比block代码更加清晰，有更好的阅读性，虽然会多写几行代码。

### YKLaunchAdDelegate

@required

- (void)yk_willLoadAd:(YKLaunchAd *)launchAd

	第一个回调方法，当调用[start]方法后开始执行，在此方法内从服务器获取广告数据，例如：url。然后调用launchAd的setImageUrl方法。
	
```	
- (void)yk_willLoadAd:(YKLaunchAd *)launchAd {
	// requestAdData表示从服务器请求广告数据
   [self requestAdData:^(NSString *imgUrl, NSInteger duration) {
        [launchAd setImageUrl:imgUrl countdown:duration skipType:YKSkipTypeTimerText options:YKWebImageUseNSURLCache ];
    }];
}
```
	
- (void)yk_requestAdImageFinished:(YKLaunchAd *)launchAd adImage:(UIImage *)adImage adUrl:(NSURL *)adUrl

	下载广告图完成后调用，在这里做修改adImage、countdown、adFrame等。
	
- (void)yk_willAdCountdownEnding

	倒计时结束回调，在此方法内进行界面跳转等操作。
	
@optional

- (void)yk_didAdClicked

	点击广告视图回调，在此方法内跳转到广告页面。
	
- (void)yk_customAdEndingAnimations:(void(^)())animations

	此方法可以自定义广告结束后的转场动画，默认动画是UIViewAnimationOptionTransitionCrossDissolve。
	
### 属性

- adFrame

	默认值是[UIScreen mainScreen].bounds。如果设置adFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-100)；
	<img src="/Users/jinstar520/Desktop/Simulator Screen Shot 2017年4月3日 下午12.02.18.png" style="width:320px; height:568px"></img>
	
- countdown

	广告显示倒计时，默认值为3。例如在初始化的时候countdown =3，如果从服务器获取数据的时间大于3秒，会直接调用`yk_willAdCountdownEnding `方法结束广告显示；如果如果从服务器获取数据的时间小于3秒，比如花费了一秒钟，如果不刷新countdown，倒计时按钮显示的数字为2。
	
- adClickCountdownEnding

	默认值为YES。`adClickCountdownEnding=YES`，当从广告页返回后，无论countdown是否为0，都会调用`yk_willAdCountdownEnding`；`adClickCountdownEnding=NO`，如果countdown > 0，会继续倒计时，直到countdown==0时，再调用`yk_willAdCountdownEnding`。
	
- launchScreenName
	launchScreen.storyboard的文件名。默认从Assets中读取启动图作为从服务器获取广告数据时的占位图。当启动图需要从launchScreen.storyboard读取时进行赋值。
	
### 方法

- (void)start

	开始倒计时。调用此方法后，开始执行`yk_willLoadAd:(YKLaunchAd *)launchAd`方法
	
- (void)setImageUrl:(NSString *)imageUrl    
          countdown:(NSInteger)countdown   
           skipType:(YKSkipType)skipType   
            options:(YKWebImageOptions)options
            
	加载广告图。从服务器获取数据后调用。
	
### 使用示例：

YKLaunchAd *launchAd = [[YKLaunchAd alloc] init];
launchAd.delegate = self;    
[launchAd start];



	
	
	
	
	
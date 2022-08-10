//
//  JADAppDelegate.m
//  JADYun
//
//  Created by shuaishuai0814 on 07/15/2020.
//  Copyright (c) 2020 shuaishuai0814. All rights reserved.
//

#import "JADAppDelegate.h"
#if __has_include(<JADYunCore/JADYunUmbrella.h>)
#import <JADYunCore/JADYunUmbrella.h>
#else
#import <JADYun/JADYunUmbrella.h>
#endif

#if __has_include(<JADYunSplash/JADSplashView.h>)
#import <JADYunSplash/JADSplashView.h>
#else
#import <JADYun/JADSplashView.h>
#endif


#import "JADLaunchScreenView.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface JADAppDelegate ()<JADSplashViewDelegate>

/// 启动页图片
@property (nonatomic, strong) JADLaunchScreenView *launchScreenView;

/// 开屏广告
@property (strong, nonatomic) JADSplashView *splashView;

@end

@implementation JADAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (self.window == nil) {
        UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [keyWindow makeKeyAndVisible];
        self.window = keyWindow;
        self.window.rootViewController = [self rootViewController];
    }
    
    // 初始化营销云SDK&开屏广告
    [self setupSDK];
            
    return YES;
}

- (UIViewController *)rootViewController {
    UIViewController *mainViewController = [[UIViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    return navigationVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // on iOS 15.0
    // Calls to the API only prompt when the application state is: UIApplicationStateActive.
    // Calls to the API through an app extension do not prompt.
    // 大致意思：调用这个API requestTrackingAuthorization 必须是App在前台活跃的前提下。
    // ATT 权限获取
    [self getAdvertisingTrackingAuthority];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Initialize SDK

- (void)setupSDK {
    // 初始化广告SDK
    [self initJADYunSDK];
    
    // 加载开屏广告
    [self addSplashAdView];
}

- (void)initJADYunSDK {
    // Configuration
#if DEBUG
    // 设置日志开关
    [JADYunSDK enableLog:YES];
#endif
    
    /*
     * 是否允许JADYunSDK使用地理位置权限，可选配置
     *（1）不进行设置时 默认为YES 允许使用；
     *（2）若您不允许，则需要通过seUserLoaction:传入一个地理位置。
        例：
           JADLocation *location =  [[JADLocation alloc]init];
           location.latitude = @123.22343;
           location.longitude = @43.491123;
           [JADYunSDK setUserLocation:location];
     */
    
    [JADYunSDK canUseLocation:YES];
    
    /*
     * 设置Pollux，Optional
     * 例：
           JADPollux *currentPollux = [[JADPollux alloc] init];
           currentPollux.polluxValue = @"YOUR_POLLUX_ID";
           currentPollux.polluxVersion = @"YOUR_POLLUX_VERSION";
         
           [JADYunSDK setPolluxArray:@[currentPollux]];
     */
        
    /*
     * 设置idfa，Optional
     * [JADYunSDK setCustomIDFA:@"12345678-1234-1234-1234-123456789012"];
     */
    // 初始化营销云 SDK
    [JADYunSDK initWithAppID:@"665567"];
}

#pragma mark - Splash View

- (void)addSplashAdView {
    // 加载开屏广告
    [self.splashView loadAdData];

    // 设置Demo开屏
    [self.window.rootViewController.view addSubview:self.launchScreenView];
}

- (void)removeSplashAdView {
    if (self.splashView) {
        [self.splashView removeFromSuperview];
        self.splashView = nil;
    }
}

#pragma mark - JADSplashDelegatex

// 加载成功回调
- (void)jadSplashViewDidLoadSuccess:(JADSplashView *)splashView {
    JADLogI(@"SplashView Did Load Success");
}

// 返回的错误码（error），表示广告加载失败的原因，所有错误码详情，请见接入文档/iOS/错误码
- (void)jadSplashViewDidLoadFailure:(JADSplashView *)splashView error:(NSError *)error {
    JADLogI(@"SplashView Did Load Failure");
    [self removeSplashAdView];
    [self.launchScreenView setAutoCloseAfterTime:2];
}

// 渲染成功回调
- (void)jadSplashViewDidRenderSuccess:(JADSplashView *)splashView {
    JADLogI(@"SplashView Did Render Success");
    [self.launchScreenView addSubview:splashView];
}

// 渲染失败，网络原因或者硬件原因导致渲染失败，可以更换手机或者网络环境测试。
- (void)jadSplashViewDidRenderFailure:(JADSplashView *)splashView error:(NSError *)error {
    JADLogI(@"SplashView Did Render Failure");
    [self.launchScreenView setAutoCloseAfterTime:2];
}

// 开屏广告即将展示
- (void)jadSplashViewDidExposure:(JADSplashView *)splashView {
    JADLogI(@"SplashView Did Exposure");
}

// 点击回调
- (void)jadSplashViewDidClick:(JADSplashView *)splashView {
    JADLogI(@"SplashView Did Click");
    [self.launchScreenView setAutoCloseAfterTime:0];
}

// 关闭回调，当点击跳过按钮或者用户点击广告时会直接触发此回调，建议在此回调方法中直接进行广告对象的移除动作，并将广告对象置为nil
- (void)jadSplashViewDidClose:(JADSplashView *)splashView {
    JADLogI(@"SplashView Did Close");

    [self removeSplashAdView];
    [self.launchScreenView setAutoCloseAfterTime:0];
}

#pragma mark - ATT 权限获取

- (void)getAdvertisingTrackingAuthority {
    if (@available(iOS 14, *)) {
        ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
        switch (status) {
            case ATTrackingManagerAuthorizationStatusDenied:
                JADLogD(@"用户拒绝IDFA");
                break;
            case ATTrackingManagerAuthorizationStatusAuthorized:
                JADLogD(@"用户允许IDFA");
                break;
            case ATTrackingManagerAuthorizationStatusNotDetermined:
                JADLogD(@"用户未做选择或未弹窗IDFA");
                //请求弹出用户授权框，只会在程序运行是弹框1次，除非卸载app重装，通地图、相机等权限弹框一样
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                    JADLogD(@"app追踪IDFA权限：%lu",(unsigned long)status);
                }];
                break;
            default:
                break;
        }
    } else {
        // Fallback on earlier versions
        if ([ASIdentifierManager.sharedManager isAdvertisingTrackingEnabled]) {
            JADLogD(@"用户开启了广告追踪IDFA");
        } else {
            JADLogD(@"用户关闭了广告追踪IDFA");
        }
    }
}

#pragma mark - Setter/Getter

- (JADSplashView *)splashView {
    if (!_splashView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _splashView = [[JADSplashView alloc] initWithSlotID:@"2514" adSize:CGSizeMake(frame.size.width, frame.size.height - 100)];
        // Required 回调代理
        _splashView.delegate = self;
        
        // Required 开屏落地页控制器设置
        _splashView.rootViewController = self.window.rootViewController;
        
        // Optional  加载广告最大容忍时长，默认5s
        _splashView.tolerateTime = 5;
        
        // Optional  开屏广告跳过时长，默认5s
        _splashView.skipTime = 5;
    }
    return _splashView;
}

- (JADLaunchScreenView *)launchScreenView {
    if (!_launchScreenView) {
        _launchScreenView = [[JADLaunchScreenView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _launchScreenView;
}
@end

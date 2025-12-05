//
//  SplashAdViewModel.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "SplashAdViewModel.h"
#import "SplashAdListener.h"
#import "AppUtil.h"
#import <Toast/Toast.h>

@interface SplashAdViewModel()
@property(nonatomic, strong) SplashAdListener *listener;
@end

@implementation SplashAdViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.listener = [[SplashAdListener alloc] init];
    }
    return self;
}

- (BOOL)hasLogo {
    XLFormRowDescriptor *row = [self.viewController.form formRowWithTag:@"klogo"];
    return [row.value isEqualToString:@"展示"];
}

- (void)loadAdAndShow:(NSString *)placementId {
    [AppUtil toast:@"开始加载广告..."];
    WindMillSplashAd *splashAd = [self getAdInstance:placementId];
    if (splashAd == nil) {
        DDLogDebug(@"创建广告对象失败");
        return;
    }
    if ([self hasLogo]) {
        UIView *logoView = [self getLogoView];
        [splashAd loadAdAndShowWithBottomView:logoView];
    }else {
        [splashAd loadAdAndShow];
    }
}

- (void)loadAd:(NSString *)placementId {
    [AppUtil toast:@"开始加载广告..."];
    WindMillSplashAd *splashAd = [self getAdInstance:placementId];
    if (splashAd == nil) {
        DDLogDebug(@"创建广告对象失败");
        return;
    }
    splashAd.rootViewController = self.viewController;
    splashAd.delegate = self.listener;
    [splashAd loadAd];
}

- (void)showAd:(NSString *)placementId {
    [AppUtil toast:@"播放广告..."];
    WindMillSplashAd *splashAd = [self getAdInstance:placementId];
    if (splashAd == nil) {
        DDLogDebug(@"创建广告对象失败");
        return;
    }
    UIWindow *window = self.viewController.view.window;
    if ([self hasLogo]) {
        UIView *logoView = [self getLogoView];
        [splashAd showAdInWindow:window withBottomView:logoView];
    }else {
        [splashAd showAdInWindow: window];
    }
}


- (WindMillSplashAd *)getAdInstance:(NSString *)placementId {
    if (placementId == nil) {
        return nil;
    }
    if ([self.adMap objectForKey:placementId] != nil) {
        return [self.adMap objectForKey:placementId];
    }
    NSMutableDictionary *extra = [NSMutableDictionary dictionary];
    CGSize adSize = UIScreen.mainScreen.bounds.size;
    if ([self hasLogo]) {
        UIView *logoView = [self getLogoView];
        CGSize logoSize = logoView.bounds.size;
        adSize = CGSizeMake(adSize.width, adSize.height - logoSize.height);
        [extra setValue:[NSValue valueWithCGSize:logoSize] forKey:WindMillConstant.BottomViewSize];
        [extra setValue:logoView forKey:WindMillConstant.BottomView];
    }
    [extra setValue:[NSValue valueWithCGSize:adSize] forKey:WindMillConstant.AdSize];
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = placementId;
    request.userId = @"your_user_id";
    WindMillSplashAd *splashAd = [[WindMillSplashAd alloc] initWithRequest:request extra:extra];
    [self.adMap setValue:splashAd forKey:placementId];
    return splashAd;
}


- (UIView *)getLogoView {
    return [AppUtil getLogoViewWithTitle:@"ToBid聚合广告平台" desc:@"值得信赖的移动广告聚合平台"];
}


@end

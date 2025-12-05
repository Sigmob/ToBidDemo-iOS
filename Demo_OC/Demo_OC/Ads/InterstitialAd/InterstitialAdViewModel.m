//
//  InterstitialAdViewModel.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "InterstitialAdViewModel.h"
#import "IntersititialAdListener.h"
#import "AppUtil.h"

@interface InterstitialAdViewModel ()
@property(nonatomic, strong) IntersititialAdListener *listener;
@end

@implementation InterstitialAdViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.listener = [[IntersititialAdListener alloc] init];
    }
    return self;
}
- (void)loadAd:(NSString *)placementId {
    [AppUtil toast:@"开始加载广告..."];
    WindMillIntersititialAd *intersititialAd = [self getAdInstance:placementId];
    if (intersititialAd == nil) {
        DDLogDebug(@"创建广告对象失败");
        return;
    }
    intersititialAd.delegate = self.listener;
    [intersititialAd loadAdData];
    
}
- (void)showAd:(NSString *)placementId {
    [AppUtil toast:@"开始播放广告..."];
    WindMillIntersititialAd *intersititialAd = [self getAdInstance:placementId];
    if (intersititialAd == nil) {
        DDLogDebug(@"创建广告对象失败");
        return;
    }
    [intersititialAd showAdFromRootViewController:self.viewController options:@{}];
}

- (WindMillIntersititialAd *)getAdInstance:(NSString *)placementId {
    if (placementId == nil) {
        return nil;
    }
    if ([self.adMap objectForKey:placementId] != nil) {
        return [self.adMap objectForKey:placementId];
    }
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = placementId;
    request.userId = @"your_user_id";
    // 用于服务端激励数据透传
    request.options = @{
        @"test_key": @"test_value"
    };
    WindMillIntersititialAd *intersititialAd = [[WindMillIntersititialAd alloc] initWithRequest:request];
    [self.adMap setValue:intersititialAd forKey:placementId];
    return intersititialAd;
}
@end

//
//  RewardVideoAdViewModel.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "RewardVideoAdViewModel.h"
#import "RewardVideoAdListener.h"
#import "AppUtil.h"

@interface RewardVideoAdViewModel ()
@property(nonatomic, strong) RewardVideoAdListener *listener;
@end

@implementation RewardVideoAdViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.listener = [[RewardVideoAdListener alloc] init];
    }
    return self;
}
- (void)loadAd:(NSString *)placementId {
    [AppUtil toast:@"开始加载广告..."];
    WindMillRewardVideoAd *rewardVideoAd = [self getAdInstance:placementId];
    if (rewardVideoAd == nil) {
        DDLogDebug(@"创建广告对象失败");
        return;
    }
    rewardVideoAd.delegate = self.listener;
    [rewardVideoAd loadAdData];
    
}
- (void)showAd:(NSString *)placementId {
    [AppUtil toast:@"开始播放广告..."];
    WindMillRewardVideoAd *rewardVideoAd = [self getAdInstance:placementId];
    if (rewardVideoAd == nil) {
        DDLogDebug(@"创建广告对象失败");
        return;
    }
    [rewardVideoAd showAdFromRootViewController:self.viewController options:@{}];
}

- (WindMillRewardVideoAd *)getAdInstance:(NSString *)placementId {
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
    WindMillRewardVideoAd *rewardVideoAd = [[WindMillRewardVideoAd alloc] initWithRequest:request];
    [self.adMap setValue:rewardVideoAd forKey:placementId];
    return rewardVideoAd;
}
@end


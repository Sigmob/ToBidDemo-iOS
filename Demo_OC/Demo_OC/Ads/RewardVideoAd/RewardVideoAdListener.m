//
//  RewardVideoAdListener.m
//  Demo_OC
//
//  Created by Codi on 2025/11/10.
//

#import "RewardVideoAdListener.h"
#import <Toast/Toast.h>
#import "AppUtil.h"

@implementation RewardVideoAdListener

- (void)rewardVideoAd:(WindMillRewardVideoAd * _Nonnull)rewardVideoAd reward:(WindMillRewardInfo * _Nonnull)reward { 
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"rewardVideoAd:reward:"];
}

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"rewardVideoAdDidLoad:"];
}

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"rewardVideoAdDidLoad:didFailWithError" error:error];
}

- (void)rewardVideoAdWillVisible:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%s", __func__);
}
- (void)rewardVideoAdDidVisible:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%s", __func__);
}

- (void)rewardVideoAdDidShowFailed:(WindMillRewardVideoAd *)rewardVideoAd error:(NSError *)error {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"rewardVideoAdDidShowFailed" error:error];
}

- (void)rewardVideoAdDidClick:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%s", __func__);
}

- (void)rewardVideoAdDidClickSkip:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%s", __func__);
}

- (void)rewardVideoAdDidPlayFinish:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%s", __func__);
}

- (void)rewardVideoAdWillClose:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%s", __func__);
}

- (void)rewardVideoAdDidClose:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%s", __func__);
}

- (void)rewardVideoAdDidAutoLoad:(WindMillRewardVideoAd *)rewardVideoAd {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"rewardVideoAdDidAutoLoad"];
}

- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd didAutoLoadFailWithError:(NSError *)error {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"rewardVideo:didAutoLoadFailWithError" error:error];
}
@end

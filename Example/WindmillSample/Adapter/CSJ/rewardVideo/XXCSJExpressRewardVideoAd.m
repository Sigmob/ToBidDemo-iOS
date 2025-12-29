//
//  XXCSJExpressRewardVideoAd.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/24.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "XXCSJExpressRewardVideoAd.h"
#import <WindMillSDK/WindMillSDK.h>
#import <WindFoundation/WindFoundation.h>
#import <BUAdSDK/BUAdSDK.h>

@interface XXCSJExpressRewardVideoAd ()<BUNativeExpressRewardedVideoAdDelegate>
@property (nonatomic, weak) id<AWMCustomRewardedVideoAdapterBridge> bridge;
@property (nonatomic, weak) id<AWMCustomRewardedVideoAdapter> adapter;
@property (nonatomic, strong) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation XXCSJExpressRewardVideoAd
- (instancetype)initWithBridge:(id<AWMCustomAdapterBridge>)bridge adapter:(id<AWMCustomAdapter>)adapter {
    self = [super init];
    if (self) {
        _bridge = (id<AWMCustomRewardedVideoAdapterBridge>)bridge;
        _adapter = (id<AWMCustomRewardedVideoAdapter>)adapter;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    return self.isReady;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    WindMillAdRequest *request = [self.bridge adRequest];
    model.userId = request.userId;
    self.rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:placementId rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
}
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    return [self.rewardedVideoAd showAdFromRootViewController:viewController];
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    if (result.win) {
        [self.rewardedVideoAd setPrice:@(result.winnerPrice)];
        [self.rewardedVideoAd win:@(result.winnerPrice)];
        return;
    }
    [self.rewardedVideoAd loss:nil lossReason:@"102" winBidder:nil];
}
- (void)dealloc {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
}
#pragma mark - BUNativeExpressRewardedVideoAdDelegate
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    NSString *price = [[rewardedVideoAd.mediaExt objectForKey:@"price"] stringValue];
    [self.bridge rewardedVideoAd:self.adapter didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
}
- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
                    didFailWithError:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge rewardedVideoAd:self.adapter didLoadFailWithError:error ext:nil];
}
- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = YES;
    [self.bridge rewardedVideoAdDidLoad:self.adapter];
}
- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge rewardedVideoAdDidVisible:self.adapter];
}
- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge rewardedVideoAdDidClose:self.adapter];
}
- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge rewardedVideoAdDidClick:self.adapter];
}
- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge rewardedVideoAdDidClickSkip:self.adapter];
}
- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge rewardedVideoAd:self.adapter didPlayFinishWithError:error];
}
- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    WindMillRewardInfo *info = [[WindMillRewardInfo alloc] init];
    info.isCompeltedView = YES;
    [self.bridge rewardedVideoAd:self.adapter didRewardSuccessWithInfo:info];
}
@end

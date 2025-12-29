//
//  XXCSJExpressFullscreenVideoAd.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/24.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "XXCSJExpressFullscreenVideoAd.h"
#import <BUAdSDK/BUAdSDK.h>
#import <WindMillSDK/WindMillSDK.h>
#import <WindFoundation/WindFoundation.h>

@interface XXCSJExpressFullscreenVideoAd ()<BUNativeExpressFullscreenVideoAdDelegate>
@property (nonatomic, weak) id<AWMCustomInterstitialAdapterBridge> bridge;
@property (nonatomic, weak) id<AWMCustomInterstitialAdapter> adapter;
@property (nonatomic, strong) BUNativeExpressFullscreenVideoAd *expressFullscreenVideoAd;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation XXCSJExpressFullscreenVideoAd
- (instancetype)initWithBridge:(id<AWMCustomAdapterBridge>)bridge adapter:(id<AWMCustomAdapter>)adapter {
    self = [super init];
    if (self) {
        _bridge = (id<AWMCustomInterstitialAdapterBridge>)bridge;
        _adapter = (id<AWMCustomInterstitialAdapter>)adapter;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    return self.isReady;
}
- (void)loadAdWithPlacementId:(NSString *)placementId
                    parameter:(AWMParameter *)parameter {
    self.expressFullscreenVideoAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID:placementId];
    self.expressFullscreenVideoAd.delegate = self;
    [self.expressFullscreenVideoAd loadAdData];
}
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    [self.expressFullscreenVideoAd showAdFromRootViewController:viewController];
    return YES;
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    if (result.win) {
        [self.expressFullscreenVideoAd setPrice:@(result.winnerPrice)];
        [self.expressFullscreenVideoAd win:@(result.winnerPrice)];
        return;
    }
    [self.expressFullscreenVideoAd loss:nil lossReason:@"102" winBidder:nil];
}
#pragma mark - BUNativeExpressFullscreenVideoAdDelegate
- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    NSString *price = [[fullscreenVideoAd.mediaExt objectForKey:@"price"] stringValue];
    [self.bridge interstitialAd:self.adapter didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
}
- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge interstitialAd:self.adapter didLoadFailWithError:error ext:nil];
}
- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = YES;
    [self.bridge interstitialAdDidLoad:self.adapter];
}
- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge interstitialAd:self.adapter didLoadFailWithError:error ext:nil];
}
- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge interstitialAdDidVisible:self.adapter];
}
- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidClick:self.adapter];
}
- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidClickSkip:self.adapter];
}
- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidClose:self.adapter];
}
- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAd:self.adapter didPlayFinishWithError:error];
}
@end

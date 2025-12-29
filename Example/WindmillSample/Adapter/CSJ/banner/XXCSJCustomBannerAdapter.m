//
//  XXCSJCustomBannerAdapter.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/18.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "XXCSJCustomBannerAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import <WindFoundation/WindFoundation.h>

@interface  XXCSJCustomBannerAdapter()<BUNativeExpressBannerViewDelegate>
@property (nonatomic, weak) id<AWMCustomBannerAdapterBridge> bridge;
@property (nonatomic, strong) BUNativeExpressBannerView *bannerView;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation XXCSJCustomBannerAdapter
- (instancetype)initWithBridge:(id<AWMCustomBannerAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    NSString *sizeStr = [parameter.customInfo objectForKey:@"adSize"];
    CGSize adSize = CGSizeFromString(sizeStr);
    if (CGSizeEqualToSize(CGSizeZero, adSize)) {
        NSError *error = [NSError errorWithDomain:@"strategy" code:-60004 userInfo:@{NSLocalizedDescriptionKey:@"adSize设置错误"}];
        [self.bridge bannerAd:self didLoadFailWithError:error ext:nil];
        return;
    }
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    self.bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:parameter.placementId rootViewController:viewController adSize:adSize];
    self.bannerView.delegate = self;
    //设置bannerView的size，否则可能导致聚合在展示时因无法获取size而展示异常
    self.bannerView.frame = CGRectMake(0, 0, adSize.width, adSize.height);
    [self.bannerView loadAdData];
}
- (BOOL)mediatedAdStatus {
    return self.isReady;
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    if (result.win) {
        [self.bannerView setPrice:@(result.winnerPrice)];
        [self.bannerView win:@(result.winnerPrice)];
        return;
    }
    [self.bannerView loss:nil lossReason:@"102" winBidder:nil];
}
- (void)destory {
    self.isReady = NO;
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}
#pragma mark - BUNativeExpressBannerViewDelegate
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
    NSString *price = [[bannerAdView.mediaExt objectForKey:@"price"] stringValue];
    [self.bridge bannerAd:self didAdServerResponse:bannerAdView ext:@{
        AWMMediaAdLoadingExtECPM: price
    }];
}
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView
             didLoadFailWithError:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
    self.isReady = NO;
    [self.bridge bannerAd:self didLoadFailWithError:error ext:nil];
}
- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
    self.isReady = YES;
    [self.bridge bannerAd:self didLoad:bannerAdView];
}
- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView
                                      error:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
    [self.bridge bannerAd:self didLoadFailWithError:error ext:nil];
}
- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
    [self.bridge bannerAdDidBecomeVisible:self bannerView:bannerAdView];
}
- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
    [self.bridge bannerAdDidClick:self bannerView:bannerAdView];
}
- (void)nativeExpressBannerAdViewDidCloseOtherController:(BUNativeExpressBannerView *)bannerAdView interactionType:(BUInteractionType)interactionType {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
    if (interactionType == BUInteractionTypeVideoAdDetail ||
        interactionType == BUInteractionTypePage) {
        [self.bridge bannerAdWillPresentFullScreenModal:self bannerView:bannerAdView];
    }else if(interactionType == BUInteractionTypeURL) {
        [self.bridge bannerAdWillLeaveApplication:self bannerAdView:bannerAdView];
    }else if (interactionType == BUInteractionTypePage
              || interactionType == BUInteractionTypeDownload
              || interactionType == BUInteractionTypeVideoAdDetail) {
        [self.bridge bannerAdWillDismissFullScreenModal:self bannerView:bannerAdView];
    }
}
- (void)nativeExpressBannerAdViewDidRemoved:(BUNativeExpressBannerView *)bannerAdView {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
    [self.bridge bannerAdDidClosed:self bannerView:bannerAdView];
}
@end

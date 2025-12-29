//
//  XXNativeExpressAdManager.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/20.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "XXNativeExpressAdManager.h"
#import <WindMillSDK/WindMillSDK.h>
#import <WindFoundation/WindFoundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import "XXCSJNativeAdData.h"
#import "XXCSJNativeAdViewCreator.h"

@interface XXNativeExpressAdManager ()<BUNativeExpressAdViewDelegate>
@property (nonatomic, weak) id<AWMCustomNativeAdapterBridge> bridge;
@property (nonatomic, weak) id<AWMCustomNativeAdapter> adapter;
@property (nonatomic, strong) BUNativeExpressAdManager *nativeExpressAdManager;
@property (nonatomic, strong) NSArray<BUNativeExpressAdView *> *adViews;
@end

@implementation XXNativeExpressAdManager
- (instancetype)initWithBridge:(id<AWMCustomAdapterBridge>)bridge adapter:(id<AWMCustomAdapter>)adapter {
    self = [super init];
    if (self) {
        _bridge = (id<AWMCustomNativeAdapterBridge>)bridge;
        _adapter = (id<AWMCustomNativeAdapter>)adapter;
    }
    return self;
}
- (void)loadAdWithPlacementId:(NSString *)placementId adSize:(CGSize)size parameter:(AWMParameter *)parameter {
    self.adViews = nil;
    BUAdSlot *adSlot = [[BUAdSlot alloc] init];
    adSlot.ID = placementId;
    adSlot.AdType = BUAdSlotAdTypeFeed;
    adSlot.supportRenderControl = YES;
    BUProposalSize propSize = BUProposalSize_Feed690_388;
    NSString *imgType = [parameter.customInfo objectForKey:@"imgType"];
    if ([imgType isEqualToString:@"1"]) {
        propSize = BUProposalSize_Feed228_150;
    }
    BUSize *imgSize = [BUSize sizeBy:propSize];
    adSlot.imgSize = imgSize;
    adSlot.position = BUAdSlotPositionFeed;
    //高度为0是自适应
    self.nativeExpressAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:adSlot adSize:size];
    self.nativeExpressAdManager.adSize = size;
    self.nativeExpressAdManager.delegate = self;
    if (parameter.isHeaderBidding) {
        [self.nativeExpressAdManager loadAdDataWithCount:1];
    }else {
        NSUInteger count = [[parameter.extra objectForKey:AWMAdLoadingParamNALoadAdCount] integerValue];
        [self.nativeExpressAdManager loadAdDataWithCount:count];
    }
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    [self.adViews enumerateObjectsUsingBlock:^(BUNativeExpressAdView * adView, NSUInteger idx, BOOL * stop) {
        if (result.win) {
            [adView win:@(result.winnerPrice)];
        }else {
            [adView loss:nil lossReason:@"102" winBidder:nil];
        }
    }];
    self.adViews = nil;
}
#pragma mark - BUNativeExpressAdViewDelegate
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager views:(NSArray<__kindof BUNativeExpressAdView *> *)views {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.adViews = views;
    BUNativeExpressAdView *expressAdView = views.firstObject;
    NSString *price = [[expressAdView.mediaExt objectForKey:@"price"] stringValue];
    [self.bridge nativeAd:self.adapter didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
    NSMutableArray *adArray = [[NSMutableArray alloc] init];
    for (BUNativeExpressAdView *adView in views) {
        AWMMediatedNativeAd *mNativeAd = [[AWMMediatedNativeAd alloc] init];
        mNativeAd.originMediatedNativeAd = adView;
        mNativeAd.viewCreator = [[XXCSJNativeAdViewCreator alloc] initWithExpressAdView:adView];
        mNativeAd.view = adView;
        [adArray addObject:mNativeAd];
    }
    [self.bridge nativeAd:self.adapter didLoadWithNativeAds:adArray];
}
- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager error:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.adViews = nil;
    [self.bridge nativeAd:self.adapter didLoadFailWithError:error];
}
- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge nativeAd:self.adapter renderSuccessWithExpressView:nativeExpressAdView];
}
- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge nativeAd:self.adapter renderFailWithExpressView:nativeExpressAdView andError:error];
}
- (void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge nativeAd:self.adapter didVisibleWithMediatedNativeAd:nativeExpressAdView];
}
- (void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge nativeAd:self.adapter didClickWithMediatedNativeAd:nativeExpressAdView];
}
- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView stateDidChanged:(BUPlayerPlayState)playerState {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
}
- (void)nativeExpressAdViewPlayerDidPlayFinish:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
}
- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    NSMutableArray *reasons = [[NSMutableArray alloc] init];
    for (BUDislikeWords *words in filterWords) {
        if (words.name) [reasons addObject:words.name];
    }
    [self.bridge nativeAd:self.adapter didClose:nativeExpressAdView closeReasons:reasons];
}
- (void)nativeExpressAdViewWillPresentScreen:(BUNativeExpressAdView *)nativeExpressAdView {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge nativeAd:self.adapter willPresentFullScreenModalWithMediatedNativeAd:nativeExpressAdView];
}
- (void)nativeExpressAdViewDidCloseOtherController:(BUNativeExpressAdView *)nativeExpressAdView interactionType:(BUInteractionType)interactionType {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge nativeAd:self.adapter didDismissFullScreenModalWithMediatedNativeAd:nativeExpressAdView];
}
- (void)nativeExpressAdViewDidRemoved:(BUNativeExpressAdView *)nativeExpressAdView {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
}
- (void)dealloc {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
}
@end

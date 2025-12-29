//
//  XXNativeAdsManager.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/20.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "XXNativeAdsManager.h"
#import <BUAdSDK/BUAdSDK.h>
#import <WindFoundation/WindFoundation.h>
#import "XXCSJNativeAdData.h"
#import "XXCSJNativeAdViewCreator.h"

@interface XXNativeAdsManager ()<BUNativeAdsManagerDelegate, BUNativeAdDelegate>
@property (nonatomic, weak) id<AWMCustomNativeAdapterBridge> bridge;
@property (nonatomic, weak) id<AWMCustomNativeAdapter> adapter;
@property (nonatomic, strong) BUNativeAdsManager *nativeAdsManager;
@property (nonatomic, strong) NSArray<BUNativeAd *> *nativeAdDataArray;
@end

@implementation XXNativeAdsManager
- (instancetype)initWithBridge:(id<AWMCustomAdapterBridge>)bridge adapter:(id<AWMCustomAdapter>)adapter {
    self = [super init];
    if (self) {
        _bridge = (id<AWMCustomNativeAdapterBridge>)bridge;
        _adapter = (id<AWMCustomNativeAdapter>)adapter;
    }
    return self;
}
- (void)loadAdWithPlacementId:(NSString *)placementId adSize:(CGSize)size parameter:(AWMParameter *)parameter {
    self.nativeAdDataArray = nil;
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
    adSlot.adSize = size;
    self.nativeAdsManager = [[BUNativeAdsManager alloc] initWithSlot:adSlot];
    self.nativeAdsManager.delegate = self;
    if (parameter.isHeaderBidding) {
        [self.nativeAdsManager loadAdDataWithCount:1];
    }else {
        NSUInteger count = [[parameter.extra objectForKey:AWMAdLoadingParamNALoadAdCount] integerValue];
        [self.nativeAdsManager loadAdDataWithCount:count];
    }
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    [self.nativeAdDataArray enumerateObjectsUsingBlock:^(BUNativeAd * nativeAd, NSUInteger idx, BOOL * stop) {
        if (result.win) {
            [nativeAd win:@(result.winnerPrice)];
        }else {
            [nativeAd loss:nil lossReason:@"102" winBidder:nil];
        }
    }];
    self.nativeAdDataArray = nil;
}
#pragma mark - BUNativeAdsManagerDelegate
- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *)nativeAdDataArray {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.nativeAdDataArray = nativeAdDataArray;
    BUNativeAd *ad = nativeAdDataArray.firstObject;
    NSString *price = [[ad.data.mediaExt objectForKey:@"price"] stringValue];
    [self.bridge nativeAd:self.adapter didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
    NSMutableArray *adArray = [[NSMutableArray alloc] init];
    for (BUNativeAd *nativeAd in nativeAdDataArray) {
        nativeAd.delegate = self;
        AWMMediatedNativeAd *mNativeAd = [[AWMMediatedNativeAd alloc] init];
        mNativeAd.data = [[XXCSJNativeAdData alloc] initWithAd:nativeAd];
        mNativeAd.originMediatedNativeAd = nativeAd;
        BUNativeAdRelatedView *adView = [[BUNativeAdRelatedView alloc] init];
        mNativeAd.viewCreator = [[XXCSJNativeAdViewCreator alloc] initWithNativeAd:nativeAd adView:adView];
        [adArray addObject:mNativeAd];
    }
    [self.bridge nativeAd:self.adapter didLoadWithNativeAds:adArray];
}
- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.nativeAdDataArray = nil;
    [self.bridge nativeAd:self.adapter didLoadFailWithError:error];
}
#pragma mark - BUNativeAdDelegate
- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge nativeAd:self.adapter didVisibleWithMediatedNativeAd:nativeAd];
}
- (void)nativeAdDidCloseOtherController:(BUNativeAd *)nativeAd
                        interactionType:(BUInteractionType)interactionType {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge nativeAd:self.adapter didDismissFullScreenModalWithMediatedNativeAd:nativeAd];
}
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd
                withView:(UIView *)view {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge nativeAd:self.adapter didClickWithMediatedNativeAd:nativeAd];
}
- (void)nativeAd:(BUNativeAd *)nativeAd
dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    NSMutableArray *reasons = [[NSMutableArray alloc] init];
    for (BUDislikeWords *words in filterWords) {
        if (words.name) [reasons addObject:words.name];
    }
    [self.bridge nativeAd:self.adapter didClose:nativeAd closeReasons:reasons];
}
- (void)dealloc {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
}
@end

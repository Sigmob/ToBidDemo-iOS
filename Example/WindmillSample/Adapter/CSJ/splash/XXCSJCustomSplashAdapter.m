//
//  XXCSJCustomSplashAdapter.m
//  WindMillSDK
//
//  Created by Codi on 2022/10/24.
//

#import "XXCSJCustomSplashAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <BUAdSDK/BUAdSDK.h>

@interface XXCSJCustomSplashAdapter ()<BUSplashAdDelegate,BUSplashCardDelegate>
@property (nonatomic, weak) id<AWMCustomSplashAdapterBridge> bridge;
@property (nonatomic, strong) BUSplashAd *splashAd;
@property (nonatomic, strong) AWMParameter *parameter;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation XXCSJCustomSplashAdapter
- (instancetype)initWithBridge:(id<AWMCustomSplashAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    return self.isReady;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    self.parameter = parameter;
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    UIView *bottomView = [parameter.extra objectForKey:AWMAdLoadingParamSPCustomBottomView];
    UIView *supView = viewController.navigationController ? viewController.navigationController.view : viewController.view;
    NSValue *sizeValue = [parameter.extra objectForKey:AWMAdLoadingParamSPExpectSize];
    CGSize adSize = [sizeValue CGSizeValue];
    if (adSize.width * adSize.height == 0) {
        CGFloat h = CGRectGetHeight(bottomView.frame);
        adSize = CGSizeMake(supView.frame.size.width, supView.frame.size.height - h);
    }
    NSInteger splashType = [[parameter.customInfo objectForKey:@"splashType"] intValue];
    int fetchDelay = [[parameter.extra objectForKey:AWMAdLoadingParamSPTolerateTimeout] intValue];
    self.splashAd = [[BUSplashAd alloc] initWithSlotID:parameter.placementId adSize:adSize];
    self.splashAd.delegate = self;
    self.splashAd.cardDelegate = self;
//    self.splashAd.zoomOutDelegate = self;
    self.splashAd.tolerateTimeout = fetchDelay;
    self.splashAd.supportCardView = splashType == 1;
//    self.splashAd.supportZoomOutView = splashType == 1;
    [self.splashAd loadAdData];
}
- (void)showSplashAdInWindow:(UIWindow *)window parameter:(AWMParameter *)parameter {
    UIView *bottomView = [parameter.extra objectForKey:AWMAdLoadingParamSPCustomBottomView];
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    UIView *supView = viewController.navigationController ? viewController.navigationController.view : viewController.view;
    CGRect supFrame = supView.bounds;
    CGRect adFrame = CGRectMake(0, 0, supFrame.size.width, supFrame.size.height - bottomView.bounds.size.height);
    if (bottomView) {
        [supView addSubview:bottomView];
        bottomView.frame = CGRectMake(0,
                                      supFrame.size.height - CGRectGetHeight(bottomView.frame),
                                      CGRectGetWidth(bottomView.frame),
                                      CGRectGetHeight(bottomView.frame)
                                      );
    }
    UIView *splashAdView = self.splashAd.splashView;
    if (splashAdView) {
        CGRect adViewRect = CGRectMake(adFrame.origin.x, adFrame.origin.y, adFrame.size.width, adFrame.size.height);
        splashAdView.frame = adViewRect;
        splashAdView.clipsToBounds = YES;
        [supView addSubview:splashAdView];
    }else {
        NSError *error = [NSError errorWithDomain:@"splash" code:-1 userInfo:nil];
        [self.bridge splashAdDidShowFailed:self error:error];
    }
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    if (result.win) {
        [self.splashAd setPrice:@(result.winnerPrice)];
        [self.splashAd win:@(result.winnerPrice)];
        return;
    }
    [self.splashAd loss:nil lossReason:@"102" winBidder:nil];
}
- (void)destory {
    [self removeSplashAdView];
}
- (void)removeSplashAdView {
    [self.splashAd removeSplashView];
    self.splashAd = nil;
}
#pragma mark - BUSplashAdDelegate
- (void)splashAdLoadSuccess:(BUSplashAd *)splashAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    NSString *price = [[splashAd.mediaExt objectForKey:@"price"] stringValue];
    [self.bridge splashAd:self didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
}
- (void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge splashAd:self didLoadFailWithError:error ext:nil];
}
- (void)splashAdRenderSuccess:(BUSplashAd *)splashAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    NSInteger splashType = [[self.parameter.customInfo objectForKey:@"splashType"] intValue];
//    if (splashAd.zoomOutView && splashType == 1) {
//        UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
//        UIView *supView = viewController.navigationController ? viewController.navigationController.view : viewController.view;
//        [supView insertSubview:splashAd.zoomOutView belowSubview:splashAd.splashView];
//        splashAd.zoomOutView.rootViewController = viewController;
//        CGSize showSize = splashAd.zoomOutView.showSize;
//        splashAd.zoomOutView.frame = CGRectMake(-showSize.width, -showSize.height, showSize.width, showSize.height);
//    }
    self.isReady = YES;
    [self.bridge splashAdDidLoad:self];
}
- (void)splashAdRenderFail:(BUSplashAd *)splashAd error:(BUAdError *)error {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self splashAdLoadFail:splashAd error:error];
}
- (void)splashAdDidShow:(BUSplashAd *)splashAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge splashAdWillVisible:self];
}
- (void)splashAdDidClick:(BUSplashAd *)splashAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAdDidClick:self];
}
- (void)splashAdDidClose:(BUSplashAd *)splashAd closeType:(BUSplashAdCloseType)closeType {
    WindmillLogDebug(@"CSJ", @"%@ --- %ld", NSStringFromSelector(_cmd), (long)closeType);
    if (closeType == BUSplashAdCloseType_ClickSkip) {
        [self.bridge splashAdDidClickSkip:self];
    }
    if (closeType == BUSplashAdCloseType_ClickAd) {
        [self removeSplashAdView];
        [self.bridge splashAdDidClose:self];
        return;
    }
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    // 展示卡片
//    if (self.splashAd.zoomOutView) {
//        [self.splashAd showZoomOutViewInRootViewController:viewController];
//    }else {
        [self removeSplashAdView];
        [self.bridge splashAdDidClose:self];
//    }
}
- (void)splashAdViewControllerDidClose:(nonnull BUSplashAd *)splashAd {}
- (void)splashAdWillShow:(nonnull BUSplashAd *)splashAd {}
- (void)splashDidCloseOtherController:(nonnull BUSplashAd *)splashAd interactionType:(BUInteractionType)interactionType {}
- (void)splashVideoAdDidPlayFinish:(nonnull BUSplashAd *)splashAd didFailWithError:(NSError *)error {}

#pragma mark - BUSplashZoomOutDelegate
- (void)splashZoomOutViewDidClick:(BUSplashAd *)splashAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAdZoomOutViewDidClick:self];
}

/// This method is called when splash zoomout is closed.
- (void)splashZoomOutViewDidClose:(BUSplashAd *)splashAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAdZoomOutViewDidClose:self];
    [self removeSplashAdView];
    [self.bridge splashAdDidClose:self];
}

- (void)splashZoomOutReadyToShow:(nonnull BUSplashAd *)splashAd {}

#pragma mark - BUSplashCardDelegate
- (void)splashCardViewDidClose:(BUSplashAd *)splashAd {
    WindmillLogDebug(@"CSJ", @"%@", NSStringFromSelector(_cmd));
    [self removeSplashAdView];
    [self.bridge splashAdDidClose:self];
}
- (void)splashCardReadyToShow:(nonnull BUSplashAd *)splashAd {}
- (void)splashCardViewDidClick:(nonnull BUSplashAd *)splashAd {}

- (void)dealloc {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
}
@end

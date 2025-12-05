//
//  NativeAdListener.m
//  Demo_OC
//
//  Created by Codi on 2025/11/11.
//

#import "NativeAdListener.h"
#import "AppUtil.h"
#import "NativeAdStyle.h"

@interface NativeAdListener()

@property(nonatomic, strong) NativeAdView *adView;

@end

@implementation NativeAdListener

- (instancetype)initWithNativeAdView:(NativeAdView *)adView
{
    self = [super init];
    if (self) {
        self.adView = adView;
    }
    return self;
}


- (void)nativeExpressAdViewRenderSuccess:(WindMillNativeAdView * _Nonnull)nativeAdView {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"nativeExpressAdViewRenderSuccess"];
    if (nativeAdView.nativeAd.feedADMode == WindMillFeedADModeNativeExpress) {
        [NativeAdStyle layout:nativeAdView.nativeAd adView:self.adView];
    }
    [self.adView.delegate nativeExpressAdViewRenderSuccess:self.adView];
}

- (void)nativeExpressAdViewRenderFail:(WindMillNativeAdView * _Nonnull)nativeExpressAdView error:(NSError * _Nonnull)error {
    DDLogDebug(@"%s", __func__);
    [self.adView.delegate nativeExpressAdView:self.adView renderFail:error];
}


- (void)nativeAdViewWillExpose:(WindMillNativeAdView * _Nonnull)nativeAdView {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"nativeAdViewWillExpose"];
}

- (void)nativeAdDetailViewClosed:(WindMillNativeAdView * _Nonnull)nativeAdView { 
    DDLogDebug(@"%s", __func__);
}

- (void)nativeAdDetailViewWillPresentScreen:(WindMillNativeAdView * _Nonnull)nativeAdView { 
    DDLogDebug(@"%s", __func__);
}

- (void)nativeAdView:(WindMillNativeAdView * _Nonnull)nativeAdView dislikeWithReason:(NSArray<WindMillDislikeWords *> * _Nonnull)filterWords { 
    DDLogDebug(@"%s", __func__);
}

- (void)nativeAdView:(WindMillNativeAdView * _Nonnull)nativeAdView playerStatusChanged:(enum WindMillMediaPlayerStatus)status userInfo:(NSDictionary<NSString *,id> * _Nonnull)userInfo { 
    DDLogDebug(@"%s", __func__);
}

- (void)nativeAdViewDidClick:(WindMillNativeAdView * _Nonnull)nativeAdView { 
    DDLogDebug(@"%s", __func__);
}



- (void)nativeShakeViewDismiss:(WindMillNativeAdShakeView * _Nonnull)shakeView { 
    DDLogDebug(@"%s", __func__);
}

@end

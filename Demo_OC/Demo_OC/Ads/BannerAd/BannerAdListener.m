//
//  BannerAdListener.m
//  Demo_OC
//
//  Created by Codi on 2025/11/10.
//

#import "BannerAdListener.h"
#import <Toast/Toast.h>
#import "AppUtil.h"

@implementation BannerAdListener

- (void)bannerAdViewLoadSuccess:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"bannerAdViewLoadSuccess"];
}

- (void)bannerAdViewFailedToLoad:(WindMillBannerView *)bannerAdView error:(NSError *)error {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"bannerAdViewFailedToLoad" error:error];
}

- (void)bannerAdViewWillExpose:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%s", __func__);
}

- (void)bannerAdViewDidClicked:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%s", __func__);
}

- (void)bannerAdViewDidRemoved:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%s", __func__);
    [bannerAdView removeFromSuperview];
}
- (void)bannerAdViewCloseFullScreen:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%s", __func__);
}
- (void)bannerAdViewWillOpenFullScreen:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%s", __func__);
}
- (void)bannerAdViewWillLeaveApplication:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%s", __func__);
}
- (void)bannerAdViewDidAutoRefresh:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"bannerAdViewDidAutoRefresh"];
}

- (void)bannerView:(WindMillBannerView *)bannerAdView failedToAutoRefreshWithError:(NSError *)error {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"failedToAutoRefreshWithError" error:error];
}
@end

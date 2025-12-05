//
//  IntersititialAdListener.m
//  Demo_OC
//
//  Created by Codi on 2025/11/10.
//

#import "IntersititialAdListener.h"
#import <Toast/Toast.h>
#import "AppUtil.h"

@implementation IntersititialAdListener

- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"intersititialAdDidLoad"];
}

- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"intersititialAdDidLoad:didFailWithError" error:error];
}

- (void)intersititialAdWillVisible:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%s", __func__);
}

- (void)intersititialAdDidVisible:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%s", __func__);
}

- (void)intersititialAdDidShowFailed:(WindMillIntersititialAd *)intersititialAd error:(NSError *)error {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"intersititialAdDidShowFailed" error:error];
}

- (void)intersititialAdDidClick:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%s", __func__);
}

- (void)intersititialAdDidClickSkip:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%s", __func__);
}

- (void)intersititialAdDidCloseOtherController:(WindMillIntersititialAd *)intersititialAd withInteractionType:(enum WindMillInteractionType)interactionType {
    DDLogDebug(@"%s", __func__);
}
- (void)intersititialAdDidClose:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%s", __func__);
}

- (void)intersititialAdDidPlayFinish:(WindMillIntersititialAd *)intersititialAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%s", __func__);
}

- (void)intersititialAdDidAutoLoad:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"intersititialAdDidAutoLoad"];
}
- (void)intersititialAd:(WindMillIntersititialAd *)intersititialAd didAutoLoadFailWithError:(NSError *)error {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"didAutoLoadFailWithError" error:error];
}
@end

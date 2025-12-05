//
//  SplashAdListener.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/11/7.
//

#import "SplashAdListener.h"
#import <Toast/Toast.h>
#import "AppUtil.h"

@implementation SplashAdListener
/// 广告加载成功回调
- (void)onSplashAdDidLoad:(WindMillSplashAd * _Nonnull)splashAd {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"onSplashAdDidLoad"];
}
/// 广告加载失败回调
- (void)onSplashAdLoadFail:(WindMillSplashAd * _Nonnull)splashAd error:(NSError * _Nonnull)error  {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"onSplashAdLoadFail" error:error];
}
/// 广告即将曝光回调
- (void)onSplashAdWillPresentScreen:(WindMillSplashAd * _Nonnull)splashAd {
    DDLogDebug(@"%s", __func__);
}
/// 广告曝光回调
- (void)onSplashAdSuccessPresentScreen:(WindMillSplashAd * _Nonnull)splashAd {
    DDLogDebug(@"%s", __func__);
}
/// 广告展示失败回调
- (void)onSplashAdFailToPresent:(WindMillSplashAd * _Nonnull)splashAd withError:(NSError * _Nonnull)error {
    DDLogDebug(@"%s", __func__);
}
/// 广告点击回调
- (void)onSplashAdClicked:(WindMillSplashAd * _Nonnull)splashAd {
    DDLogDebug(@"%s", __func__);
}
/// 广告跳过回调
- (void)onSplashAdSkiped:(WindMillSplashAd * _Nonnull)splashAd {
    DDLogDebug(@"%s", __func__);
}
/// 广告即将关闭回调
- (void)onSplashAdWillClosed:(WindMillSplashAd * _Nonnull)splashAd {
    DDLogDebug(@"%s", __func__);
}
/// 广告关闭回调
- (void)onSplashAdClosed:(WindMillSplashAd * _Nonnull)splashAd {
    DDLogDebug(@"%s", __func__);
}
/// This method is called when splash viewControllr is closed.
/// @Note :  当加载聚合维度广告时，支持该回调的adn有：CSJ
- (void)onSplashAdViewControllerDidClose:(WindMillSplashAd * _Nonnull)splashAd {
    DDLogDebug(@"%s", __func__);
}
/// 目前仅支持gromore csj gdt
/// *  广告即将展示广告详情页回调
- (void)onSplashAdWillPresentFullScreenModal:(WindMillSplashAd * _Nonnull)splashAd {
    DDLogDebug(@"%s", __func__);
}
/// 目前仅支持gromore csj
- (void)onSplashAdDidCloseOtherController:(WindMillSplashAd * _Nonnull)splashAd interactionType:(enum WindMillInteractionType)interactionType {
    DDLogDebug(@"%s", __func__);
}
/// 广告播放中加载成功回调
/// \param splashAd WindMillSplashAd 实例对象
///
- (void)onSplashAdAdDidAutoLoad:(WindMillSplashAd * _Nonnull)splashAd {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"onSplashAdAdDidAutoLoad"];
}
/// 广告播放中加载失败回调
/// \param splashAd WindMillSplashAd 实例对象
///
/// \param error 具体错误信息
///
- (void)onSplashAd:(WindMillSplashAd * _Nonnull)splashAd didAutoLoadFailWithError:(NSError * _Nonnull)error {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"onSplashAd:didAutoLoadFailWithError" error: error];
}
@end

//
//  AWMDrawAdConfigViewController.m
//  WindmillSample
//
//  Created by xiaoxiao2 on 2023/2/28.
//

#import "AWMDrawAdConfigViewController.h"
#import <WindMillSDK/WindMillSDK.h>
#import "WindHelper.h"
#import "DrawNativeAdViewController.h"
#import <UIView+Toast.h>

@interface AWMDrawAdConfigViewController ()<WindMillNativeAdViewDelegate,WindMillNativeAdsManagerDelegate>
@property (nonatomic, strong) WindMillNativeAdsManager *nativeAdsManager;
@property (nonatomic, strong) NSMutableArray<WindMillNativeAd *> *dataSource;

@end

@implementation AWMDrawAdConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray array];
    [self initializeForm];

}
- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    section = [self dropdownSection:[WindHelper getNativeDrawAdDropdownDatasource]];
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSection];
    section.title = @"广告示例";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"load广告"];
    row.action.formSelector = @selector(loadAd:);
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kshowAd" rowType:XLFormRowDescriptorTypeButton title:@"观看广告"];
    row.action.formSelector = @selector(showAd:);
    [section addFormRow:row];
    
    // Section
    section = [WindHelper getNativeCallbackRows];
    [form addFormSection:section];

    self.form = form;
}

- (void)loadAd:(XLFormRowDescriptor *)row {
    [self clearRowState:[WindHelper getNativeCallbackDatasources]];
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.userId = @"1234444";
    request.placementId = [self getSelectPlacementId];
    request.options = @{@"test_key":@"test_value"};
    self.nativeAdsManager = [[WindMillNativeAdsManager alloc] initWithRequest:request];
    self.nativeAdsManager.adSize = [UIScreen mainScreen].bounds.size;
    self.nativeAdsManager.delegate = self;
    [self.nativeAdsManager loadAdDataWithCount:1];
}

- (void)showAd:(XLFormRowDescriptor *)row {
    if(self.dataSource.count == 0){
        [self.view makeToast:@"当前没有广告数据，需要点击load请求" duration:1 position:CSToastPositionBottom];
        return;
    }
    DrawNativeAdViewController *vc = [[DrawNativeAdViewController alloc] init];
    vc.adList = [NSArray arrayWithArray:self.dataSource];
    vc.delegateVC = self;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    [self.dataSource removeAllObjects];
}

#pragma mark - WindMillNativeAdsManagerDelegate
- (void)nativeAdsManagerSuccessToLoad:(WindMillNativeAdsManager *)adsManager {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), adsManager.placementId);
    NSArray<WindMillNativeAd *> *nativeAdList = [adsManager getAllNativeAds];
    NSString *tips = [NSString stringWithFormat:@"加载成功[%@] -- %ld", adsManager.placementId, nativeAdList.count];
    [self.view makeToast:tips duration:1 position:CSToastPositionBottom];
    [self.dataSource addObjectsFromArray:nativeAdList];
    [self updateFromRowDisableWithTag:kAdDidLoad error:nil];
}

- (void)nativeAdsManager:(WindMillNativeAdsManager *)adsManager didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), adsManager.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoadError error:error];
}


#pragma mark - WindMillNativeAdViewDelegate
- (void)nativeExpressAdViewRenderSuccess:(WindMillNativeAdView *)nativeExpressAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidRenderSuccess error:nil];
}

- (void)nativeExpressAdViewRenderFail:(WindMillNativeAdView *)nativeExpressAdView error:(NSError *)error {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidRenderError error:error];
}

/**
 广告曝光回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdViewWillExpose:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdWillVisible error:nil];
    DDLogDebug(@"adInfo = %@", [nativeAdView.adInfo toJson]);
}


/**
 广告点击回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdViewDidClick:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClick error:nil];
}


/**
 广告详情页关闭回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdDetailViewClosed:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDetailViewClose error:nil];
}


/**
 广告详情页面即将展示回调
 
 @param nativeAdView WindMillNativeAdView 实例
 */
- (void)nativeAdDetailViewWillPresentScreen:(WindMillNativeAdView *)nativeAdView {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDetailViewVisible error:nil];
}


/**
 视频广告播放状态更改回调
 
 @param nativeAdView WindMillNativeAdView 实例
 @param status 视频广告播放状态
 @param userInfo 视频广告信息
 */
- (void)nativeAdView:(WindMillNativeAdView *)nativeAdView playerStatusChanged:(WindMillMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidPlayStateChange error:nil];
}


- (void)nativeAdView:(WindMillNativeAdView *)nativeAdView dislikeWithReason:(NSArray<WindMillDislikeWords *> *)filterWords {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDislike error:nil];
    //在这个回调中移除视图，否则，会出现用户点击叉无效的情况
    //TODO: draw广告需要调用这个吗，不是都是全屏的吗
}

@end

//
//  WindmillBannerAdViewController.m
//  WindmillSample
//
//  Created by Codi on 2022/5/12.
//

#import "WindmillBannerAdViewController.h"
#import <WindMillSDK/WindMillSDK.h>
#import <MJExtension/MJExtension.h>
#import "WindHelper.h"
#import "XLFormDropdownCell.h"
#import "XLFormInlineLabelCell.h"
#import "XLFormIconButtonCell.h"
#import <UIView+Toast.h>

static NSString *const kLoadAd = @"kLoadAd";
static NSString *const kPlayAd = @"kPlayAd";
static NSString *const KUseAnimate = @"KUseAnimate";

@interface WindmillBannerAdViewController ()<WindMillBannerViewDelegate>
@property (nonatomic, assign) BOOL useAnimate;
@property (nonatomic, strong) WindMillBannerView *bannerView;
@end

@implementation WindmillBannerAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"横幅广告";
    [self initializeForm];
}

- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"BannerAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //***************************************************************************
    section = [self dropdownSection:[WindHelper getBannerAdDropdownDatasource]];
    [form addFormSection:section];
    
    //***************************************************************************
    section = [XLFormSectionDescriptor formSectionWithTitle:@"控制项"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KUseAnimate rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"轮播动画"];
    row.value = @YES;
    RAC(self, useAnimate) = RACObserve(row, value);
    [section addFormRow:row];
    
    //***************************************************************************
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kLoadAd rowType:XLFormRowDescriptorTypeIconButton title:@"加载广告"];
    row.action.formSelector = @selector(didLoadAd:);
    [row.cellConfigAtConfigure setValue:@"demo_play" forKey:@"iconName"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPlayAd rowType:XLFormRowDescriptorTypeIconButton title:@"展示广告"];
    row.action.formSelector = @selector(didPlayAd:);
    [row.cellConfigAtConfigure setValue:@"demo_play" forKey:@"iconName"];
    [section addFormRow:row];
    
    //*******************************************************************
    section = [WindHelper getBannerCallbackRows];
    [form addFormSection:section];
    

    self.form = form;
}

- (void)didLoadAd:(XLFormRowDescriptor *)row {
    if (self.bannerView.superview) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
    [self clearRowState:[WindHelper getBannerCallbackDatasources]];
    NSString *placementId = [self getSelectPlacementId];
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = placementId;
    request.userId = @"Your User Id";
    self.bannerView = [[WindMillBannerView alloc] initWithRequest:request];
    self.bannerView.backgroundColor = UIColor.yellowColor;
    self.bannerView.delegate = self;
    self.bannerView.viewController = self;
    self.bannerView.animated = self.useAnimate;
    [self.bannerView loadAdData];
}

- (void)didPlayAd:(XLFormRowDescriptor *)row {
    if (!self.bannerView.isAdValid) {
        //广告过期后建议重新load一条广告
        [self.view makeToast:@"广告加载失败或已过期，可能是无效展示" duration:2 position:CSToastPositionCenter];
        return;
    }
    [self.view addSubview:self.bannerView];
}

#pragma mark - WindMillBannerViewDelegate
//bannerView自动刷新
- (void)bannerAdViewDidAutoRefresh:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), bannerAdView.placementId);
    //自动刷新成功，需要重新设置bannerView的frame(这里刷新后可能展示的广告和之前不是同一个渠道，广告的size也不相同)
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAutoRefreshSuccess error:nil];
    CGSize adSize = bannerAdView.adSize;
    CGFloat space = (UIScreen.mainScreen.bounds.size.width - adSize.width)/2.0;
//    bannerAdView.frame = CGRectMake(space, 0, adSize.width, adSize.height);
    bannerAdView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, adSize.height);
}
//bannerView自动刷新失败
- (void)bannerView:(WindMillBannerView *)bannerAdView failedToAutoRefreshWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), bannerAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAutoRefreshFailed error:error];
}
//成功加载广告
- (void)bannerAdViewLoadSuccess:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), bannerAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoad error:nil];
    CGSize adSize = bannerAdView.adSize;
    CGFloat space = (UIScreen.mainScreen.bounds.size.width - adSize.width)/2.0;
    bannerAdView.frame = CGRectMake(space, 0, adSize.width, adSize.height);
}
//广告加载失败
- (void)bannerAdViewFailedToLoad:(WindMillBannerView *)bannerAdView error:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), bannerAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoadError error:error];
}
//广告将要展示
- (void)bannerAdViewWillExpose:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), bannerAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidVisible error:nil];
}
//广告被点击
- (void)bannerAdViewDidClicked:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), bannerAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClick error:nil];
}
//当用户由于点击要离开您的应用程序时触发该回调,您的应用程序将移至后台
- (void)bannerAdViewWillLeaveApplication:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), bannerAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kWillLeaveApplication error:nil];
}
//将打开全屏视图。在打开storekit或在应用程序中打开网页时触发
- (void)bannerAdViewWillOpenFullScreen:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), bannerAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDetailViewVisible error:nil];
}
//将关闭全屏视图。关闭storekit或关闭应用程序中的网页时发送
- (void)bannerAdViewCloseFullScreen:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), bannerAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDetailViewClose error:nil];
}
//广告视图被移除
- (void)bannerAdViewDidRemoved:(WindMillBannerView *)bannerAdView {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), bannerAdView.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClose error:nil];
    [self.bannerView removeFromSuperview];
    self.bannerView.delegate = nil;
    self.bannerView = nil;
}

@end

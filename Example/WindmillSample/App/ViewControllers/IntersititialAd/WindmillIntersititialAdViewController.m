//
//  WindmillIntersititialAdViewController.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "WindmillIntersititialAdViewController.h"
#import <WindMillSDK/WindMillSDK.h>
#import <UIView+Toast.h>
#import "WindHelper.h"
#import "XLFormDropdownCell.h"
#import "XLFormInlineLabelCell.h"

@interface WindmillIntersititialAdViewController ()<WindMillIntersititialAdDelegate>
@property (nonatomic, strong) WindMillIntersititialAd *intersititialAd;
@end

@implementation WindmillIntersititialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"插屏广告";
    [self initializeForm];
}

- (void)loadAd:(XLFormRowDescriptor *)row {
    [self clearRowState:[WindHelper getIntersititialCallbackDatasources]];
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.userId = @"your user id";
    request.placementId = [self getSelectPlacementId];
    request.options = @{@"test_key":@"test_value"};
    self.intersititialAd = [[WindMillIntersititialAd alloc] initWithRequest:request];
    self.intersititialAd.delegate = self;
    [self.intersititialAd loadAdData];
}
- (void)showAd:(XLFormRowDescriptor *)row {
    if (!self.intersititialAd.isAdReady) {
        [self.view makeToast:@"not ready!" duration:1 position:CSToastPositionBottom];
        return;
    }
    //当多场景使用同一个广告位是，可以通过WindMillAdSceneId来区分某个场景的广告播放数据
    //不需要统计可以设置为options=nil
    [self.intersititialAd showAdFromRootViewController:self options:@{
        WindMillAdSceneDesc: @"测试场景",
        WindMillAdSceneId: @"1"
    }];
}


- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //********************************************************************************
    section = [self dropdownSection:[WindHelper getIntersititialAdDropdownDatasource]];
    [form addFormSection:section];
    
    //*****************************************************
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
    section = [WindHelper getIntersititalCallbackRows];
    [form addFormSection:section];

    self.form = form;
}
#pragma mark - WindMillIntersititialAdDelegate
- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoad error:nil];
}

- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidLoadError error:error];
}

- (void)intersititialAdWillVisible:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdWillVisible error:nil];
}

- (void)intersititialAdDidVisible:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidVisible error:nil];
}

- (void)intersititialAdDidClick:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClick error:nil];
}

- (void)intersititialAdDidClickSkip:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidSkip error:nil];
}

- (void)intersititialAdDidClose:(WindMillIntersititialAd *)intersititialAd {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidClose error:nil];
}

- (void)intersititialAdDidPlayFinish:(WindMillIntersititialAd *)intersititialAd didFailWithError:(NSError *)error {
    DDLogDebug(@"%@ -- %@", NSStringFromSelector(_cmd), intersititialAd.placementId);
    [self.view.window makeToast:NSStringFromSelector(_cmd) duration:1 position:CSToastPositionBottom];
    [self updateFromRowDisableWithTag:kAdDidPlayFinish error:error];
}

@end

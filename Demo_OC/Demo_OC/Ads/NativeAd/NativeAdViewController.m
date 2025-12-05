//
//  NativeAdViewController.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "NativeAdViewController.h"
#import "NativeAdViewModel.h"
#import "DataUtil.h"
#import <MJExtension/MJExtension.h>
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>


@interface NativeAdViewController ()
@property(nonatomic, strong) NativeAdViewModel *viewModel;
@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[NativeAdViewModel alloc] init];
    self.viewModel.viewController = self;
    [self initializeForm];
}


- (void)initializeForm {
    SlotInfo *slotInfo = [DataUtil getChannelItems];
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //*****************************
    
    section = [self dropdownSection:[DataUtil getDropdownDatasource:slotInfo.native_ad]];
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSection];
    section.title = @"广告加载";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"loadAd"];
    row.action.formBlock = ^(XLFormRowDescriptor * _Nonnull sender) {
        [self.viewModel loadAd:[self getSelectPlacementId]];
    };
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSection];
    section.title = @"广告播放";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kshowAd" rowType:XLFormRowDescriptorTypeButton title:@"展示广告-简单接入"];
    row.action.formBlock = ^(XLFormRowDescriptor * _Nonnull sender) {
        [self.viewModel showAd:[self getSelectPlacementId]];
    };
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kshowAdList" rowType:XLFormRowDescriptorTypeButton title:@"展示广告-列表页接入"];
    row.action.formBlock = ^(XLFormRowDescriptor * _Nonnull sender) {
        [self.viewModel showTableListPage:[self getSelectPlacementId]];
    };
    [section addFormRow:row];
    
    self.form = form;
}



@end

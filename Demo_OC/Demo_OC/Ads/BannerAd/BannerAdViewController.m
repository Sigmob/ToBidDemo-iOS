//
//  BannerAdViewController.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "BannerAdViewController.h"
#import "DataUtil.h"
#import "BannerAdViewModel.h"

@interface BannerAdViewController ()
@property(nonatomic, strong) BannerAdViewModel *viewModel;
@end

@implementation BannerAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[BannerAdViewModel alloc] init];
    self.viewModel.viewController = self;
    [self initializeForm];
}


- (void)initializeForm {
    SlotInfo *slotInfo = [DataUtil getChannelItems];
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //*****************************
    
    section = [self dropdownSection:[DataUtil getDropdownDatasource:slotInfo.banner_ad]];
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"KUseAnimate" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"轮播动画"];
    row.selectorOptions = @[@"开启", @"关闭"];
    row.value = @"关闭";
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    section.title = @"广告示例";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"loadAd"];
    row.action.formBlock = ^(XLFormRowDescriptor * _Nonnull sender) {
        [self.viewModel loadAd:[self getSelectPlacementId]];
    };
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kshowAd" rowType:XLFormRowDescriptorTypeButton title:@"showAd"];
    row.action.formBlock = ^(XLFormRowDescriptor * _Nonnull sender) {
        [self.viewModel showAd:[self getSelectPlacementId]];
    };
    [section addFormRow:row];
    
    self.form = form;
}



@end

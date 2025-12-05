//
//  SplashAdViewController.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "SplashAdViewController.h"
#import "DataUtil.h"
#import "SplashAdViewModel.h"

@interface SplashAdViewController ()
@property(nonatomic, strong) SplashAdViewModel *viewModel;
@end

@implementation SplashAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[SplashAdViewModel alloc] init];
    self.viewModel.viewController = self;
    [self initializeForm];
}


- (void)initializeForm {
    SlotInfo *slotInfo = [DataUtil getChannelItems];
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //*****************************
    
    section = [self dropdownSection:[DataUtil getDropdownDatasource:slotInfo.splash_ad]];
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"klogo" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"是否展示品牌区域"];
    row.selectorOptions = @[@"展示", @"不展示"];
    row.value = @"展示";
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    section.title = @"加载自动展示模式";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAdAndShow" rowType:XLFormRowDescriptorTypeButton title:@"loadAdAndShow"];
    row.action.formBlock = ^(XLFormRowDescriptor * _Nonnull sender) {
        [self.viewModel loadAd:[self getSelectPlacementId]];
    };
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSection];
    section.title = @"预加载模式";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kloadAd" rowType:XLFormRowDescriptorTypeButton title:@"loadAdData"];
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

//
//  RewardVideoAdViewController.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "RewardVideoAdViewController.h"
#import "DataUtil.h"
#import "RewardVideoAdViewModel.h"

@interface RewardVideoAdViewController ()
@property(nonatomic, strong) RewardVideoAdViewModel *viewModel;
@end

@implementation RewardVideoAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[RewardVideoAdViewModel alloc] init];
    self.viewModel.viewController = self;
    [self initializeForm];
}

- (void)initializeForm {
    SlotInfo *slotInfo = [DataUtil getChannelItems];
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"RewardVideoAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //*****************************
    
    section = [self dropdownSection:[DataUtil getDropdownDatasource:slotInfo.reward_ad]];
    [form addFormSection:section];
    
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

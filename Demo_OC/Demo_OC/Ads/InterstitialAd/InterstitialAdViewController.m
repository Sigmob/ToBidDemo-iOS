//
//  InterstitialAdViewController.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "InterstitialAdViewController.h"
#import "DataUtil.h"
#import "InterstitialAdViewModel.h"

@interface InterstitialAdViewController ()
@property(nonatomic, strong) InterstitialAdViewModel *viewModel;
@end

@implementation InterstitialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[InterstitialAdViewModel alloc] init];
    self.viewModel.viewController = self;
    [self initializeForm];
}

- (void)initializeForm {
    SlotInfo *slotInfo = [DataUtil getChannelItems];
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"InterstitialAd"];;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //*****************************
    
    section = [self dropdownSection:[DataUtil getDropdownDatasource:slotInfo.intersititial_ad]];
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

//
//  AWMNativeListViewController.m
//  WindmillSample
//
//  Created by xiaoxiao2 on 2023/2/28.
//

#import "AWMNativeListViewController.h"
#import "XLFormRowLeftIconAndTitleCell.h"

@interface AWMNativeListViewController ()
@end

@implementation AWMNativeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"原生广告";
    [self initializeForm];
}

- (void)initializeForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptorWithTitle:@"NativePage"];

    //*****************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Native-Ad" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"原生信息流广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_normal"] forKey:@"image"];
    row.action.viewControllerClass = NSClassFromString(@"WindmillNativeAdViewController");
    [section addFormRow:row];
    
    //*****************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Native-DrawAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"Draw视频信息流广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_normal"] forKey:@"image"];
    row.action.viewControllerClass = NSClassFromString(@"AWMDrawAdConfigViewController");
    [section addFormRow:row];
    
    self.form = form;
}
@end

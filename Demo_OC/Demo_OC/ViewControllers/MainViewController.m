//
//  ViewController.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/23.
//

#import "MainViewController.h"
#import "XLFormRowLeftIconAndTitleCell.h"
#import <WindMillSDK/WindMillSDK.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"ToBid iOS Demo";
    [self initializeForm];
}

- (void)initializeForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptorWithTitle:@"HomePage"];

    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"SplashAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"开屏广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_normal"] forKey:@"image"];
    row.action.viewControllerClass = NSClassFromString(@"SplashAdViewController");
    [section addFormRow:row];
    
    //************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"BannerAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"横幅广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_normal"] forKey:@"image"];
    row.action.viewControllerClass = NSClassFromString(@"BannerAdViewController");
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"RewardVideoAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"激励视频"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_play"] forKey:@"image"];
    row.action.viewControllerClass = NSClassFromString(@"RewardVideoAdViewController");
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"InterstitialAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"插屏广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_play"] forKey:@"image"];
    row.action.viewControllerClass = NSClassFromString(@"InterstitialAdViewController");
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"NativeAd" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"原生广告"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_normal"] forKey:@"image"];
    row.action.viewControllerClass = NSClassFromString(@"NativeAdViewController");
    [section addFormRow:row];
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Channels" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"渠道版本"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_setting"] forKey:@"image"];
    row.action.viewControllerClass = NSClassFromString(@"WindmillChannelVersionViewController");
    [section addFormRow:row];
    
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Tools" rowType:XLFormRowDescriptorTypeLeftIconAndTitle title:@"工具"];
    row.required = YES;
    [row.cellConfigAtConfigure setValue:[UIImage imageNamed:@"demo_setting"] forKey:@"image"];
    row.action.viewControllerClass = NSClassFromString(@"WindmillToolViewController");
    [section addFormRow:row];
    
    
    //********************************************************************************
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"info" rowType:XLFormRowDescriptorTypeInfo title:@"Version"];
    row.value = [WindMillAds sdkVersion];
    [section addFormRow:row];
    
    self.form = form;
}
@end

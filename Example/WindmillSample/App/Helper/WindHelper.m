//
//  WindHelper.m
//  WindmillSample
//
//  Created by Codi on 2021/12/7.
//

#import "WindHelper.h"
#import <MJExtension/MJExtension.h>
#import <XLForm/XLForm.h>
#import "WindmillDropdownListView.h"
#import "XLFormInlineLabelCell.h"

static NSString * const Reward_Video_Ad = @"reward_ad";
static NSString * const Intersititial_fullscreen_Ad = @"intersititial_fullscreen_ad";
static NSString * const Intersititial_Ad = @"intersititial_ad";
static NSString * const Splash_Ad = @"splash_ad";
static NSString * const Banner_Ad = @"banner_ad";
static NSString * const Native_Ad = @"native_ad";
static NSString * const Native_Draw_Ad = @"native_draw_ad";

@implementation WindHelper


+ (NSArray *)getBannerCallbackDatasources {
    return @[
        @{@"tag":kAutoRefreshSuccess, @"title":@"bannerAdViewDidAutoRefresh:"},
        @{@"tag":kAutoRefreshFailed, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"bannerView:failedToAutoRefreshWithError:"},
        @{@"tag":kAdDidLoad, @"title":@"bannerAdViewLoadSuccess:"},
        @{@"tag":kAdDidLoadError, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"bannerAdViewFailedToLoad:error:"},
        @{@"tag":kAdDidVisible, @"title":@"bannerAdViewWillExpose:"},
        @{@"tag":kAdDidClick, @"title":@"bannerAdViewDidClicked:"},
        @{@"tag":kWillLeaveApplication, @"title":@"bannerAdViewWillLeaveApplication:"},
        @{@"tag":kAdDetailViewVisible, @"title":@"bannerAdViewWillOpenFullScreen:"},
        @{@"tag":kAdDetailViewClose, @"title":@"bannerAdViewCloseFullScreen:"},
        @{@"tag":kAdDidClose, @"title":@"bannerAdViewDidRemoved:"}
    ];
}

+ (NSArray *)getSplashCallbackDatasources {
    return @[
        @{@"tag":kAdDidLoad, @"title":@"onSplashAdDidLoad:"},
        @{@"tag":kAdDidLoadError, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"onSplashAdLoadFail:error:"},
        @{@"tag":kAdDidVisible, @"title":@"onSplashAdSuccessPresentScreen:"},
        @{@"tag":kAdDidRenderError, @"title":@"onSplashAdFailToPresent:withError:"},
        @{@"tag":kAdDidClick, @"title":@"onSplashAdClicked:"},
        @{@"tag":kAdDidSkip, @"title":@"onSplashAdSkiped:"},
        @{@"tag":kAdWillClose, @"title":@"onSplashAdWillClosed:"},
        @{@"tag":kAdDidClose, @"title":@"onSplashAdClosed:"},
        @{@"tag":kZoomOutViewDidClick, @"title":@"onSplashZoomOutViewAdDidClick:"},
        @{@"tag":kZoomOutViewDidClose, @"title":@"onSplashZoomOutViewAdDidClose:"},
    ];
}

+ (NSArray *)getIntersititialCallbackDatasources {
    return @[
        @{@"tag":kAdDidLoad, @"title":@"intersititialAdDidLoad:"},
        @{@"tag":kAdDidLoadError, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"intersititialAdDidLoad:didFailWithError:"},
        @{@"tag":kAdDidVisible, @"title":@"intersititialAdDidVisible:"},
        @{@"tag":kAdDidClick, @"title":@"intersititialAdDidClick:"},
        @{@"tag":kAdDidSkip, @"title":@"intersititialAdDidClickSkip:"},
        @{@"tag":kAdDidPlayFinish, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"intersititialAdDidPlayFinish:didFailWithError:"},
        @{@"tag":kAdDidClose, @"title":@"intersititialAdDidClose:"},
    ];
}

+ (NSArray *)getRewardVideoCallbackDatasources {
    return @[
        @{@"tag":kAdDidLoad, @"title":@"rewardVideoAdDidLoad:"},
        @{@"tag":kAdDidLoadError, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"rewardVideoAdDidLoad:didFailWithError:"},
        @{@"tag":kAdDidVisible, @"title":@"rewardVideoAdDidVisible:"},
        @{@"tag":kAdDidClick, @"title":@"rewardVideoAdDidClick:"},
        @{@"tag":kAdDidSkip, @"title":@"rewardVideoAdDidClickSkip:"},
        @{@"tag":kAdDidReward, @"title":@"rewardVideoAd:reward:"},
        @{@"tag":kAdDidPlayFinish, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"rewardVideoAdDidPlayFinish:didFailWithError:"},
        @{@"tag":kAdDidClose, @"title":@"rewardVideoAdDidClose:"},
    ];
}

+ (NSArray *)getNativeCallbackDatasources {
    return @[
        @{@"tag":kAdDidLoad, @"title":@"nativeAdsManagerSuccessToLoad:"},
        @{@"tag":kAdDidLoadError, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"nativeAdsManager:didFailWithError:"},
        @{@"tag":kAdDidRenderSuccess, @"title":@"nativeExpressAdViewRenderSuccess:"},
        @{@"tag":kAdDidRenderError, @"title":@"nativeExpressAdViewRenderFail:error:"},
        @{@"tag":kAdWillVisible, @"title":@"nativeAdViewWillExpose:"},
        @{@"tag":kAdDidClick, @"title":@"nativeAdViewDidClick:"},
        @{@"tag":kAdDetailViewVisible, @"title":@"nativeAdDetailViewWillPresentScreen:"},
        @{@"tag":kAdDetailViewClose, @"title":@"nativeAdDetailViewClosed:"},
        @{@"tag":kAdDidPlayStateChange, @"rowType": XLFormRowDescriptorTypeLabelInline, @"title":@"nativeAdView:playerStatusChanged:userInfo:"},
        @{@"tag":kAdDislike, @"title":@"nativeAdView:dislikeWithReason:"},
    ];
}

/////////////////////////////////////////////////////////////////////////////////

+ (XLFormSectionDescriptor *)getSplashCallbackRows {
    return [self getCallbackRows:[self getSplashCallbackDatasources]];
}
+ (XLFormSectionDescriptor *)getBannerCallbackRows {
    return [self getCallbackRows:[self getBannerCallbackDatasources]];
}
+ (XLFormSectionDescriptor *)getIntersititalCallbackRows {
    return [self getCallbackRows:[self getIntersititialCallbackDatasources]];
}
+ (XLFormSectionDescriptor *)getRewardVideoCallbackRows {
    return [self getCallbackRows:[self getRewardVideoCallbackDatasources]];
}
+ (XLFormSectionDescriptor *)getNativeCallbackRows {
    return [self getCallbackRows:[self getNativeCallbackDatasources]];
}


/////////////////////////////////////////////////////////////////////////////////
+ (XLFormSectionDescriptor *)getCallbackRows:(NSArray *)datasource {
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:@"Dropdown"];
    section.title = @"广告回调信息";
    for (NSDictionary *item in datasource) {
        NSString *rowType = [item objectForKey:@"rowType"];
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:item[@"tag"] rowType:rowType?rowType:XLFormRowDescriptorTypeInfo];
        row.title = [item objectForKey:@"title"];
        row.disabled = @YES;
        [section addFormRow:row];
    }
    return section;
}



/////////////////////////////////////////////////////////////////////////////////
+ (NSArray *)getRewardAdDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Reward_Video_Ad];
}

+ (NSArray *)getIntersititialAdDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Intersititial_Ad];
}

+ (NSArray *)getSplashAdDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Splash_Ad];
}
+ (NSArray *)getBannerAdDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Banner_Ad];
}

+ (NSArray *)getNativeAdDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Native_Ad];
}

+ (NSArray *)getNativeDrawAdDropdownDatasource {
    return [self getDropdownDatasourceWithKey:Native_Draw_Ad];
}


/////////////////////////////////////////////////////////////////////////////////

+ (NSDictionary *)getChannelItems {
    static NSDictionary *item;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *channelPath = [[NSBundle mainBundle] pathForResource:@"channel" ofType:@"json"];
        NSString *channelStr = [NSString stringWithContentsOfFile:channelPath encoding:NSUTF8StringEncoding error:nil];
        item = [channelStr mj_JSONObject];
    });
    return item;
}

+ (NSArray<ChannelItem *> *)getDropdownItemWithKey:(NSString *)key {
    NSDictionary *dict = [self getChannelItems];
    NSDictionary *item = [dict objectForKey:key];
    return [ChannelItem mj_objectArrayWithKeyValuesArray:item];
}

+ (NSArray *)getDropdownDatasourceWithKey:(NSString *)key {
    NSArray *arr = [WindHelper getDropdownItemWithKey:key];
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:arr.count];
    for (ChannelItem *channel in arr) {
        DropdownListItem *item = [[DropdownListItem alloc] initWithItem:channel.placementId itemName:channel.name];
        [dataSource addObject:item];
    }
    return dataSource;
}

@end

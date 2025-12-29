//
//  WindHelper.h
//  WindmillSample
//
//  Created by Codi on 2021/12/7.
//

#import <Foundation/Foundation.h>
#import "ChannelItem.h"

@class XLFormSectionDescriptor;

static NSString * const kAdDidLoad = @"kAdDidLoad";
static NSString * const kAdDidLoadError = @"kAdDidLoadError";
static NSString * const kAdWillVisible = @"kAdWillVisible";
static NSString * const kAdDidVisible = @"kAdDidVisible";
static NSString * const kAdDetailViewVisible = @"kAdDetailViewVisible";
static NSString * const kAdDetailViewClose = @"kAdDetailViewClose";
static NSString * const kAdDidRenderSuccess = @"kAdDidRenderSuccess";
static NSString * const kAdDidRenderError = @"kAdDidRenderError";
static NSString * const kAdDislike = @"kAdDislike";
static NSString * const kAdDidClick = @"kAdDidClick";
static NSString * const kAdDidSkip = @"kAdDidSkip";
static NSString * const kAdDidReward = @"kAdDidReward";
static NSString * const kAdWillClose = @"kAdWillClose";
static NSString * const kAdDidClose = @"kAdDidClose";
static NSString * const kAdServerResponse = @"AdServerResponse";
static NSString * const kAdDidPlayFinish = @"kAdDidPlayFinish";
static NSString * const kAdDidPlayStateChange = @"kAdDidPlayStateChange";
static NSString * const kZoomOutViewDidClick = @"kZoomOutViewDidClick";
static NSString * const kZoomOutViewDidClose = @"kZoomOutViewDidClose";
static NSString * const kAutoRefreshSuccess = @"kAutoRefreshSuccess";
static NSString * const kAutoRefreshFailed = @"kAutoRefreshFailed";
static NSString * const kWillLeaveApplication = @"kWillLeaveApplication";

@interface WindHelper : NSObject

+ (NSArray *)getRewardAdDropdownDatasource;
+ (NSArray *)getIntersititialAdDropdownDatasource;
+ (NSArray *)getSplashAdDropdownDatasource;
+ (NSArray *)getBannerAdDropdownDatasource;
+ (NSArray *)getNativeAdDropdownDatasource;
+ (NSArray *)getNativeDrawAdDropdownDatasource;
//////////////////////////////////////////////////////////
+ (NSArray *)getBannerCallbackDatasources;
+ (NSArray *)getSplashCallbackDatasources;
+ (NSArray *)getIntersititialCallbackDatasources;
+ (NSArray *)getRewardVideoCallbackDatasources;
+ (NSArray *)getNativeCallbackDatasources;
//////////////////////////////////////////////////////////
+ (XLFormSectionDescriptor *)getBannerCallbackRows;
+ (XLFormSectionDescriptor *)getSplashCallbackRows;
+ (XLFormSectionDescriptor *)getIntersititalCallbackRows;
+ (XLFormSectionDescriptor *)getRewardVideoCallbackRows;
+ (XLFormSectionDescriptor *)getNativeCallbackRows;




@end

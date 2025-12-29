//
//  XXCSJNativeAdData.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/20.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "XXCSJNativeAdData.h"
#import <BUAdSDK/BUAdSDK.h>
#import <WindFoundation/WindFoundation.h>

@interface XXCSJNativeAdData ()
@property (nonatomic, weak) BUNativeAd *ad;
@end

@implementation XXCSJNativeAdData

@synthesize adMode = _adMode;
@synthesize callToAction = _callToAction;
@synthesize desc = _desc;
@synthesize iconUrl = _iconUrl;
@synthesize rating = _rating;
@synthesize title = _title;

- (instancetype)initWithAd:(BUNativeAd *)ad {
    self = [super init];
    if (self) {
        _ad = ad;
    }
    return self;
}
- (NSString *)title {
    return self.ad.data.AdTitle;
}
- (NSString *)desc {
    return self.ad.data.AdDescription;
}
- (NSString *)iconUrl {
    return self.ad.data.icon.imageURL;
}
- (NSString *)callToAction {
    if (!_callToAction) {
        BUInteractionType interactionType = self.ad.data.interactionType;
        _callToAction = interactionType == BUInteractionTypeDownload ? @"立即下载":@"查看详情";
    }
    return _callToAction;
}
- (double)rating {
    return self.ad.data.score;
}
- (AWMMediatedNativeAdMode)adMode {
    if (_adMode > 0) return _adMode;
    BUFeedADMode adMode = self.ad.data.imageMode;
    if (adMode == BUFeedADModeSmallImage) {
        _adMode = AWMMediatedNativeAdModeSmallImage;
    }else if (adMode == BUFeedADModeLargeImage) {
        _adMode = AWMMediatedNativeAdModeLargeImage;
    }else if (adMode == BUFeedADModeGroupImage) {
        _adMode = AWMMediatedNativeAdModeGroupImage;
    }else if (adMode == BUFeedVideoAdModeImage) {
        _adMode = AWMMediatedNativeAdModeVideo;
    }else if (adMode == BUFeedVideoAdModePortrait) {
        _adMode = AWMMediatedNativeAdModeVideoPortrait;
    }else if (adMode == BUFeedADModeUnionSplashVideo) {
        _adMode = AWMMediatedNativeAdModeVideo;
    }else if (adMode == BUFeedADModeUnionVerticalImage) {
        _adMode = AWMMediatedNativeAdModeLargeImage;
    }else if (adMode == BUFeedADModeImagePortrait) {
        _adMode = AWMMediatedNativeAdModeLargeImage;
    }
    return _adMode;
}
- (void)dealloc {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
}
@end

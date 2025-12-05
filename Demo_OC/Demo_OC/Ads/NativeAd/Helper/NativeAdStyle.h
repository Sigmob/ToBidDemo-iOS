//
//  NativeAdStyle.h
//  Demo_OC
//
//  Created by Codi on 2025/11/11.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>
#import "NativeAdView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NativeAdStyle : NSObject
+ (void)layout:(WindMillNativeAd *)nativeAd adView:(NativeAdView *)adView;
@end

NS_ASSUME_NONNULL_END

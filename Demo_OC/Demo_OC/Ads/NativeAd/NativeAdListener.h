//
//  NativeAdListener.h
//  Demo_OC
//
//  Created by Codi on 2025/11/11.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>
#import "NativeAdView.h"

@interface NativeAdListener : NSObject<WindMillNativeAdViewDelegate, WindMillNativeAdShakeViewDelegate>

- (instancetype)initWithNativeAdView:(NativeAdView *)adView;

@end


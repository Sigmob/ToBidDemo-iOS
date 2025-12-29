//
//  XXCSJNativeAdViewCreator.h
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/20.
//  Copyright © 2022 Codi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>

@class BUNativeAd;
@class BUNativeAdRelatedView;
@class BUNativeExpressAdView;

@interface XXCSJNativeAdViewCreator : NSObject<AWMMediatedNativeAdViewCreator>

- (instancetype)initWithNativeAd:(BUNativeAd *)nativeAd
                          adView:(BUNativeAdRelatedView *)adView;

- (instancetype)initWithExpressAdView:(BUNativeExpressAdView *)adView;



@end

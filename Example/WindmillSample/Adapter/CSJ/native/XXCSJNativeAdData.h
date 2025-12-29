//
//  XXCSJNativeAdData.h
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/20.
//  Copyright © 2022 Codi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>

@class BUNativeAd;

@interface XXCSJNativeAdData : NSObject<AWMMediatedNativeAdData>

- (instancetype)initWithAd:(BUNativeAd *)ad;

@end

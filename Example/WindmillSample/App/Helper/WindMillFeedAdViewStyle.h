//
//  FeedAdViewStyle.h
//  WindDemo
//
//  Created by Codi on 2021/8/23.
//

#import <Foundation/Foundation.h>

@class WindMillNativeAd;
@class NativeAdCustomView;


@interface WindMillFeedAdViewStyle : NSObject

+ (void)layoutWithModel:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView;

+ (CGFloat)cellHeightWithModel:(WindMillNativeAd *)model width:(CGFloat)width;

@end

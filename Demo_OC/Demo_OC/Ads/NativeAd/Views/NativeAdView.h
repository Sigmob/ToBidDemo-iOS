//
//  NativeAdView.h
//  Demo_OC
//
//  Created by Codi on 2025/11/11.
//

#import <UIKit/UIKit.h>
#import <WindMillSDK/WindMillSDK.h>

@class  NativeAdView;

@protocol NativeAdViewListener <NSObject>

- (void)nativeExpressAdViewRenderSuccess:(NativeAdView *)adView;

- (void)nativeExpressAdView:(NativeAdView *)adView renderFail:(NSError *)error;

@end

@interface NativeAdView : UIView

@property(nonatomic, weak) id<NativeAdViewListener> delegate;

@property(nonatomic, strong) WindMillNativeAdView *nativeAdView;
@property(nonatomic, strong) WindMillNativeAd *nativeAd;
/// 标题
@property(nonatomic, strong) UILabel *titleLabel;
/// 描述
@property(nonatomic, strong) UILabel *descLabel;
/// icon
@property(nonatomic, strong) UIImageView *iconImageView;
/// CTA按钮
@property(nonatomic, strong) UIButton *ctaButton;

- (instancetype)initWithNativeAd:(WindMillNativeAd *)nativeAd;

- (void)refresh:(WindMillNativeAd *)nativeAd viewController:(UIViewController *)viewController;



@end

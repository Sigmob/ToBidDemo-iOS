//
//  NativeAdStyle.m
//  Demo_OC
//
//  Created by Codi on 2025/11/11.
//
 
#import "NativeAdStyle.h"
#import <WindMillSDK/WindMillSDK.h>
#import <Masonry/Masonry.h>

@implementation NativeAdStyle
+ (void)layout:(WindMillNativeAd *)nativeAd adView:(NativeAdView *)adView {
    // 模板渲染
    if (nativeAd.feedADMode == WindMillFeedADModeNativeExpress) {
        [self renderExpress:nativeAd adView:adView];
    }else if (nativeAd.feedADMode == WindMillFeedADModeVideo || nativeAd.feedADMode == WindMillFeedADModeVideoPortrait || nativeAd.feedADMode == WindMillFeedADModeVideoLandSpace) {
        [self renderVideo:nativeAd adView:adView];
    }else if (nativeAd.feedADMode == WindMillFeedADModeLargeImage) {
        [self renderLargeImage:nativeAd adView:adView];
    }else if (nativeAd.feedADMode == WindMillFeedADModeGroupImage) {
        [self renderGroupImage:nativeAd adView:adView];
    }else {
        DDLogDebug(@"无法识别feedADMode =%d", nativeAd.feedADMode);
    }
}

+ (void)renderExpress:(WindMillNativeAd *)nativeAd adView:(NativeAdView *)adView {
    CGSize size = adView.nativeAdView.frame.size;
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(adView.superview);
        make.size.mas_equalTo(size);
    }];
}
+ (void)renderLargeImage:(WindMillNativeAd *)nativeAd adView:(NativeAdView *)adView {
    [self renderCommon:nativeAd adView:adView];
    UIImageView *mainImageView = adView.nativeAdView.mainImageView;
    if (mainImageView == nil) {
        return;
    }
    [mainImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(adView.iconImageView.mas_left);
        make.top.mas_equalTo(adView.iconImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(adView).offset(-10);
        make.height.mas_equalTo(adView.nativeAdView.mas_height).multipliedBy(0.5625);
    }];
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(adView.superview);
        make.left.mas_equalTo(adView.superview).offset(10);
        make.right.mas_equalTo(adView.superview).offset(-10);
    }];
}
+ (void)renderGroupImage:(WindMillNativeAd *)nativeAd adView:(NativeAdView *)adView {
    if (adView.nativeAdView.imageViewList.count == 0) {
        return;
    }
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.tag = 1009;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 10;
    stackView.distribution = UIStackViewDistributionFillEqually;
    [adView addSubview:stackView];
    [adView.nativeAdView.imageViewList enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [stackView addArrangedSubview:obj];
    }];
    [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(adView.iconImageView.mas_left);
        make.top.mas_equalTo(adView.iconImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(adView).offset(-10);
        make.height.mas_equalTo(adView.nativeAdView.mas_width).multipliedBy(0.3);
    }];
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(adView.superview);
        make.left.mas_equalTo(adView.superview).offset(10);
        make.right.mas_equalTo(adView.superview).offset(-10);
    }];
}
+ (void)renderVideo:(WindMillNativeAd *)nativeAd adView:(NativeAdView *)adView {
    [self renderCommon:nativeAd adView:adView];
    UIView *mediaView = adView.nativeAdView.mediaView;
    if (mediaView == nil) {
        return;
    }
    [mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(adView.iconImageView.mas_left);
        make.top.mas_equalTo(adView.iconImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(adView).offset(-10);
        make.height.mas_equalTo(adView.nativeAdView.mas_height).multipliedBy(0.5625);
    }];
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(adView.superview);
        make.left.mas_equalTo(adView.superview).offset(10);
        make.right.mas_equalTo(adView.superview).offset(-10);
    }];
}

+ (void)renderCommon:(WindMillNativeAd *)nativeAd adView:(NativeAdView *)adView {
    [adView.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(adView).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [adView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(adView.iconImageView.mas_top);
        make.left.mas_equalTo(adView.iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(adView).offset(-10);
        make.height.mas_equalTo(adView.iconImageView.mas_height).multipliedBy(0.5);
    }];
    [adView.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(adView.iconImageView.mas_bottom);
        make.left.mas_equalTo(adView.iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(adView).offset(-10);
        make.height.mas_equalTo(adView.iconImageView.mas_height).multipliedBy(0.5);
    }];
    CGSize logoSize = adView.nativeAdView.logoView.frame.size;
    if (CGSizeEqualToSize(logoSize, CGSizeZero)) {
        logoSize = CGSizeMake(30, 30);
    }
    [adView.nativeAdView.logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(adView.iconImageView.mas_left);
        make.bottom.mas_equalTo(adView).offset(-10);
        make.size.mas_equalTo(logoSize);
    }];
    [adView.ctaButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(adView).offset(-10);
        make.bottom.mas_equalTo(adView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        if (adView.nativeAdView.mediaView != nil) {
            make.top.mas_equalTo(adView.nativeAdView.mediaView.mas_bottom).offset(10);
        }else if (adView.nativeAdView.mainImageView != nil) {
            make.top.mas_equalTo(adView.nativeAdView.mainImageView.mas_bottom).offset(10);
        }
    }];
    [adView.nativeAdView.dislikeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(adView).offset(10);
        make.right.mas_equalTo(adView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [adView.nativeAdView setClickableViews:@[
        adView.ctaButton
    ]];
}
@end

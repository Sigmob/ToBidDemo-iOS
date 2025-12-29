//
//  FeedAdViewStyle.m
//  WindDemo
//
//  Created by Codi on 2021/8/23.
//

#import "WindMillFeedAdViewStyle.h"
#import "FeedStyleHelper.h"
#import <Masonry.h>
#import <SDWebImage.h>
#import "NativeAdCustomView.h"
#import <WindMillSDK/WindMillSDK.h>

static CGFloat const margin = 15;
//static CGSize const logoSize = {15, 15};
static UIEdgeInsets const padding = {10, 15, 10, 15};

@implementation WindMillFeedAdViewStyle

+ (void)layoutWithModel:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView {
    if (nativeAd.adType == WindMillNativeAdSlotAdTypeDrawVideo) {
        if (nativeAd.feedADMode == WindMillFeedADModeNativeExpress) {
            [self renderDrawExpressAd:nativeAd adView:adView];
        }else {
            [self renderDrawNativeAd:nativeAd adView:adView];
        }
        return;
    }
    if (nativeAd.feedADMode == WindMillFeedADModeGroupImage) {
        [self renderAdWithGroupImg:nativeAd adView:adView];
    }else if (nativeAd.feedADMode == WindMillFeedADModeLargeImage) {
        [self renderAdWithLargeImg:nativeAd adView:adView];
    }else if (nativeAd.feedADMode == WindMillFeedADModeSmallImage) {
        [self renderAdWithLargeImg:nativeAd adView:adView];
    }else if (nativeAd.feedADMode == WindMillFeedADModeVideo || nativeAd.feedADMode == WindMillFeedADModeVideoPortrait || nativeAd.feedADMode == WindMillFeedADModeVideoLandSpace) {
        [self renderAdWithVideo:nativeAd adView:adView];
    }else if(nativeAd.feedADMode == WindMillFeedADModeNativeExpress) {
        [self renderAdWithNativeExpressAd:nativeAd adView:adView];
    }
}

+ (CGFloat)cellHeightWithModel:(WindMillNativeAd *)nativeAd width:(CGFloat)width {
    if(nativeAd.adType == WindMillNativeAdSlotAdTypeDrawVideo) {
        return UIScreen.mainScreen.bounds.size.height;
    }
    if (nativeAd.feedADMode == WindMillFeedADModeGroupImage) {
        return [self cellGroupImageHeightWithModel:nativeAd width:width];
    }else if (nativeAd.feedADMode == WindMillFeedADModeLargeImage || nativeAd.feedADMode == WindMillFeedADModeSmallImage) {
        return [self cellLargeImageHeightWithModel:nativeAd width:width];
    }else if (nativeAd.feedADMode == WindMillFeedADModeVideo || nativeAd.feedADMode == WindMillFeedADModeVideoPortrait || nativeAd.feedADMode == WindMillFeedADModeVideoLandSpace) {
        return [self cellVideoHeightWithModel:nativeAd width:width];
    }else if(nativeAd.feedADMode == WindMillFeedADModeNativeExpress) {
        return [self cellNativeExpressHeightWithModel:nativeAd width:width];
    }
    return 0;
}

+ (CGFloat)cellGroupImageHeightWithModel:(WindMillNativeAd *)nativeAd width:(CGFloat)width {
    CGFloat contentWidth = (width - 2 * margin);
    
    NSAttributedString *attributedText = [FeedStyleHelper titleAttributeText:nativeAd.title];
    CGSize titleSize = [attributedText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    
    return titleSize.height + descSize.height + 200;
}
+ (CGFloat)cellLargeImageHeightWithModel:(WindMillNativeAd *)nativeAd width:(CGFloat)width {
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat imageHeight = 170;
    CGSize iconSize = CGSizeMake(60, 60);
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    
    return imageHeight + descSize.height + iconSize.height + 80;
}
+ (CGFloat)cellVideoHeightWithModel:(WindMillNativeAd *)nativeAd width:(CGFloat)width {
    CGFloat videoRate = 9.0 / 16.0;//高宽比
    if (nativeAd.feedADMode == WindMillFeedADModeVideoPortrait) {
        videoRate = 16.0 / 9.0;
    }
    if (videoRate > 1.0) {
        videoRate = 1.0;
    }
    CGFloat contentWidth = (width - 2 * margin);
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    return contentWidth + descSize.height + 140;
}

+ (CGFloat)cellNativeExpressHeightWithModel:(WindMillNativeAd *)model width:(CGFloat)width {
    return 0;
}
+ (void)renderDrawExpressAd:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView {
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(adView.superview).offset(0);
        make.size.mas_equalTo(screenSize);
    }];
}
+ (void)renderDrawNativeAd:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView {
    adView.backgroundColor = UIColor.blackColor;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    CGFloat elementWidth = screenWidth * 511.0 / 750;
    if (nativeAd.isVideoAd) {
        adView.mediaView.translatesAutoresizingMaskIntoConstraints = NO;
        [adView.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(adView).offset(0);
        }];
        [adView setClickableViews:@[adView.CTAButton, adView.mediaView, adView.iconImageView]];
    }else {
        adView.mainImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [adView.mainImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(screenWidth*9/16.f);
            make.center.equalTo(adView);
        }];
        [adView setClickableViews:@[adView.CTAButton, adView.mainImageView, adView.iconImageView]];
    }
    adView.iconImageView.layer.cornerRadius = 10;
    adView.iconImageView.layer.masksToBounds = YES;
    adView.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSURL *iconUrl = [NSURL URLWithString:nativeAd.iconUrl];
    [adView.iconImageView sd_setImageWithURL:iconUrl];
    [adView.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(adView).offset(-10);
        make.bottom.mas_equalTo(adView).offset(-274);
    }];
    adView.descLabel.numberOfLines = 2;
    adView.descLabel.font = [UIFont systemFontOfSize:14];
    adView.descLabel.textColor = [UIColor whiteColor];
    adView.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    adView.descLabel.text = nativeAd.desc;
    [adView.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(elementWidth, 39));
        make.left.mas_equalTo(adView).offset(12);
        make.bottom.mas_equalTo(adView).offset(-72);
    }];
    adView.titleLabel.text = nativeAd.title;
    adView.titleLabel.textColor = UIColor.whiteColor;
    adView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    adView.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [adView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(elementWidth, 25));
        make.left.mas_equalTo(adView).offset(12);
        make.bottom.mas_equalTo(adView.descLabel.mas_top).offset(-3.5);
    }];
    
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    adView.CTAButton.titleLabel.font = [UIFont systemFontOfSize:14];
    adView.CTAButton.layer.cornerRadius = 3;
    adView.CTAButton.clipsToBounds = YES;
    adView.CTAButton.translatesAutoresizingMaskIntoConstraints = NO;
    [adView.CTAButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(adView).offset(12);
        make.top.equalTo(adView.descLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(elementWidth, 37));
    }];
    
    CGSize logoSize = adView.logoView.frame.size;
    if(CGSizeEqualToSize(logoSize, CGSizeZero)) {
        logoSize = CGSizeMake(30, 30);
    }
    [adView.logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView).offset(-60);
        make.right.equalTo(adView).offset(-10);
        make.size.mas_equalTo(logoSize);
    }];
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
        make.height.mas_equalTo(screenHeight);
    }];
    if (nativeAd.isVideoAd) {
        [adView setClickableViews:@[adView.CTAButton, adView.mediaView, adView.iconImageView]];
    }else {
        [adView setClickableViews:@[adView.CTAButton, adView.mainImageView, adView.iconImageView]];
    }
}
+ (void)renderAdWithLargeImg:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView{
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat imageHeight = 170;
    [adView.mainImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.mainImageView.superview).offset(padding.top);
        make.left.equalTo(adView.mainImageView.superview).offset(padding.left);
        make.right.equalTo(adView.mainImageView.superview).offset(-padding.right);
        make.height.mas_equalTo(imageHeight);
    }];
    
    CGSize iconSize = CGSizeMake(60, 60);
    NSURL *iconUrl = [NSURL URLWithString:nativeAd.iconUrl];
    adView.iconImageView.layer.masksToBounds = YES;
    adView.iconImageView.layer.cornerRadius = 10;
    [adView.iconImageView sd_setImageWithURL:iconUrl];
    
    [adView.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(iconSize);
        make.top.equalTo(adView.mainImageView.mas_bottom).offset(10);
        make.left.equalTo(adView.iconImageView.superview).offset(padding.left);
    }];

    NSAttributedString *attributedText = [FeedStyleHelper titleAttributeText:nativeAd.title];
    adView.titleLabel.attributedText = attributedText;
    adView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [adView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.left.equalTo(adView.iconImageView.mas_right).offset(padding.left);
        make.right.equalTo(adView.CTAButton.mas_left).offset(-padding.right);
        make.height.equalTo(@60);
    }];
    
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    [adView.CTAButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.right.equalTo(adView.CTAButton.superview).offset(-padding.right);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    adView.descLabel.attributedText = attributedDescText;
    adView.descLabel.numberOfLines = 0;
    adView.descLabel.textColor = UIColor.blackColor;
    [adView.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_bottom).offset(10);
        make.left.equalTo(adView.descLabel.superview).offset(padding.left);
        make.right.equalTo(adView.descLabel.superview).offset(-padding.right);
        make.height.equalTo(@(descSize.height));
    }];
    
    [adView.dislikeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView).offset(-10);
        make.right.equalTo(adView).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    UIView *logoView = adView.logoView;
    CGSize logoSize = logoView.frame.size;
    if(CGSizeEqualToSize(logoSize, CGSizeZero)) {
        logoSize = CGSizeMake(30, 30);
    }
    [logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(logoView.superview).offset(-10);
        make.left.equalTo(logoView.superview).offset(10);
        make.size.mas_equalTo(logoSize);
    }];
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
        make.height.mas_equalTo(imageHeight + descSize.height + iconSize.height + 80);
    }];
    [adView setClickableViews:@[adView.CTAButton, adView.mainImageView, adView.iconImageView]];
}

+ (void)renderAdWithVideo:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView{

    CGFloat videoRate = 9.0 / 16.0;//高宽比
    if (nativeAd.feedADMode == WindMillFeedADModeVideoPortrait) {
        videoRate = 16.0 / 9.0;
    }
    if (videoRate > 1.0) {
        videoRate = 1.0;
    }
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat y = padding.top;
    
    CGSize iconSize = CGSizeMake(60, 60);
    NSURL *iconUrl = [NSURL URLWithString:nativeAd.iconUrl];
    adView.iconImageView.layer.masksToBounds = YES;
    adView.iconImageView.layer.cornerRadius = 10;
    [adView.iconImageView sd_setImageWithURL:iconUrl];
    adView.iconImageView.frame = CGRectMake(padding.left, y, iconSize.width, iconSize.height);
    
    NSAttributedString *attributedText = [FeedStyleHelper titleAttributeText:nativeAd.title];
    adView.titleLabel.attributedText = attributedText;
    adView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [adView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.left.equalTo(adView.iconImageView.mas_right).offset(padding.left);
        make.right.equalTo(adView.CTAButton.mas_left).offset(-padding.right);
        make.height.equalTo(@30);
    }];
    
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    [adView.CTAButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_top).offset(0);
        make.right.equalTo(adView.CTAButton.superview).offset(-padding.right);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    adView.descLabel.attributedText = attributedDescText;
    adView.descLabel.numberOfLines = 0;
    adView.descLabel.textColor = UIColor.blackColor;
    [adView.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.iconImageView.mas_bottom).offset(10);
        make.left.equalTo(adView.descLabel.superview).offset(padding.left);
        make.right.equalTo(adView.descLabel.superview).offset(-padding.right);
        make.height.equalTo(@(descSize.height));
    }];
    
    [adView.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.descLabel.mas_bottom).offset(10);
        make.left.equalTo(adView.mediaView.superview).offset(padding.left);
        make.right.equalTo(adView.mediaView.superview).offset(-padding.right);
        make.height.equalTo(adView.mediaView.mas_width).multipliedBy(videoRate);
    }];
    UIView *logogView = (UIView *)adView.logoView;
    CGFloat logoW = 15;
    CGFloat logoH = 15;
    if (logogView.frame.size.width>0) {
        logoW = logogView.frame.size.width;
        logoH = logogView.frame.size.height;
    }
    [logogView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(logogView.superview).offset(-10);
        make.left.equalTo(logogView.superview).offset(10);
        make.width.equalTo(@(logoW));
        make.height.equalTo(@(logoH));
    }];

    [adView.dislikeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView).offset(-10);
        make.right.equalTo(adView).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    [adView setClickableViews:@[adView.CTAButton, adView.mediaView]];
    
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
        make.height.mas_equalTo(adView.mediaView.mas_height).offset(descSize.height + 140);
    }];
}

+ (void)renderAdWithGroupImg:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView{
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat y = padding.top;
    
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    adView.CTAButton.frame = CGRectMake(width-100-padding.right, y, 100, 30);
    
    NSAttributedString *attributedText = [FeedStyleHelper titleAttributeText:nativeAd.title];
    CGSize titleSize = [attributedText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    adView.titleLabel.attributedText = attributedText;
    adView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    adView.titleLabel.frame = CGRectMake(padding.left, y , contentWidth - 110, titleSize.height);
    
    y += titleSize.height;
    y += 10;
    
    NSAttributedString *attributedDescText = [FeedStyleHelper titleAttributeText:nativeAd.desc];
    CGSize descSize = [attributedDescText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    adView.descLabel.attributedText = attributedDescText;
    adView.descLabel.numberOfLines = 0;
    adView.descLabel.textColor = UIColor.blackColor;
    adView.descLabel.frame = CGRectMake(padding.left, y, contentWidth, descSize.height);
    
    NSArray *arr = adView.imageViewList;
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:padding.left tailSpacing:padding.right];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.descLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(120);
    }];
    
    [adView.dislikeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView).offset(-10);
        make.right.equalTo(adView).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    UIView *logoView = adView.logoView;
    CGSize logoSize = logoView.frame.size;
    if(CGSizeEqualToSize(logoSize, CGSizeZero)) {
        logoSize = CGSizeMake(30, 30);
    }
    [adView.logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(adView.logoView.superview).offset(-10);
        make.left.equalTo(adView.logoView.superview).offset(10);
        make.size.mas_equalTo(logoSize);
    }];
    
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
        make.height.mas_equalTo(titleSize.height + descSize.height + 200);
    }];
    
    [adView setClickableViews:@[adView.CTAButton]];
}

+ (void)renderAdWithNativeExpressAd:(WindMillNativeAd *)nativeAd adView:(NativeAdCustomView *)adView {
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(adView.superview).offset(0);
        make.width.mas_equalTo(adView.frame.size.width);
        make.height.mas_equalTo(adView.frame.size.height);
    }];
}

@end

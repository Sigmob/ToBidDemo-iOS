//
//  NativeAdCustomView.h
//  WindDemo
//
//  Created by Codi on 2021/7/26.
//

#import <UIKit/UIKit.h>
#import <WindMillSDK/WindMillSDK.h>

@interface NativeAdCustomView : WindMillNativeAdView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *CTAButton;
@end

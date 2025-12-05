//
//  NativeAdView.m
//  Demo_OC
//
//  Created by Codi on 2025/11/11.
//

#import "NativeAdView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "NativeAdListener.h"

@interface NativeAdView ()
@property(nonatomic, strong) NativeAdListener *listener;
@end

@implementation NativeAdView

- (instancetype)initWithNativeAd:(WindMillNativeAd *)nativeAd
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.cyanColor;
        self.nativeAd = nativeAd;
        self.nativeAdView = [[WindMillNativeAdView alloc] init];
        self.listener = [[NativeAdListener alloc] initWithNativeAdView:self];
        [self setup];
        [self layout];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.nativeAdView];
    if (self.nativeAd.feedADMode == WindMillFeedADModeNativeExpress) {
        return;
    }
    self.titleLabel = [self createLabel];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [self addSubview:self.titleLabel];
    
    self.descLabel = [self createLabel];
    self.descLabel.textColor = RGB(115, 115, 115);
    self.descLabel.font = [UIFont systemFontOfSize:14];
    self.descLabel.numberOfLines = 2;
    [self addSubview:self.descLabel];
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.layer.masksToBounds = true;
    self.iconImageView.layer.cornerRadius = 10;
    self.iconImageView.userInteractionEnabled = true;
    [self addSubview:self.iconImageView];
    
    self.ctaButton = [self createButton];
    self.ctaButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [self addSubview:self.ctaButton];
}

- (void)layout {
    [self.nativeAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
}

- (void)refresh:(WindMillNativeAd *)nativeAd viewController:(UIViewController *)viewController {
    self.nativeAdView.viewController = viewController;
    self.nativeAdView.delegate = self.listener;
    self.nativeAdView.shakeView.delegate = self.listener;
    [self.nativeAdView refreshData:nativeAd];
    self.titleLabel.text = nativeAd.title;
    self.descLabel.text = nativeAd.desc;
    [self.ctaButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    NSURL *url = [NSURL URLWithString:nativeAd.iconUrl];
    [self.iconImageView sd_setImageWithURL:url];
}

- (UILabel *)createLabel {
    UILabel *label = [UILabel new];
    label.textColor = UIColor.blackColor;
    label.translatesAutoresizingMaskIntoConstraints = false;
    label.numberOfLines = 0;
    return label;
}

- (UIButton *)createButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColor.whiteColor;
    [button setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    button.layer.masksToBounds = true;
    button.layer.cornerRadius = 5;
    button.layer.borderColor = UIColor.systemBlueColor.CGColor;
    button.layer.borderWidth = 1;
    return button;
}

@end

//
//  NativeAdCell.m
//  Demo_OC
//
//  Created by Codi on 2025/11/13.
//

#import "NativeAdCell.h"
#import "NativeAdView.h"
#import "NativeAdStyle.h"

@interface NativeAdCell ()
@property(nonatomic, strong) WindMillNativeAd *nativeAd;
@property(nonatomic, strong) NativeAdView *adView;
@end

@implementation NativeAdCell

- (instancetype)initWithNativeAd:(WindMillNativeAd *)nativeAd style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setup:nativeAd];
    }
    return self;
}

- (void)setup:(WindMillNativeAd *)nativeAd {
    self.adView = [[NativeAdView alloc] initWithNativeAd:nativeAd];
    [self.contentView addSubview:self.adView];
}

- (void)refresh:(WindMillNativeAd *)nativeAd viewController:(UIViewController *)vc delegate:(id<NativeAdViewListener>)delegate {
    [self.adView refresh:nativeAd viewController:vc];
    self.adView.delegate = delegate;
    [NativeAdStyle layout:nativeAd adView:self.adView];
}

@end

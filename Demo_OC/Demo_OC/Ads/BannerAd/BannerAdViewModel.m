//
//  BannerAdViewModel.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "BannerAdViewModel.h"
#import "BannerAdListener.h"
#import "AppUtil.h"
#import <Masonry/Masonry.h>

@interface BannerAdViewModel ()
@property(nonatomic, strong) BannerAdListener *listener;
@end

@implementation BannerAdViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.listener = [[BannerAdListener alloc] init];
    }
    return self;
}
- (void)loadAd:(NSString *)placementId {
    [AppUtil toast:@"开始加载广告..."];
    WindMillBannerView *bannerAdView = [self getAdInstance:placementId];
    if (bannerAdView == nil) {
        DDLogDebug(@"创建广告对象失败");
        return;
    }
    /// banner轮播动画
    bannerAdView.animated = [self hasAnimated];
    bannerAdView.delegate = self.listener;
    [bannerAdView loadAdData];
    
}
- (void)showAd:(NSString *)placementId {
    [AppUtil toast:@"开始播放广告..."];
    WindMillBannerView *bannerAdView = [self getAdInstance:placementId];
    if (bannerAdView == nil) {
        DDLogDebug(@"创建广告对象失败");
        return;
    }
    [self.viewController.view addSubview:bannerAdView];
    [bannerAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.viewController.view.mas_safeAreaLayoutGuideBottom);
        make.centerX.mas_equalTo(self.viewController.view);
        make.size.mas_equalTo(bannerAdView.adSize);
    }];
}

- (WindMillBannerView *)getAdInstance:(NSString *)placementId {
    if (placementId == nil) {
        return nil;
    }
    if ([self.adMap objectForKey:placementId] != nil) {
        return [self.adMap objectForKey:placementId];
    }
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = placementId;
    request.userId = @"your_user_id";
    WindMillBannerView *bannerAdView = [[WindMillBannerView alloc] initWithRequest:request];
    [self.adMap setValue:bannerAdView forKey:placementId];
    return bannerAdView;
}


- (BOOL)hasAnimated {
    XLFormRowDescriptor *row = [self.viewController.form formRowWithTag:@"KUseAnimate"];
    return [row.value isEqualToString:@"开启"];
}
@end

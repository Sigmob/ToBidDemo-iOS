//
//  NativeAdViewModel.m
//  Demo_OC
//
//  Created by Codi on 2025/11/11.
//

#import "NativeAdViewModel.h"
#import "AppUtil.h"
#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>
#import "NativeAdListener.h"
#import "NativeAdStyle.h"
#import "FeedNormalModel.h"
#import "NSMutableArray+RandomInsert.h"
#import "NativeAdTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>

typedef enum : NSUInteger {
    NativeLoadStateLoad,
    NativeLoadStateRefresh,
    NativeLoadStateNext,
} NativeLoadState;

@interface NativeAdViewModel ()<WindMillNativeAdsManagerDelegate>
@property(nonatomic, strong) NativeAdListener *listener;
@property(nonatomic, strong) NSMutableArray<WindMillNativeAd *> *nativeAds;

@property(nonatomic, strong) NSMutableArray<NSObject *> *nextDatas;

@property(nonatomic, assign) NativeLoadState loadState;


@end

@implementation NativeAdViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.listener = [[NativeAdListener alloc] init];
        self.nativeAds = [NSMutableArray array];
        self.datas = [NSMutableArray array];
        self.nextDatas = [NSMutableArray array];
        self.heights = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)initDataSources {
    [self addHud];
    self.loadState = NativeLoadStateLoad;
    [self.datas addObjectsFromArray:[FeedNormalModel fakeDatas]];
    [self loadAd:self.placementId];
}

- (void)loadAd:(NSString *)placementId {
    self.placementId = placementId;
    [AppUtil toast:@"开始加载广告..."];
    WindMillNativeAdsManager *adsManager = [self getAdInstance:placementId];
    if (adsManager == nil) {
        DDLogDebug(@"创建广告对象失败");
        return;
    }
    adsManager.delegate = self;
    [adsManager loadAdDataWithCount:1];
}

- (void)showAd:(NSString *)placementId {
    if (self.nativeAds.count == 0) {
        DDLogDebug(@"无可用渲染的WindMillNativeAd对象");
        return;
    }
    WindMillNativeAd *nativeAd =  self.nativeAds.firstObject;
    NativeAdView *adView = [[NativeAdView alloc] initWithNativeAd:nativeAd];
    adView.tag = 1001;
    [self.viewController.view addSubview:adView];
    [adView refresh:nativeAd viewController:self.viewController];
    [NativeAdStyle layout:nativeAd adView:adView];
}

- (void)showTableListPage:(NSString *)placementId {
    NativeAdTableViewController *vc = [[NativeAdTableViewController alloc] init];
    vc.placementId = placementId;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (WindMillNativeAdsManager *)getAdInstance:(NSString *)placementId {
    if (placementId == nil) {
        return nil;
    }
    if ([self.adMap objectForKey:placementId] != nil) {
        return [self.adMap objectForKey:placementId];
    }
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = placementId;
    request.userId = @"your_user_id";
    WindMillNativeAdsManager *adsManager = [[WindMillNativeAdsManager alloc] initWithRequest:request];
    CGSize size = UIScreen.mainScreen.bounds.size;
    adsManager.adSize = CGSizeMake(size.width, 0);
    adsManager.delegate = self;
    [self.adMap setValue:adsManager forKey:placementId];
    return adsManager;
}
- (void)addHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    hud.label.text = @"广告加载中...";
}
- (void)loadNextPage {
    [self addHud];
    self.loadState = NativeLoadStateNext;
    [self.nextDatas removeAllObjects];
    [self.nextDatas addObjectsFromArray:[FeedNormalModel fakeDatas]];
    [self loadAd:self.placementId];
}

- (void)refresh {
    
}


- (void)endRefreshing {
    [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
    if (self.loadState == NativeLoadStateNext) {
        [self.tableView.mj_footer endRefreshing];
    }else {
        [self.tableView.mj_header endRefreshing];
    }
}

- (NSArray<WindMillNativeAd *> *)nativeAdLoadSuccess {
    [self endRefreshing];
    WindMillNativeAdsManager *adsManager = [self getAdInstance:self.placementId];
    if (adsManager == nil) {
        DDLogDebug(@"创建广告对象失败");
        return @[];
    }
    return [adsManager getAllNativeAds];
}

//WindMillNativeAdsManagerDelegate
- (void)nativeAdsManagerSuccessToLoad:(WindMillNativeAdsManager *)nativeAdsManager {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"广告加载成功"];
    NSArray<WindMillNativeAd *> *nativeAds = [self nativeAdLoadSuccess];
    if (nativeAds.count == 0) {
        DDLogDebug(@"返回广告数量为0");
        return;
    }
    [self.nativeAds removeAllObjects];
    [self.nativeAds addObjectsFromArray:nativeAds];
    if (self.loadState == NativeLoadStateNext) {
        [self.nextDatas randomInsertElementsFromArray:nativeAds];
        [self.datas addObjectsFromArray:self.nextDatas];
        [self.nextDatas removeAllObjects];
    }else {
        [self.datas randomInsertElementsFromArray:nativeAds];
    }
    [self.tableView reloadData];
}
- (void)nativeAdsManager:(WindMillNativeAdsManager *)nativeAdsManager didFailWithError:(NSError *)error {
    DDLogDebug(@"%s", __func__);
    [AppUtil toast:@"广告加载失败" error:error];
    [self endRefreshing];
}

- (void)nativeAdsManagerSuccessAutoToLoad:(WindMillNativeAdsManager *)nativeAdsManager {
    DDLogDebug(@"%s", __func__);
}

- (void)nativeAdsManager:(WindMillNativeAdsManager *)nativeAdsManager didAutoFailWithError:(NSError *)error {
    DDLogDebug(@"%s", __func__);
}

// MARK: NativeAdViewListener
- (void)nativeExpressAdViewRenderSuccess:(NativeAdView *)adView {
    DDLogDebug(@"%s", __func__);
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)adView.nativeAd.hash];
    NSValue *value = [NSValue valueWithCGSize:adView.nativeAdView.bounds.size];
    [self.heights setValue:value forKey:key];
    __block NSInteger index = -1;
    [self.datas enumerateObjectsUsingBlock:^(NSObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.hash == adView.nativeAd.hash) {
            index = idx;
            *stop = YES;
            return;
        }
    }];
    if (index >= 0) {
        [self.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation: UITableViewRowAnimationFade];
    }
}

- (void)nativeExpressAdView:(NativeAdView *)adView renderFail:(NSError *)error {
    DDLogDebug(@"%s", __func__);
}
@end

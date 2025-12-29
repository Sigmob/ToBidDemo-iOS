//
//  XXCSJAdProtocol.h
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/24.
//  Copyright © 2022 Codi. All rights reserved.
//

@class AWMParameter;
@class AWMMediaBidResult;
@class UIViewController;
@protocol AWMCustomAdapter;
@protocol AWMCustomAdapterBridge;

@protocol XXCSJAdProtocol <NSObject>
@optional
/// 构造方法
/// 通过bridge回传开屏广告状态
- (instancetype)initWithBridge:(id<AWMCustomAdapterBridge>)bridge
                       adapter:(id<AWMCustomAdapter>)adapter;

/// 加载广告的方法
/// @param placementId adn的广告位ID
/// @param parameter 广告加载的参数
- (void)loadAdWithPlacementId:(NSString *)placementId
                    parameter:(AWMParameter *)parameter;

/// 信息流 加载广告的方法
/// @param placementId adn的广告位ID
/// @param parameter 广告加载的参数
- (void)loadAdWithPlacementId:(NSString *)placementId
                       adSize:(CGSize)size
                    parameter:(AWMParameter *)parameter;

- (BOOL)mediatedAdStatus;

- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter;

- (void)didReceiveBidResult:(AWMMediaBidResult *)result;

@end

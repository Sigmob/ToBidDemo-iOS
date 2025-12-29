//
//  XXCSJCustomNativeAdapter.m
//  WindMillTTAdAdapter
//
//  Created by Codi on 2022/10/18.
//  Copyright © 2022 Codi. All rights reserved.
//

#import "XXCSJCustomNativeAdapter.h"
#import "XXNativeAdsManager.h"
#import "XXNativeExpressAdManager.h"
#import <WindFoundation/WindFoundation.h>

@interface XXCSJCustomNativeAdapter ()
@property (nonatomic, weak) id<AWMCustomNativeAdapterBridge> bridge;
@property (nonatomic, strong) id<XXCSJAdProtocol> nativeAdManager;
@end

@implementation XXCSJCustomNativeAdapter
- (instancetype)initWithBridge:(id<AWMCustomNativeAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (void)loadAdWithPlacementId:(NSString *)placementId adSize:(CGSize)size parameter:(AWMParameter *)parameter {
    int templateType = [[parameter.customInfo objectForKey:@"templateType"] intValue];
    if (templateType == 1) {
        self.nativeAdManager = [[XXNativeAdsManager alloc] initWithBridge:self.bridge adapter:self];
    }else {
        self.nativeAdManager = [[XXNativeExpressAdManager alloc] initWithBridge:self.bridge adapter:self];
    }
    [self.nativeAdManager loadAdWithPlacementId:placementId adSize:size parameter:parameter];
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    [self.nativeAdManager didReceiveBidResult:result];
}
- (void)dealloc {
    WindmillLogDebug(@"CSJ", @"%s", __func__);
}
@end

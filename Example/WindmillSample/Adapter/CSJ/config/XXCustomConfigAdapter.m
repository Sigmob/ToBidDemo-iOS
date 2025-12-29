//
//  CustomCSJInitAdapter.m
//  WindMillDemo
//
//  Created by Codi on 2022/11/10.
//

#import "XXCustomConfigAdapter.h"
#import <BUAdSDK/BUAdSDK.h>

@interface XXCustomConfigAdapter ()
@property (nonatomic, weak) id<AWMCustomConfigAdapterBridge> bridge;
@end

@implementation XXCustomConfigAdapter
- (instancetype)initWithBridge:(id<AWMCustomConfigAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (AWMCustomAdapterVersion *)basedOnCustomAdapterVersion {
    return AWMCustomAdapterVersion1_0;
}
- (NSString *)adapterVersion {
    return @"1.0.0";
}
- (NSString *)networkSdkVersion {
    return [BUAdSDKManager SDKVersion];
}
- (void)initializeAdapterWithConfiguration:(AWMSdkInitConfig *)initConfig {
    NSString *appId = [initConfig.extra objectForKey:@"appID"];
    BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
    configuration.appID = appId;
    [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self.bridge initializeAdapterSuccess:self];
            }else {
                [self.bridge initializeAdapterFailed:self error:error];
            }
        });
    }];
}
- (void)didRequestAdPrivacyConfigUpdate:(NSDictionary *)config {
    WindMillPersonalizedAdvertisingState personalizedAdvertisingState = [WindMillAds getPersonalizedAdvertisingState];
    if (personalizedAdvertisingState == WindMillPersonalizedAdvertisingOn) {
        [BUAdSDKManager setUserExtData:@"[{\"name\":\"personal_ads_type\",\"value\":\"1\"}]"];
    }else if (personalizedAdvertisingState == WindMillPersonalizedAdvertisingOff) {
        [BUAdSDKManager setUserExtData:@"[{\"name\":\"personal_ads_type\",\"value\":\"0\"}]"];
    }
}
@end

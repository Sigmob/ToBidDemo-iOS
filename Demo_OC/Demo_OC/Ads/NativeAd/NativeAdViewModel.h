//
//  NativeAdViewModel.h
//  Demo_OC
//
//  Created by Codi on 2025/11/11.
//

#import "AdViewModel.h"
#import <UIKit/UIKit.h>
#import "NativeAdView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NativeAdViewModel : AdViewModel<NativeAdViewListener>
@property(nonatomic, copy) NSString *placementId;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray<NSObject *> *datas;
@property(nonatomic, strong) NSMutableDictionary *heights;

- (void)loadAd:(NSString *)placementId;
- (void)showAd:(NSString *)placementId;
- (void)showTableListPage:(NSString *)placementId;
- (void)initDataSources;

@end

NS_ASSUME_NONNULL_END

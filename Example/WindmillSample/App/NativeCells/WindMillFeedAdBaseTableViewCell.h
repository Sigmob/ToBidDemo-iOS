//
//  WindMillFeedAdBaseTableViewCell.h
//  WindDemo
//
//  Created by Codi on 2021/7/26.
//

#import <UIKit/UIKit.h>
#import "NativeAdCustomView.h"
#import <WindMillSDK/WindMillSDK.h>


static CGFloat const margin = 15;
static CGSize const logoSize = {15, 15};
static UIEdgeInsets const padding = {10, 15, 10, 15};


@protocol WindMillFeedCellProtocol <NSObject>

@optional

- (void)refreshUIWithModel:(WindMillNativeAd *)model rootViewController:(UIViewController *)viewController delegate:(id<WindMillNativeAdViewDelegate>)delegate;

+ (CGFloat)cellHeightWithModel:(WindMillNativeAd *)model width:(CGFloat)width;

@end


@interface WindMillFeedAdBaseTableViewCell : UITableViewCell<WindMillFeedCellProtocol>
@property (nonatomic, strong) NativeAdCustomView *adView;
@end

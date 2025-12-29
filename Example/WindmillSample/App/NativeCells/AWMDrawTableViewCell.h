//
//  AWMDrawTableViewCell.h
//  WindDemo
//
//  Created by Codi on 2023/2/8.
//


#import <UIKit/UIKit.h>
#import <WindMillSDK/WindMillSDK.h>
#import "NativeAdCustomView.h"

@protocol AWMDrawCellProtocol <NSObject>
+ (CGFloat)cellHeight;
@end

@interface AWMDrawBaseTableViewCell : UITableViewCell<AWMDrawCellProtocol>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *headImg;
@end

@interface AWMDrawNormalTableViewCell : AWMDrawBaseTableViewCell<AWMDrawCellProtocol>
@property (nonatomic, assign) NSInteger videoId;
- (void)refreshUIAtIndex:(NSUInteger)index;
@end

@interface AWMDrawAdTableViewCell : AWMDrawBaseTableViewCell<AWMDrawCellProtocol>
@property (nonatomic, strong) UIButton *creativeButton;
@property (nonatomic, strong) NativeAdCustomView *adView;

- (void)refreshUIWithModel:(WindMillNativeAd *)model
        rootViewController:(UIViewController *)viewController
                  delegate:(id<WindMillNativeAdViewDelegate>)delegate;
@end

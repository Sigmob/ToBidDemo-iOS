//
//  NativeAdCell.h
//  Demo_OC
//
//  Created by Codi on 2025/11/13.
//

#import <UIKit/UIKit.h>
#import <WindMillSDK/WindMillSDK.h>
#import "NativeAdView.h"

@interface NativeAdCell : UITableViewCell
- (instancetype)initWithNativeAd:(WindMillNativeAd *)nativeAd style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)refresh:(WindMillNativeAd *)nativeAd viewController:(UIViewController *)vc  delegate:(id<NativeAdViewListener>)delegate;
@end

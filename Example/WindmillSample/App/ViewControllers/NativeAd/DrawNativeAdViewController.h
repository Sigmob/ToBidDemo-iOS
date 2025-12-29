//
//  DrawNativeAdViewController.h
//  WindMillDemo
//
//  Created by Codi on 2023/2/8.
//

#import <UIKit/UIKit.h>
@protocol WindMillNativeAdViewDelegate;
@interface DrawNativeAdViewController : UIViewController
@property (nonatomic, strong) NSArray *adList;
@property (nonatomic, weak) UIViewController<WindMillNativeAdViewDelegate> *delegateVC;
@end

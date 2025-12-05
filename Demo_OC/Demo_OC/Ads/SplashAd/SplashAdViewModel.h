//
//  SplashAdViewModel.h
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XLForm/XLForm.h>
#import "AdViewModel.h"

@interface SplashAdViewModel : AdViewModel

@property(nonatomic, weak) XLFormViewController *viewController;

- (void)loadAdAndShow:(NSString *)placementId;

- (void)loadAd:(NSString *)placementId;

- (void)showAd:(NSString *)placementId;

@end

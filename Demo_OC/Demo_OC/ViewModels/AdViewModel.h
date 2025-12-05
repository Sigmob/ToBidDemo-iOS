//
//  AdViewModel.h
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/27.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>

@interface AdViewModel : NSObject<AWMCustomNativeAdapter>
@property(nonatomic, weak) UIViewController *viewController;
@property(nonatomic, strong) NSMutableDictionary *adMap;
@end

//
//  SlotInfo.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "SlotInfo.h"
#import <MJExtension/MJExtension.h>

@implementation Slot

@end

@implementation SlotInfo
+ (NSDictionary *)mj_objectClassInArray {
    return  @{
        @"native_ad": @"Slot",
        @"intersititial_ad": @"Slot",
        @"reward_ad": @"Slot",
        @"banner_ad": @"Slot",
        @"splash_ad": @"Slot",
    };
}
@end

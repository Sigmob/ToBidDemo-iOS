//
//  SlotInfo.h
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import <Foundation/Foundation.h>


@interface Slot : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *placementId;
@end

@interface SlotInfo : NSObject
@property (nonatomic, strong) NSArray<Slot *> *splash_ad;

@property (nonatomic, strong) NSArray<Slot *> *banner_ad;

@property (nonatomic, strong) NSArray<Slot *> *reward_ad;

@property (nonatomic, strong) NSArray<Slot *> *intersititial_ad;

@property (nonatomic, strong) NSArray<Slot *> *native_ad;
@end




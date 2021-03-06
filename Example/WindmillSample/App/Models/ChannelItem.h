//
//  ChannelItem.h
//  WindmillSample
//
//  Created by Codi on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelItem : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *placementId;

@end

NS_ASSUME_NONNULL_END

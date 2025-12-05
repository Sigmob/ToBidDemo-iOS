//
//  DataUtil.h
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import <Foundation/Foundation.h>
#import "SlotInfo.h"

@class DropdownListItem;

NS_ASSUME_NONNULL_BEGIN

@interface DataUtil : NSObject

+ (SlotInfo *)getChannelItems;

+ (NSArray<DropdownListItem *> *)getDropdownDatasource:(NSArray<Slot *> *)datas;

@end

NS_ASSUME_NONNULL_END

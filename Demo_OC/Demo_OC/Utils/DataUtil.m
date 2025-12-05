//
//  DataUtil.m
//  ToBidDemoOC
//
//  Created by Codi on 2025/10/24.
//

#import "DataUtil.h"
#import <MJExtension/MJExtension.h>
#import "WindmillDropdownListView.h"

@implementation DataUtil
+ (SlotInfo *)getChannelItems {
    static SlotInfo *item;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *channelPath = [[NSBundle mainBundle] pathForResource:@"channel" ofType:@"json"];
        NSString *channelStr = [NSString stringWithContentsOfFile:channelPath encoding:NSUTF8StringEncoding error:nil];
        item = [SlotInfo mj_objectWithKeyValues:[channelStr mj_JSONObject]];
    });
    return item;
}

+ (NSArray<DropdownListItem *> *)getDropdownDatasource:(NSArray<Slot *> *)datas {
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:datas.count];
    for (Slot *slot in datas) {
        DropdownListItem *item = [[DropdownListItem alloc] initWithItem:slot.placementId itemName:slot.name];
        [dataSource addObject:item];
    }
    return dataSource;
}
@end

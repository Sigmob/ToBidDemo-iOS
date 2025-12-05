//
//  NSMutableArray+RandomInsert.m
//  Demo_OC
//

#import "NSMutableArray+RandomInsert.h"

@implementation NSMutableArray (RandomInsert)

- (void)randomInsertElementsFromArray:(NSArray *)sourceArray {
    // 检查源数组是否为空
    if (!sourceArray || sourceArray.count == 0) {
        return;
    }
    
    // 创建源数组的可变副本，用于逐个处理元素
    NSMutableArray *remainingElements = [sourceArray mutableCopy];
    
    // 循环处理所有元素，直到处理完
    while (remainingElements.count > 0) {
        // 随机选择一个元素
        NSInteger randomIndex = arc4random_uniform((unsigned int)remainingElements.count);
        id element = remainingElements[randomIndex];
        // 从剩余元素中移除已选择的元素
        [remainingElements removeObjectAtIndex:randomIndex];
        
        // 计算随机插入位置
        NSInteger insertIndex = arc4random_uniform((unsigned int)(self.count + 1));
        // 插入元素到目标数组
        [self insertObject:element atIndex:insertIndex];
    }
}

@end
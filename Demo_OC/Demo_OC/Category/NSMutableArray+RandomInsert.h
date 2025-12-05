//
//  NSMutableArray+RandomInsert.h
//  Demo_OC
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (RandomInsert)

/**
 将源数组中的每个元素随机插入到当前数组中（修改原数组）
 
 @param sourceArray 源数组，包含需要随机插入的元素
 */
- (void)randomInsertElementsFromArray:(NSArray *)sourceArray;

@end
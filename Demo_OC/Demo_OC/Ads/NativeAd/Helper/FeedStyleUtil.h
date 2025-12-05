//
//  FeedStyleUtil.h
//  Demo_OC
//
//  Created by Codi on 2025/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedStyleUtil : NSObject
+ (NSAttributedString *)titleAttributeText:(NSString *)text;

+ (NSAttributedString *)subtitleAttributeText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END

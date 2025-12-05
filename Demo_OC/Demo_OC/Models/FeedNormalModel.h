//
//  FeedNormalModel.h
//  Demo_OC
//
//  Created by Codi on 2025/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedNormalModel : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *incon;
@property (nonatomic, copy) NSArray *imgs;
@property (nonatomic, assign) CGFloat height;

- (NSString *)cellForClassName;

+ (NSArray<FeedNormalModel *> *)fakeDatas;


@end

NS_ASSUME_NONNULL_END

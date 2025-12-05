//
//  FeedNormalModel.m
//  Demo_OC
//
//  Created by Codi on 2025/11/11.
//

#import "FeedNormalModel.h"
#import <MJExtension/MJExtension.h>

@implementation FeedNormalModel

- (CGFloat)height {
    if ([self.type isEqualToString: @"title"]) {
        return 100;
    }else if ([self.type isEqualToString: @"titleImg"]){
        return 130;
    }else if ([self.type isEqualToString: @"bigImg"]){
        return 300;
    }else if ([self.type isEqualToString: @"threeImgs"]){
        return 200;
    }else{
        return 0;
    }
}

- (NSString *)cellForClassName {
    if ([self.type isEqualToString: @"title"]) {
        return @"FeedNormalTitleCell";
    }else if ([self.type isEqualToString: @"titleImg"]){
        return @"FeedNormalTitleImgCell";
    }else if ([self.type isEqualToString: @"bigImg"]){
        return @"FeedNormalBigImgCell";
    }else if ([self.type isEqualToString: @"threeImgs"]){
        return @"FeedNormalThreeImgsCell";
    }else{
        return @"unkownCell";
    }
}

+ (NSArray<FeedNormalModel *> *)fakeDatas {
    NSString *feedPath = [[NSBundle mainBundle] pathForResource:@"feedInfo" ofType:@"cactus"];
    NSString *feedStr = [NSString stringWithContentsOfFile:feedPath encoding:NSUTF8StringEncoding error:nil];
    NSArray<FeedNormalModel *> *datas = [FeedNormalModel mj_objectArrayWithKeyValuesArray:[feedStr mj_JSONObject]];
    return datas;
}

@end

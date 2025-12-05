//
//  FeedNormalCell.h
//  Demo_OC
//
//  Created by Codi on 2025/11/12.
//

#import <UIKit/UIKit.h>
#import "FeedNormalModel.h"

@interface FeedNormalCell : UITableViewCell
@property(nonatomic, strong) UIView *backView;
@property(nonatomic, strong) UIView *separatorLine;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *inconLable;
@property(nonatomic, strong) UILabel *sourceLable;
@property(nonatomic, strong) UIImageView *img1;
@property(nonatomic, strong) UIImageView *img2;
@property(nonatomic, strong) UIImageView *img3;

- (void)refresh:(FeedNormalModel *)data;

@end

@interface FeedNormalTitleCell : FeedNormalCell

@end

@interface FeedNormalTitleImgCell : FeedNormalCell

@end

@interface FeedNormalBigImgCell : FeedNormalCell

@end

@interface FeedNormalThreeImgsCell : FeedNormalCell

@end

//
//  FeedNormalCell.m
//  Demo_OC
//
//  Created by Codi on 2025/11/12.
//

#import "FeedNormalCell.h"
#import <Masonry/Masonry.h>
#import "FeedStyleUtil.h"

@implementation FeedNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backView = [UIView new];
    [self.contentView addSubview:self.backView];
    
    self.separatorLine = [UIView new];
    self.separatorLine.backgroundColor = RGB(217, 217, 217);
    [self.backView addSubview:self.separatorLine];
    [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.backView);
        make.left.mas_equalTo(self.backView).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 2;
    [self.backView addSubview:self.titleLabel];
    
    self.sourceLable = [UILabel new];
    [self.backView addSubview:self.sourceLable];
    
    self.img1 = [UIImageView new];
    self.img1.backgroundColor = RGB(240, 240, 240);
    [self.backView addSubview:self.img1];
    self.img2 = [UIImageView new];
    self.img2.backgroundColor = RGB(240, 240, 240);
    [self.backView addSubview:self.img2];
    self.img3 = [UIImageView new];
    self.img3.backgroundColor = RGB(240, 240, 240);
    [self.backView addSubview:self.img3];
    
    self.inconLable = [UILabel new];
    self.inconLable.font = [UIFont systemFontOfSize:10];
    self.inconLable.textColor = UIColor.redColor;
    self.inconLable.textAlignment = NSTextAlignmentCenter;
    self.inconLable.clipsToBounds = YES;
    self.inconLable.layer.cornerRadius = 3;
    self.inconLable.layer.borderWidth = 0.5;
    self.inconLable.layer.borderColor = UIColor.redColor.CGColor;
    [self.backView addSubview:self.inconLable];
}

- (void)refresh:(FeedNormalModel *)data {
    self.titleLabel.attributedText = [FeedStyleUtil titleAttributeText:data.title];
    self.sourceLable.attributedText = [FeedStyleUtil subtitleAttributeText:data.source];
    self.inconLable.text = data.incon;
    double inconWidth = 30;
    if (data.incon.length == 0) {
        inconWidth = 0;
    }
    [self.inconLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inconLable.superview).offset(10);
        make.bottom.mas_equalTo(self.inconLable.superview).offset(-10);
        make.width.mas_equalTo(inconWidth);
        make.height.mas_equalTo(15);
    }];
    CGFloat padding = inconWidth > 0 ? (20 + inconWidth) : 20;
    [self.sourceLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sourceLable.superview).offset(padding);
        make.bottom.mas_equalTo(self.sourceLable.superview).offset(-10);
    }];
}

@end

@implementation FeedNormalTitleCell
- (void)setup {
    [super setup];
    self.img1.hidden = YES;
    self.img2.hidden = YES;
    self.img3.hidden = YES;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.titleLabel.superview).offset(10);
        make.right.mas_equalTo(self.titleLabel.superview).offset(-10);
        make.height.mas_equalTo(50);
    }];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView.superview);
        make.height.mas_equalTo(100);
    }];
}
@end

@implementation FeedNormalTitleImgCell
- (void)setup {
    [super setup];
    self.img1.hidden = false;
    self.img2.hidden = YES;
    self.img3.hidden = YES;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.titleLabel.superview).offset(10);
        make.right.mas_equalTo(self.img1.mas_left).offset(-10);
        make.height.mas_equalTo(50);
    }];
    [self.img1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.img1.superview).offset(10);
        make.right.mas_equalTo(self.img1.superview).offset(-10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(80);
    }];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView.superview);
        make.height.mas_equalTo(130);
    }];
}
@end

@implementation FeedNormalBigImgCell
- (void)setup {
    [super setup];
    self.img1.hidden = false;
    self.img2.hidden = YES;
    self.img3.hidden = YES;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.titleLabel.superview).offset(10);
        make.right.mas_equalTo(self.titleLabel.superview).offset(-10);
        make.height.mas_equalTo(50);
    }];
    [self.img1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.img1.superview).offset(10);
        make.right.mas_equalTo(self.img1.superview).offset(-10);
        make.height.mas_equalTo(170);
    }];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView.superview);
        make.height.mas_equalTo(300);
    }];
}
@end


@implementation FeedNormalThreeImgsCell
- (void)setup {
    [super setup];
    self.img1.hidden = false;
    self.img2.hidden = false;
    self.img3.hidden = false;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.titleLabel.superview).offset(10);
        make.right.mas_equalTo(self.titleLabel.superview).offset(-10);
        make.height.mas_equalTo(50);
    }];

    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 10;
    stackView.distribution = UIStackViewDistributionFillEqually;
    [self.backView addSubview:stackView];
    [stackView addArrangedSubview:self.img1];
    [stackView addArrangedSubview:self.img2];
    [stackView addArrangedSubview:self.img3];
    [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.height.mas_equalTo(80);
    }];
    
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView.superview);
        make.height.mas_equalTo(200);
    }];
    
}
@end

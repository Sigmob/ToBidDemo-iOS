//
//  AWMDrawTableViewCell.m
//  WindDemo
//
//  Created by Codi on 2023/2/8.
//

#import "AWMDrawTableViewCell.h"
#import "WindMillFeedAdViewStyle.h"
#import <Masonry/Masonry.h>

#define GlobleHeight [UIScreen mainScreen].bounds.size.height
#define GlobleWidth [UIScreen mainScreen].bounds.size.width
#define inconWidth 45
#define inconEdge 15
#define sm_textEnde 5
#define sm_textColor SM_RGB(0xf0, 0xf0, 0xf0)
#define sm_textFont 14
#define GetRandomColor [UIColor colorWithRed:(arc4random()%256/255.0) green:(arc4random()%256/255.0) blue:(arc4random()%256/255.0) alpha:1.0]

@interface AWMDrawBaseTableViewCell()
@property (nonatomic, strong, nullable) UIImageView *likeImg;
@property (nonatomic, strong, nullable) UILabel *likeLable;
@property (nonatomic, strong, nullable) UIImageView *commentImg;
@property (nonatomic, strong, nullable) UILabel *commentLable;
@property (nonatomic, strong, nullable) UIImageView *forwardImg;
@property (nonatomic, strong, nullable) UILabel *forwardLable;
@end

@implementation AWMDrawBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildupView];
    }
    return self;
}

- (void)buildupView {
    self.titleLabel = [UILabel new];
    self.titleLabel.frame = CGRectMake(13, GlobleHeight-180, GlobleWidth-26, 30);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.frame = CGRectMake(13, GlobleHeight-180+40, GlobleWidth-26, 50);
    self.descriptionLabel.font = [UIFont systemFontOfSize:16];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.textColor = [UIColor blackColor];;
    [self.contentView addSubview:self.descriptionLabel];
    
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(GlobleWidth-inconWidth-13, GlobleHeight*0.3, inconWidth, inconWidth)];
    _headImg.image = [UIImage imageNamed:@"head"];
    _headImg.clipsToBounds = YES;
    _headImg.layer.cornerRadius = inconWidth / 2.0f;
    _headImg.layer.borderColor = [UIColor blackColor].CGColor;
    _headImg.layer.borderWidth = 1;
    [self.contentView addSubview:_headImg];
    
    _likeImg = [[UIImageView alloc] initWithFrame:CGRectMake(GlobleWidth-inconWidth-13, _headImg.frame.origin.y + inconWidth + inconEdge, inconWidth, inconWidth)];
    _likeImg.image = [UIImage imageNamed:@"like"];
    [self.contentView addSubview:_likeImg];
    
    _likeLable = [[UILabel alloc] initWithFrame:CGRectMake(GlobleWidth-inconWidth-13, _likeImg.frame.origin.y + inconWidth + sm_textEnde, inconWidth, sm_textFont)];
    _likeLable.font = [UIFont systemFontOfSize:sm_textFont];
    _likeLable.textAlignment = NSTextAlignmentCenter;
    _likeLable.textColor = [UIColor blackColor];;
    _likeLable.text = @"21.4w";
    [self.contentView addSubview:_likeLable];
    
    _commentImg = [[UIImageView alloc] initWithFrame:CGRectMake(GlobleWidth-inconWidth-13, _likeLable.frame.origin.y + sm_textFont + inconEdge, inconWidth, inconWidth)];
    _commentImg.image = [UIImage imageNamed:@"comment"];
    [self.contentView addSubview:_commentImg];
    
    _commentLable = [[UILabel alloc] initWithFrame:CGRectMake(GlobleWidth-inconWidth-13, _commentImg.frame.origin.y + inconWidth + sm_textEnde, inconWidth, sm_textFont)];
    _commentLable.font = [UIFont systemFontOfSize:sm_textFont];
    _commentLable.textAlignment = NSTextAlignmentCenter;
    _commentLable.textColor = [UIColor blackColor];;
    _commentLable.text = @"3065";
    [self.contentView addSubview:_commentLable];
    
    _forwardImg = [[UIImageView alloc] initWithFrame:CGRectMake(GlobleWidth-inconWidth-13, _commentLable.frame.origin.y + sm_textFont + inconEdge, inconWidth, inconWidth)];
    _forwardImg.image = [UIImage imageNamed:@"forward"];
    [self.contentView addSubview:_forwardImg];
    
    _forwardLable = [[UILabel alloc] initWithFrame:CGRectMake(GlobleWidth-inconWidth-13, _forwardImg.frame.origin.y + inconWidth + sm_textEnde, inconWidth, sm_textFont)];
    _forwardLable.font = [UIFont systemFontOfSize:sm_textFont];
    _forwardLable.textAlignment = NSTextAlignmentCenter;
    _forwardLable.textColor = [UIColor blackColor];;
    _forwardLable.text = @"2.9w";
    [self.contentView addSubview:_forwardLable];
}

+ (CGFloat)cellHeight{
    return GlobleHeight;
}

@end

@interface AWMDrawNormalTableViewCell()

@end

@implementation AWMDrawNormalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = GetRandomColor;
    }
    return self;
}

-(void)refreshUIAtIndex:(NSUInteger)index {
    self.titleLabel.text = [NSString stringWithFormat:@"第 【%lu】 页，[Draw]模拟视频标题", index];
    self.descriptionLabel.text = @"沉浸式视频，超强体验，你值得拥有。";
    self.backgroundColor = GetRandomColor;
}

@end

@implementation AWMDrawAdTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self buildupADView];
    }
    return self;
}

- (void)buildupADView{
    self.adView = [NativeAdCustomView new];
    [self.contentView addSubview:self.adView];
}

- (UIButton *)creativeButton{
    if (!_creativeButton) {
        _creativeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_creativeButton setTitle:@"查看详情 >" forState:UIControlStateNormal];
        _creativeButton.backgroundColor = UIColor.blueColor;
        _creativeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _creativeButton;
}

- (void)refreshUIWithModel:(WindMillNativeAd *)model rootViewController:(UIViewController *)viewController delegate:(id<WindMillNativeAdViewDelegate>)delegate {
    self.adView.delegate = delegate;
    [self.adView refreshData:model];
    self.adView.viewController = viewController;
    [WindMillFeedAdViewStyle layoutWithModel:model adView:self.adView];
    [self.adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.contentView).offset(0);
    }];
}


@end

//
//  AppUtil.m
//  WindMillSDK
//

#import "AppUtil.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>

@implementation AppUtil

+ (UIView *)getLogoViewWithTitle:(NSString *)title desc:(NSString *)desc {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 150)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:backView];
    
    // icon
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.layer.masksToBounds = YES;
    iconImgView.layer.cornerRadius = 10;
    UIImage *appIcon = [self getCurrentAppIcon];
    if (appIcon) {
        iconImgView.image = appIcon;
    }
    [backView addSubview:iconImgView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor blackColor];
    [backView addSubview:titleLabel];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.text = desc;
    descLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    descLabel.textColor = [UIColor grayColor];
    [backView addSubview:descLabel];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomView);
        make.height.equalTo(bottomView);
    }];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
//        make.width.equalTo(@60);
//        make.height.equalTo(@60);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(backView);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.top.equalTo(iconImgView.mas_top);
        make.height.equalTo(@36);
        make.right.lessThanOrEqualTo(backView);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.bottom.equalTo(iconImgView.mas_bottom);
        make.height.equalTo(@24);
        make.right.lessThanOrEqualTo(backView);
    }];
    
    return bottomView;
}

+ (UIImage *)getCurrentAppIcon {
    // 检查是否支持替换图标
    if ([UIApplication sharedApplication].supportsAlternateIcons) {
        // 如果使用了替换图标
        if ([UIApplication sharedApplication].alternateIconName) {
            return [UIImage imageNamed:[UIApplication sharedApplication].alternateIconName];
        } else {
            // 使用主图标
            return [self getAppIcon];
        }
    } else {
        // 不支持替换图标，使用主图标
        return [self getAppIcon];
    }
}

#pragma mark - Private Methods

+ (UIImage *)getAppIcon {
    // 获取 Info.plist 中的图标配置
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *iconsDict = infoDictionary[@"CFBundleIcons"];
    if (!iconsDict) {
        return nil;
    }
    
    NSDictionary *primaryIconDict = iconsDict[@"CFBundlePrimaryIcon"];
    if (!primaryIconDict) {
        return nil;
    }
    
    NSArray *iconFiles = primaryIconDict[@"CFBundleIconFiles"];
    if (!iconFiles || [iconFiles count] == 0) {
        return nil;
    }
    
    // 取最大尺寸的图标文件名
    NSString *iconFileName = [iconFiles lastObject];
    // 加载图标
    return [UIImage imageNamed:iconFileName];
}

+ (void)toast:(NSString *)message {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    [window makeToast:message duration:1 position:CSToastPositionBottom];
}

+ (void)toast:(NSString *)message error:(NSError *)error {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    NSString *msg = [NSString stringWithFormat:@"%@, code=%ld, message=%@", message, (long)error.code, error.localizedDescription];
    [window makeToast:msg duration:1.5 position:CSToastPositionBottom];
}

@end

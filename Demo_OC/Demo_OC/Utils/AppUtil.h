//
//  AppUtil.h
//  Demo_OC
//
//  Created by Codi on 2025/11/8.
//

#import <UIKit/UIKit.h>

@interface AppUtil : NSObject

/**
 创建包含应用图标、标题和描述的视图
 
 @param title 标题文本
 @param desc 描述文本
 @return 配置好的视图
 */
+ (UIView *)getLogoViewWithTitle:(NSString *)title desc:(NSString *)desc;

/**
 获取当前应用的图标（支持替换图标）
 
 @return 当前应用图标，如果获取失败返回nil
 */
+ (UIImage *)getCurrentAppIcon;


+ (void)toast:(NSString *)message;

+ (void)toast:(NSString *)message error:(NSError *)error;

@end

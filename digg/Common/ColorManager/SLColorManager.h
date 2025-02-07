//
//  SLColorManager.h
//  digg
//
//  Created by Tim Bao on 2025/2/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLColorManager : NSObject 

// 获取颜色方法
+ (UIColor *)colorForLightMode:(UIColor *)lightColor darkMode:(UIColor *)darkColor;

// 示例颜色 (可以添加更多颜色)
+ (UIColor *)primaryBackgroundColor;
+ (UIColor *)secondaryTextColor;

@end

NS_ASSUME_NONNULL_END

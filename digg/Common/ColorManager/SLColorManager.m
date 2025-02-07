//
//  SLColorManager.m
//  digg
//
//  Created by Tim Bao on 2025/2/7.
//

#import "SLColorManager.h"

@implementation SLColorManager

// 适配暗黑模式的通用方法
+ (UIColor *)colorForLightMode:(UIColor *)lightColor darkMode:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return darkColor;
            } else {
                return lightColor;
            }
        }];
    } else {
        return lightColor;
    }
}

// 示例颜色：主背景颜色
+ (UIColor *)primaryBackgroundColor {
    UIColor *lightColor = [UIColor whiteColor];
    UIColor *darkColor = [UIColor blackColor];
    return [self colorForLightMode:lightColor darkMode:darkColor];
}

// 示例颜色：次要文字颜色
+ (UIColor *)secondaryTextColor {
    UIColor *lightColor = [UIColor darkGrayColor];
    UIColor *darkColor = [UIColor lightGrayColor];
    return [self colorForLightMode:lightColor darkMode:darkColor];
}

@end

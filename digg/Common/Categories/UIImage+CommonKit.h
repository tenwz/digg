//
//  UIImage+CommonKit.h
//  CaocaoCommonKit
//
//  Created by luminary on 2017/11/24.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {

    GradientTypeTopToBottom =0,//从上到小

    GradientTypeLeftToRight =1,//从左到右

    GradientTypeUpleftToLowright =2,//左上到右下

    GradientTypeUprightToLowleft =3,//右上到左下

};

@interface UIImage (CommonKit)

/**
 高斯模糊图片

 @param radius 高斯模糊程度
 @param tintColor 背景色
 @return 模糊之后的图片
 */
- (UIImage *)blurredImageWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor;

/// 根据颜色生成图片
/// @param color 色值
+ (UIImage *)imageWithColor:(UIColor *)color;

/// 根据颜色生成图片
/// @param color 色值
/// @param size 大小
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/// 生成带圆角的图片
/// @param cornerRadius 圆角值
- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius;


+(NSString *)UIImageToBase64Str:(UIImage *)image;

+(UIImage *)Base64StrToUIImage:(NSString *)encodedImageStr;

+ (UIImage*)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;


@end

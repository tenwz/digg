//
//  UIImage+CommonKit.m
//  CaocaoCommonKit
//
//  Created by luminary on 2017/11/24.
//

#import "UIImage+CommonKit.h"
#import <Accelerate/Accelerate.h>


@implementation UIImage (CommonKit)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor {
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    
    //convert to ARGB if it isn't
    if (CGImageGetBitsPerPixel(imageRef) != 32 ||
        CGImageGetBitsPerComponent(imageRef) != 8 ||
        !((CGImageGetBitmapInfo(imageRef) & kCGBitmapAlphaInfoMask)))
    {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        [self drawAtPoint:CGPointZero];
        imageRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
        UIGraphicsEndImageContext();
    }
    
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < 2; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1.f, 1.f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    CGContextAddPath(ctx, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius].CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//图片转字符串
+(NSString *)UIImageToBase64Str:(UIImage *)image
{
    if(image == nil) return nil;
//    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSData *data = UIImagePNGRepresentation(image);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//字符串转图片
+(UIImage *)Base64StrToUIImage:(NSString *)encodedImageStr
{
    if(encodedImageStr == nil) return nil;
    NSData *decodedImageData = [[NSData alloc] initWithBase64Encoding:encodedImageStr];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}

+ (UIImage*)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize {

    NSMutableArray *ar = [NSMutableArray array];

    for(UIColor *c in colors) {

        [ar addObject:(id)c.CGColor];

    }

    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);

    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);

    CGGradientRef gradient =CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar,NULL);

    CGPoint start;

    CGPoint end;

    switch(gradientType) {

        case GradientTypeTopToBottom:

            start =CGPointMake(0.0,0.0);

            end =CGPointMake(0.0, imgSize.height);

            break;

        case GradientTypeLeftToRight:

            start =CGPointMake(0.0,0.0);

            end =CGPointMake(imgSize.width,0.0);

            break;

        case GradientTypeUpleftToLowright:

            start =CGPointMake(0.0,0.0);

            end =CGPointMake(imgSize.width, imgSize.height);

            break;

        case GradientTypeUprightToLowleft:

            start =CGPointMake(imgSize.width,0.0);

            end =CGPointMake(0.0, imgSize.height);

            break;

        default:

            break;

    }

    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    CGGradientRelease(gradient);

    CGContextRestoreGState(context);

    CGColorSpaceRelease(colorSpace);

    UIGraphicsEndImageContext();

    return image;

}

@end

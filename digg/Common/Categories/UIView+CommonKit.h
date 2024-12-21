//
//  UIView+CommonKit.h
//  CaocaoCommonKit
//
//  Created by luminary on 2017/8/18.
//

#import <UIKit/UIKit.h>

@interface UIView (CommonKit)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.


/**
 当前view截图

 @return 图片
 */
- (UIImage *)viewToImage;


+ (CABasicAnimation *)generatorSpringAnimationWithKeyPath:(NSString *)keyPath
                                                fromeValue:(CGFloat)fromValue
                                                   toValue:(CGFloat)toVlaue;


/**
 最新的线性动画 上面的弹性动画慢慢不使用了
 */
+ (CABasicAnimation *)generatorLineAnimationWithKeyPath:(NSString *)keyPath
                                             fromeValue:(CGFloat)fromValue
                                                toValue:(CGFloat)toValue;
@end

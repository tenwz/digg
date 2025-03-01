//
//  SLTagsView.h
//  digg
//
//  Created by Tim Bao on 2025/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTagsView : UIView

/// 设置标签数据
/// @param tags 标签数组
/// @param maxWidth 最大宽度（一般为屏幕宽度）
- (void)setTags:(NSArray<NSString *> *)tags maxWidth:(CGFloat)maxWidth;

/// 获取最终计算的高度
- (CGFloat)calculatedHeight;


@end

NS_ASSUME_NONNULL_END

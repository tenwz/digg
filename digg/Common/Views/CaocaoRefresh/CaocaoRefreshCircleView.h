//
//  UXRefreshCircleView.h
//  UXRefreshDemo
//
//  Created by byn on 2017/11/24.
//  Copyright © 2017年 uxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaocaoRefreshCircleView : UIView

- (void)setCicleRun:(CGFloat)percent;
- (void)startRefreshingAnimation;
- (void)stopRefreshingAnimation;

@end

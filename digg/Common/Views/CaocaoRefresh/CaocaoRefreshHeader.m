//
//  UXRefreshHeader.m
//  UXRefreshDemo
//
//  Created by byn on 2017/11/24.
//  Copyright © 2017年 uxing. All rights reserved.
//

#import "CaocaoRefreshHeader.h"
#import "CaocaoRefreshCircleView.h"
@interface CaocaoRefreshHeader()

@property (nonatomic, strong) CaocaoRefreshCircleView *circleView;

@end

@implementation CaocaoRefreshHeader

- (CaocaoRefreshCircleView *)circleView {
    if (!_circleView) {
        _circleView = [[CaocaoRefreshCircleView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    }
    return _circleView;
}

- (void)prepare {
    [super prepare];
    [self addSubview:self.circleView];
}


- (void)placeSubviews {
    [super placeSubviews];
    self.circleView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, self.frame.size.height / 2);
    
}


#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            [self.circleView stopRefreshingAnimation];
            break;
        case MJRefreshStatePulling:
            break;
        case MJRefreshStateRefreshing:
            [self.circleView startRefreshingAnimation];
            break;
        default:
            break;
    }
}


#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    if (pullingPercent >= 1.0) {
        [self.circleView setCicleRun:1.0];
    } else {
        [self.circleView setCicleRun:pullingPercent];
    }
}

@end


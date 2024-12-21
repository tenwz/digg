//
//  UXRefreshCircleView.m
//  UXRefreshDemo
//
//  Created by byn on 2017/11/24.
//  Copyright © 2017年 uxing. All rights reserved.
//

#import "CaocaoRefreshCircleView.h"

@interface CaocaoRefreshCircleView()

@property (nonatomic, strong) UIColor *backgroundCircleCol;
@property (nonatomic, strong) UIColor *foregroundCircleCol;
@property (nonatomic, strong) CAShapeLayer *foregroundLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval originTime;
@property (nonatomic, assign) CFTimeInterval timeNow;

@end

@implementation CaocaoRefreshCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self uiInit];
    return self;
}

- (void)uiInit {
    self.backgroundCircleCol = [UIColor colorWithRed:221.0 / 255 green:222.0 / 255 blue:225.0 / 255 alpha:1];
    self.foregroundCircleCol = [UIColor colorWithRed:105.0 / 255 green:105.0 / 255 blue:112.0 / 255 alpha:1];
    
    CAShapeLayer *sharpLayer = [CAShapeLayer layer];
    sharpLayer.frame = self.bounds;
    sharpLayer.fillColor = [UIColor clearColor].CGColor;
    sharpLayer.strokeColor = self.backgroundCircleCol.CGColor;
    sharpLayer.lineWidth = 2;
    CGFloat width = self.frame.size.width / 2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width, width) radius:width startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    sharpLayer.path = path.CGPath;
    [self.layer addSublayer:sharpLayer];
    
    CAShapeLayer *foregroundLayer = [CAShapeLayer layer];
    foregroundLayer.frame = self.bounds;
    foregroundLayer.fillColor = [UIColor clearColor].CGColor;
    foregroundLayer.strokeColor = self.foregroundCircleCol.CGColor;
    foregroundLayer.lineWidth = 2;
    //CGFloat width = self.frame.size.width / 2.0;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width, width) radius:width startAngle:- M_PI / 2 endAngle:-M_PI / 2 + M_PI * 2 * 0.05 clockwise:YES];
    foregroundLayer.path = path2.CGPath;
    [self.layer addSublayer:foregroundLayer];
    self.foregroundLayer = foregroundLayer;
}

- (void)setCicleRun:(CGFloat)percent {
    CGFloat width = self.frame.size.width / 2.0;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width, width) radius:width startAngle:- M_PI / 2 endAngle:-M_PI / 2 + M_PI * 2 * percent clockwise:YES];
    self.foregroundLayer.path = path2.CGPath;
}

- (void)setCircleRenderFrom:(CGFloat)startAngle to:(CGFloat)endAngle {
    CGFloat width = self.frame.size.width / 2.0;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width, width) radius:width startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.foregroundLayer.path = path2.CGPath;
}

- (void)onRefreshingState {
    self.timeNow = CACurrentMediaTime();
    CFTimeInterval delta = self.timeNow - self.originTime;
    delta *= 1000;
    CGFloat time = 500;
    if (delta < time) {
        CGFloat endAngle = -M_PI / 2  + M_PI * 2;
        CGFloat startAngle = -M_PI / 2 + (M_PI * 2) * (delta /time);
        [self setCircleRenderFrom:startAngle to:endAngle];
    } else if(delta >= time && delta <= time * 2) {
        CGFloat endAngle = -M_PI / 2  + M_PI * 2 * (delta /time) + M_PI * 2 * 0.1;
        CGFloat startAngle = -M_PI / 2 + (M_PI * 2) * (delta /time);
        [self setCircleRenderFrom:startAngle to:endAngle];
    } else if(delta > time * 2) {
        CGFloat endAngle = -M_PI / 2  + M_PI * 2 * (delta /time) + M_PI * 2 * 0.2;
        CGFloat startAngle = -M_PI / 2 + (M_PI * 2) * (delta /time)  + M_PI * 2 * 0.1;
        [self setCircleRenderFrom:startAngle to:endAngle];
    } else {
        //[self stopDisplayLink];
    }
}

- (void)startRefreshingAnimation {
    [self stopDisplayLink];
    self.timeNow = CACurrentMediaTime();
    self.originTime = self.timeNow;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onRefreshingState)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.paused = NO;
}

- (void)stopRefreshingAnimation {
    [self stopDisplayLink];
}

- (void)stopDisplayLink {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

@end

//
//  CaocaoLoadDataDefaultView.h
//  Pods
//
//  Created by luminary on 2017/8/29.
//
//

#import <UIKit/UIKit.h>
#import <YYImage/YYImage.h>

/**
 点击按钮代理事件回调
 */
@protocol CaocaoLoadDataDelegate <NSObject>

/**
 页面展示第一个按钮的回调
 */
- (void)dataLoadActionCallback;

/**
 页面展示第二个按钮的回调
 */
- (void)dataOtherActionCallback;

@end

typedef NS_ENUM(NSInteger, CaocaoDataMode){
    CaocaoDataModeLoading = 1,
    CaocaoDataModeEmpty,
    CaocaoDataModeDone
};


@interface CaocaoLoadDataDefaultView : UIView

@property (nonatomic, weak) id<CaocaoLoadDataDelegate> delegate;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, strong) YYAnimatedImageView *animationView;

@property (nonatomic, strong) UILabel     *textLabel;

@property (nonatomic, strong) UIButton    *actionButton;

@property (nonatomic, strong) UIButton    *otherButton;

///针对助老模式调整的大字体模式
@property (nonatomic, assign) BOOL largeMode;

/**
 对应状态文案

 @param text 文案
 @param mode 类型
 */
- (void)loadStateText:(NSString *)text mode:(CaocaoDataMode)mode;

/**
 回调按钮的文案

 @param text 文案
 */
- (void)loadCallbackText:(NSString *)text otherCallbackText:(NSString *)otherCallbackText;

@end

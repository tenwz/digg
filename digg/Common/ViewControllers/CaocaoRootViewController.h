//
//  CaocaoRootViewController.h
//  CaocaoCommonKit
//
//  Created by luminary on 2017/8/16.
//

#import <UIKit/UIKit.h>
#import "CaocaoLoadDataDefaultView.h"

typedef NS_ENUM(NSInteger, CaocaoDataLoadState)
{
    /**
     普通状态
     */
    CaocaoDataLoadStateNormal = 0,
    /**
     加载状态
     */
    CaocaoDataLoadStateLoading = 1,
    /**
     加载错误
     */
    CaocaoDataLoadStateError = 2,
    /**
     加载为空
     */
    CaocaoDataLoadStateEmpty = 3,
    /**
     网络问题
     */
    CaocaoDataLoadStateNetWork = 4,
    /**
     加载成功
     */
    CaocaoDataLoadStateSuccess = 5
};


@interface CaocaoRootViewController : UIViewController<CaocaoLoadDataDelegate>



/**
 数据加载的状态
 */
@property (nonatomic, assign) CaocaoDataLoadState dataState;

/**
 对应状态文案配置(加载中,失败,空状态)

 @return 文案
 */
- (NSString *)dataStateStringPerfer;

/**
 回调按钮文案配置
 
 @return 文案
 */
- (NSString *)callbackActionStringPerfer;

/**
 第二个回调按钮文案配置

 @return 文案
 */
- (NSString *)otherCallbackStringPerfer;

/**
 图片展示配置
 
 @return 占位图
 */
- (NSString *)dataStateImagePerfer;


/**
 dataStateView的frame
 
 @return frame
 */
- (CGRect)dataStateViewFramePerfer;


@end

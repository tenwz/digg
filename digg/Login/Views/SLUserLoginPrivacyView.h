//
//  CaocaoUserLoginPrivacyView.h
//  Pods
//
//  Created by zhangjin on 2022/3/6.
//	
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UserLoginPrivacyStatus){
    UserLoginPrivacyStatusNormal = 0,
    UserLoginPrivacyStatusActive = 1
};

@interface SLUserLoginPrivacyView : UIView

@property (nonatomic, assign) UserLoginPrivacyStatus privacyStatus;

@property (nonatomic, copy) void(^clickedCallBack)(NSString *url);

- (void)showWithPrivacyViewWithPrivacyName:(NSString *)privacyName privacyUrl:(NSString *)privacyUrl;

@end

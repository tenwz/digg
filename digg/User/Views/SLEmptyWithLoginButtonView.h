//
//  SLEmptyWithLoginButtonView.h
//  digg
//
//  Created by Tim Bao on 2025/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLEmptyWithLoginButtonViewDelegate <NSObject>

@optional
- (void)gotoLoginPage;

@end

@interface SLEmptyWithLoginButtonView : UIView

@property (nonatomic, weak) id<SLEmptyWithLoginButtonViewDelegate> delegate;
@property (nonatomic, strong) UIButton* loginBtn;

@end

NS_ASSUME_NONNULL_END

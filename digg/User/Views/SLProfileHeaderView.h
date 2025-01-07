//
//  SLProfileHeaderView.h
//  digg
//
//  Created by Tim Bao on 2025/1/5.
//

#import <UIKit/UIKit.h>
#import "SLProfileEntity.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SLProfileHeaderViewDelegate <NSObject>

@optional
- (void)gotoEditPersonalInfo;

@end

@interface SLProfileHeaderView : UIView

@property (nonatomic, weak) id<SLProfileHeaderViewDelegate> delegate;
@property (nonatomic, strong) SLProfileEntity* entity;
@property (nonatomic, strong) UIImageView* avatarImageView;

@end

NS_ASSUME_NONNULL_END

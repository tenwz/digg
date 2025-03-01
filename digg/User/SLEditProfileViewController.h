//
//  SLEditProfileViewController.h
//  digg
//
//  Created by Tim Bao on 2025/1/7.
//

#import <UIKit/UIKit.h>
#import "SLProfileEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLEditProfileViewController : UIViewController

@property (nonatomic, copy) void(^updateSucessCallback) ();
@property (nonatomic, strong) SLProfileEntity *entity;

@end

NS_ASSUME_NONNULL_END

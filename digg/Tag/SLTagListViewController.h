//
//  SLTagListViewController.h
//  digg
//
//  Created by Tim Bao on 2025/1/12.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
#import "CaocaoRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLTagListViewController : CaocaoRootViewController <JXCategoryListContentViewDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString* label;

@end

NS_ASSUME_NONNULL_END

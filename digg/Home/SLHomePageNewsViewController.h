//
//  SLHomePageNewsViewController.h
//  digg
//
//  Created by hey on 2024/9/26.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
#import "CaocaoRootViewController.h"
#import "SLHomePageViewModel.h"

@interface SLHomePageNewsViewController : CaocaoRootViewController<JXCategoryListContentViewDelegate>

@property (nonatomic,assign) HomePageStyle pageStyle;

@end



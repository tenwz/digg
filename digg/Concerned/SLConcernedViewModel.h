//
//  SLConcernedViewModel.h
//  digg
//
//  Created by Tim Bao on 2025/1/23.
//

#import <Foundation/Foundation.h>
#import "EnvConfigHeader.h"
#import "SLGeneralMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLConcernedViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;

/// 当前页面
@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, assign) NSInteger pageSize;

/// 是否有下一页
@property (nonatomic, assign) BOOL hasToEnd;

//拉取消息列表
- (void)loadMessageListWithRefreshType:(CaocaoCarMessageListRefreshType)refreshType
                         resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler;

@end

NS_ASSUME_NONNULL_END

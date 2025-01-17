//
//  SLHomePageViewModel.h
//  digg
//
//  Created by hey on 2024/10/17.
//

#import <Foundation/Foundation.h>
#import "SLArticleTodayEntity.h"
#import "SLCommentFeedEntity.h"
#import "EnvConfigHeader.h"
#import "SLGeneralMacro.h"

typedef NS_ENUM(NSUInteger, HomePageStyle) {
    HomePageStyleToday = 0, //今天
    HomePageStyleDiscover = 1, //发现
    HomePageStyleForyou = 2
//    HomePageSyleLatest,    //最新
//    HomePageSyleProduct,   //作品
//    HomePageSyleDiscussion,  //讨论
//    HomePageSyleQuestion,   //问答
//    HomePageSyleSelection   //精选
    
};

//typedef NS_ENUM(NSInteger, CaocaoCarMessageListRefreshType) {
//    CaocaoCarMessageListRefreshTypeRefresh = 0,
//    CaocaoCarMessageListRefreshTypeLoadMore,
//};

@interface SLHomePageViewModel : NSObject
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 当前页面
@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, assign) NSInteger pageSize;

/// 是否有下一页
@property (nonatomic, assign) BOOL hasToEnd;

//拉取消息列表
- (void)loadMessageListWithRefreshType:(CaocaoCarMessageListRefreshType)refreshType
                        withPageStyle:(HomePageStyle)pageSyle
                        resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler;

//点赞
- (void)likeWith:(NSString *)articleId
      resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler;
//踩
- (void)dislikeWith:(NSString *)articleId
      resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler;
//取消踩或者赞
- (void)cancelLikeWith:(NSString *)articleId
      resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler;

//首页“为你”未读消息数量
- (void)getForYouRedPoint:(void(^)(NSInteger number, NSError *error))handler;

@end


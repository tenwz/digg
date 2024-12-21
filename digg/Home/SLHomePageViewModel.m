//
//  SLHomePageViewModel.m
//  digg
//
//  Created by hey on 2024/10/17.
//

#import "SLHomePageViewModel.h"
#import <AFNetworking/AFNetworking.h>
#import "SLGeneralMacro.h"
#import <YYModel/YYModel.h>

@implementation SLHomePageViewModel


- (instancetype)init{
    self = [super init];
    if (self) {
        self.curPage = 1;
        self.pageSize = 10;
    }
    return self;
}

//拉取消息列表
- (void)loadMessageListWithRefreshType:(CaocaoCarMessageListRefreshType)refreshType
                         withPageStyle:(HomePageStyle)pageSyle
                        resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (refreshType == CaocaoCarMessageListRefreshTypeRefresh) {
        self.curPage = 1;
    }
    NSString *urlString = [self handleReqApiPath:pageSyle];
    @weakobj(self);
    [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (handler) {
//            NSLog(@"res:%@",responseObject);
            @strongobj(self);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                [self handleRes:responseObject
                   withPageType:pageSyle
                withRefreshType:refreshType];
            }
            handler(YES,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"req error = %@",error);
        if (handler) {
            handler(NO,error);
        }
    }];
}

- (NSString *)handleReqApiPath:(HomePageStyle)pageStyle{
    NSString *urlString;
    NSString *baseUrl = ApiBaseUrl;
    urlString = [NSString stringWithFormat:@"%@/api/article/today?pageNo=%ld&pageSize=%ld",baseUrl,self.curPage,self.pageSize];

//    if (pageStyle == HomePageSyleQuestion) {
//        urlString = [NSString stringWithFormat:@"%@/api/comment/commentFeed?pageNo=%ld&pageSize=%ld",baseUrl,self.curPage,self.pageSize];
//    }else{
//        urlString = [NSString stringWithFormat:@"%@/api/article/today?pageNo=%ld&pageSize=%ld",baseUrl,self.curPage,self.pageSize];
//    }
    return urlString;
}

- (void)handleRes:(NSArray *)resArray
     withPageType:(HomePageStyle)pageStyle
  withRefreshType:(CaocaoCarMessageListRefreshType)refreshType{
//    if (pageStyle == HomePageSyleToday ||
//        pageStyle == HomePageSyleLatest ||
//        pageStyle == HomePageSyleProduct) {
//        NSArray *list = [NSArray yy_modelArrayWithClass:[SLArticleTodayEntity class] json:resArray];
//        if (refreshType == CaocaoCarMessageListRefreshTypeRefresh) {
//            self.dataArray = [NSMutableArray arrayWithArray:list];
//        }else{
//            [self.dataArray addObjectsFromArray:list];
//        }
//    }else if (pageStyle == HomePageSyleQuestion){
//        //讨论
//        NSArray *list = [NSArray yy_modelArrayWithClass:[SLCommentFeedEntity class] json:resArray];
//        if (refreshType == CaocaoCarMessageListRefreshTypeRefresh) {
//            self.dataArray = [NSMutableArray arrayWithArray:list];
//        }else{
//            [self.dataArray addObjectsFromArray:list];
//        }
//    }
    
    NSArray *list = [NSArray yy_modelArrayWithClass:[SLArticleTodayEntity class] json:resArray];
    if (refreshType == CaocaoCarMessageListRefreshTypeRefresh) {
        self.dataArray = [NSMutableArray arrayWithArray:list];
    }else{
        [self.dataArray addObjectsFromArray:list];
    }
    
    if (refreshType == CaocaoCarMessageListRefreshTypeLoadMore &&
        resArray.count > 0) {
        self.curPage ++;
    }
}

- (void)likeWith:(NSString *)articleId
   resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@/like",ApiBaseUrl];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:articleId forKey:@"articleId"];
    [manager POST:urlString parameters:mutDic.copy headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (handler) {
            //判断是否点赞成功
            handler(YES,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (handler) {
            handler(NO,error);
        }
    }];
}

- (void)dislikeWith:(NSString *)articleId
   resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@/dislike",ApiBaseUrl];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:articleId forKey:@"articleId"];
//    @weakobj(self);
    [manager POST:urlString parameters:mutDic.copy headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (handler) {
            //判断是否点赞成功
            handler(YES,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (handler) {
            handler(NO,error);
        }
    }];
}

- (void)cancelLikeWith:(NSString *)articleId resultHandler:(void (^)(BOOL, NSError *))handler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@/cancel",ApiBaseUrl];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:articleId forKey:@"articleId"];
    @weakobj(self);
    [manager POST:urlString parameters:mutDic.copy headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (handler) {
            //判断是否点赞成功
            handler(YES,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (handler) {
            handler(NO,error);
        }
    }];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


@end

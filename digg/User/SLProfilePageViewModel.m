//
//  SLProfilePageViewModel.m
//  digg
//
//  Created by Tim Bao on 2025/1/6.
//

#import "SLProfilePageViewModel.h"
#import <AFNetworking/AFNetworking.h>
#import "SLGeneralMacro.h"
#import "EnvConfigHeader.h"
#import <YYModel/YYModel.h>
#import "SLProfileEntity.h"
#import "SLUser.h"

@implementation SLProfilePageViewModel

- (void)loadUserProfileWithProfileID:(NSString *)profileId
                        resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler {
    if (profileId.length == 0) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@/profile", APPBaseUrl];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *cookieStr = [NSString stringWithFormat:@"bp-token=%@", [SLUser defaultUser].userEntity.token];
    [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    @weakobj(self);
    [manager GET:urlString parameters:@{@"userId": profileId} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (handler) {
            @strongobj(self);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                self.entity = [SLProfileEntity yy_modelWithJSON:responseObject];
                handler(YES, nil);
            } else {
                handler(NO, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (handler) {
            handler(NO, error);
        }
    }];
}

- (void)isUserLogin:(void(^)(BOOL isLogin, NSError *error))handler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@/auth/currentUser", APPBaseUrl];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *cookieStr = [NSString stringWithFormat:@"bp-token=%@", [SLUser defaultUser].userEntity.token];
    [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    @weakobj(self);
    [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (handler) {
            @strongobj(self);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                handler(YES, nil);
            } else {
                handler(NO, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (handler) {
            handler(NO, error);
        }
    }];
}

@end

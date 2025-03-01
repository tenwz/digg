//
//  SLProfilePageViewModel.h
//  digg
//
//  Created by Tim Bao on 2025/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SLProfileEntity;

@interface SLProfilePageViewModel : NSObject

@property (nonatomic, strong) SLProfileEntity *entity;

/// 当前页面
@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, assign) NSInteger pageSize;

/// 是否有下一页
@property (nonatomic, assign) BOOL hasToEnd;

//判断用户是否登录

//拉取用户信息
- (void)loadUserProfileWithProfileID:(NSString *)profileId
                        resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler;

- (void)isUserLogin:(void(^)(BOOL isLogin, NSError *error))handler;

- (void)logout:(void(^)(BOOL success, NSError *error))handler;

- (void)followWithUserID:(NSString *)userId cancel:(BOOL)cancel resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler;

- (void)updateProfileWithUserID:(NSString *)userId nickName:(NSString *)nickName desc:(NSString *)description avatar:(NSData *)avatar bg:(NSData *)bg resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler;

@end

NS_ASSUME_NONNULL_END

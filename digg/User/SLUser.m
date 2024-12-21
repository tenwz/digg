//
//  SLUser.m
//  digg
//
//  Created by hey on 2024/11/24.
//

#import "SLUser.h"

#define kArchiverName @"nevcuser.archiver"
NSString *const NEUserDidLogoutNotification = @"ne_vc_user_did_logout";
NSString *const NEUserDidLoginNotification = @"ne_vc_user_did_login";
NSString *const NEUserInfoDidUpdateNotification = @"ne_vc_userInfo_did_update";

@interface SLUser ()

@property (nonatomic, assign, readwrite) BOOL isLogin;

@end

@implementation SLUser

+ (SLUser *)defaultUser{
    static SLUser *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[SLUser alloc] init];
    });
    return user;
}

#pragma mark - 从本地加载用户信息
- (void)loadUserInfoFromLocal
{
    NSString *path = [self pathWithFileName:kArchiverName];
    SLUserEntity *userEntity = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [self userDidLogin:userEntity fromLocal:YES];
}

- (void)userDidLogin:(SLUserEntity *)userEntity fromLocal:(BOOL)fromLocal {
    if (!userEntity) {
        return;
    }
    self.userEntity = userEntity;
    if (userEntity.token.length > 0) {
        self.isLogin = YES;
    }
    
    if (self.isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NEUserDidLoginNotification object:@(fromLocal)];
    }

}

#pragma mark - 保存用户信息
- (void)saveUserInfo:(SLUserEntity *)userEntity
{
    if (userEntity) {
        NSString *path = [self pathWithFileName:kArchiverName];
        BOOL result = [NSKeyedArchiver archiveRootObject:userEntity toFile:path];
        NSLog(@"保存用户信息结果 = %d",result);
        [self userDidLogin:userEntity fromLocal:NO];
    }
}

#pragma mark - 清除用户信息
- (void)clearUserInfo
{
    NSString *path = [self pathWithFileName:kArchiverName];
    [NSKeyedArchiver archiveRootObject:nil toFile:path];
    self.userEntity = nil;
    self.isLogin = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NEUserDidLogoutNotification object:nil];
}

#pragma mark - 根据文件名获取路径
- (NSString *)pathWithFileName:(NSString *)fileName
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    return path;
}

@end

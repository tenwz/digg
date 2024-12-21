//
//  AppDelegate.m
//  digg
//
//  Created by hey on 2024/9/24.
//

#import "AppDelegate.h"
#import "SLTabbarController.h"
#import "SLUser.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()<UIApplicationDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[SLUser defaultUser] loadUserInfoFromLocal];
    SLTabbarController *rootVC = [[SLTabbarController alloc] init];
    
    if ([UIApplication sharedApplication].delegate.window == nil) {
        [UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor blackColor];
    }
    [UIApplication sharedApplication].delegate.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    [Bugly startWithAppId:@"b8c3f72ee7"];
    return YES;
}


@end

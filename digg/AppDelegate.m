//
//  AppDelegate.m
//  digg
//
//  Created by hey on 2024/9/24.
//

#import "AppDelegate.h"
#import "SLTabbarController.h"
#import "SLUser.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()<UIApplicationDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[SLUser defaultUser] loadUserInfoFromLocal];
    SLTabbarController *rootVC = [[SLTabbarController alloc] init];
    
    if ([UIApplication sharedApplication].delegate.window == nil) {
        [UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor blackColor];
    }
    [UIApplication sharedApplication].delegate.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}


@end

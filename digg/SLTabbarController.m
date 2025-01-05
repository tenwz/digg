//
//  SLTabbarController.m
//  digg
//
//  Created by hey on 2024/10/5.
//

#import "SLTabbarController.h"
#import "SLNavigationController.h"
#import "SLHomePageViewController.h"
#import "SLFollowingListViewController.h"
#import "SLMineViewController.h"
#import "HomeViewController.h"

#import "SLLoginViewController.h"
#import "SLPublishViewController.h"
#import "SLHomeWebViewController.h"
#import "EnvConfigHeader.h"
#import "SLUser.h"
#import "SLGeneralMacro.h"

#import <WebKit/WebKit.h>

@interface SLTabbarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) SLNavigationController *homeNavi;
@property (nonatomic, strong) SLWebViewController *noticeVC;
@property (nonatomic, strong) SLWebViewController *recordVC;
@property (nonatomic, strong) SLWebViewController *mineVC;
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation SLTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    
    [self createTabbarControllers];
    [self setDefaultUA];
    [self noticeUserLogin];
}

- (void)setDefaultUA{
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [self.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable defaultUserAgent, NSError * _Nullable error) {
        NSLog(@"defaultUserAgent = %@",defaultUserAgent);
        if (stringIsEmpty(defaultUserAgent)) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"digg_default_userAgent"];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:defaultUserAgent forKey:@"digg_default_userAgent"];
        }
    }];
}

- (void)noticeUserLogin{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogin:)
                                                 name:NEUserDidLoginNotification
                                               object:nil];
}

- (void)didLogin:(NSNotification *)object {
    BOOL fromLocal = [object.object boolValue];
    if (fromLocal) return;
    //登录成功之后
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)createTabbarControllers{
    self.tabBar.tintColor = [UIColor blackColor];
    
    SLHomePageViewController *homeVC = [[SLHomePageViewController alloc] init];
    SLNavigationController *homeNavi = [self createRootNavi];
    homeNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"home_unsel"] selectedImage:[UIImage imageNamed:@"home_selected"]];
    homeNavi.viewControllers = @[homeVC];
    self.homeNavi = homeNavi;
    
//    SLFollowingListController *noticeVC = [[SLFollowingListViewController alloc] init];
//    UINavigationController *noticeNavi = [self createRootNavi];
    
    SLWebViewController *noticeVC = [[SLWebViewController alloc] init];
    [noticeVC startLoadRequestWithUrl:[NSString stringWithFormat:@"%@/follow",H5BaseUrl]];
    self.noticeVC = noticeVC;
    SLNavigationController *noticeNavi = [self createRootNavi];
    noticeNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"关注" image:[UIImage imageNamed:@"notice_unsel"] selectedImage:[UIImage imageNamed:@"notice_selected"]];
    noticeNavi.viewControllers = @[noticeVC];
    noticeVC.navigationController.navigationBar.hidden = YES;

//    HomeViewController *recordVC = [[HomeViewController alloc] init];
//    UINavigationController *recordNavi = [self createRootNavi];

    SLWebViewController *recordVC = [[SLWebViewController alloc] init];
    [recordVC startLoadRequestWithUrl:[NSString stringWithFormat:@"%@/record",H5BaseUrl]];
    self.recordVC = recordVC;
    SLNavigationController *recordNavi = [self createRootNavi];
    recordNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"记录" image:[UIImage imageNamed:@"record_unsel"] selectedImage:[UIImage imageNamed:@"record_selected"]];
    recordNavi.viewControllers = @[recordVC];
    recordVC.navigationController.navigationBar.hidden = YES;

//    SLMineViewController *userVC = [[SLMineViewController alloc] init];
    
    SLWebViewController *userVC = [[SLWebViewController alloc] init];
    [userVC startLoadRequestWithUrl:[NSString stringWithFormat:@"%@/my",H5BaseUrl]];
    self.mineVC = userVC;
    SLNavigationController *userNavi = [self createRootNavi];
    userNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"mine_unsel"] selectedImage:[UIImage imageNamed:@"mine_selected"]];
    userNavi.viewControllers = @[userVC];
    userVC.navigationController.navigationBar.hidden = YES;

    self.viewControllers = @[homeNavi,noticeNavi,recordNavi,userNavi];
}

- (SLNavigationController *)createRootNavi{
    SLNavigationController *navi = [[SLNavigationController alloc] init];
    return navi;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if ([viewController isEqual:self.homeNavi]) {
        return YES;
    } else {
        if (![SLUser defaultUser].isLogin) {
            [self jumpToLogin];
            return NO;
        }
        if ([viewController isEqual:self.noticeVC]) {
            [self.noticeVC startLoadRequestWithUrl:[NSString stringWithFormat:@"%@/follow",H5BaseUrl]];
        } else if ([viewController isEqual:self.recordVC]) {
            [self.recordVC startLoadRequestWithUrl:[NSString stringWithFormat:@"%@/record",H5BaseUrl]];
        } else if ([viewController isEqual:self.mineVC]) {
            [self.mineVC startLoadRequestWithUrl:[NSString stringWithFormat:@"%@/my",H5BaseUrl]];
        }
    }
    return YES;
}


- (void)jumpToLogin {
    SLWebViewController *dvc = [[SLWebViewController alloc] init];
    [dvc startLoadRequestWithUrl:[NSString stringWithFormat:@"%@/login",H5BaseUrl]];
    UINavigationController *currentNav = self.selectedViewController;
    dvc.hidesBottomBarWhenPushed = YES;
    dvc.isLoginPage = YES;
    [currentNav presentViewController:dvc animated:YES completion:nil];
//    [currentNav pushViewController:dvc animated:YES];
}

@end

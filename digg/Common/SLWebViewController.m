//
//  SLWebViewController.m
//  digg
//
//  Created by hey on 2024/10/10.
//

#import "SLWebViewController.h"
#import <Masonry/Masonry.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WKWebViewConfiguration.h>
#import <WebKit/WKPreferences.h>
#import "SLGeneralMacro.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "SLGeneralMacro.h"
#import "SLUser.h"

@interface SLWebViewController ()<UIWebViewDelegate,WKScriptMessageHandler,WKNavigationDelegate>
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *wkwebView;
@property (nonatomic, assign) BOOL isSetUA;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) UIProgressView* progressView;

@end

@implementation SLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.wkwebView];

    if (self.isShowProgress) {
//        self.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
//        self.navigationController.navigationBar.hidden = NO;
        [self.wkwebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.view addSubview:self.progressView];
        [self.wkwebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
        }];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
            make.height.equalTo(@2);
        }];
    } else {
        self.navigationController.navigationBar.hidden = YES;
        [self.wkwebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    [self setupDefailUA];
    
    if (self.navigationController.interactivePopGestureRecognizer != nil) {
        [self.wkwebView.scrollView.panGestureRecognizer shouldRequireFailureOfGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isShowProgress) {
        self.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isShowProgress) {
        self.navigationController.navigationBar.barTintColor = nil;
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (void)dealloc {
    [self.bridge setWebViewDelegate:nil];
    if ([self isViewLoaded]) {
        [self.wkwebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }

    // if you have set either WKWebView delegate also set these to nil here
    [self.wkwebView setNavigationDelegate:nil];
    [self.wkwebView setUIDelegate:nil];
}

- (void)reload {
    [self.wkwebView reload];
}

- (void)backTo:(BOOL)rootVC {
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) { //push方式
            if (rootVC) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else { //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)jsBridgeMethod {
    @weakobj(self);
    [self.bridge registerHandler:@"backToHomePage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"backToHomePage: %@", data);
        [self backTo:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 0;
        responseCallback(data);
    }];
    
    [self.bridge registerHandler:@"userLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"userLogin called with: %@", data);

        NSString *userId = [NSString stringWithFormat:@"%@",[data objectForKey:@"userId"]];
        NSString *token = [NSString stringWithFormat:@"%@",[data objectForKey:@"token"]];
        SLUserEntity *entity = [[SLUserEntity alloc] init];
        entity.token = token;
        entity.userId = userId;
        [[SLUser defaultUser] saveUserInfo:entity];
        if (self.loginSucessCallback) {
            self.loginSucessCallback();
        }
        responseCallback(data);
        
        [self backTo:NO];
    }];
    
    [self.bridge registerHandler:@"userLogout" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"userLogout with: %@", data);
        [[SLUser defaultUser] clearUserInfo];
        responseCallback(data);
    }];

    [self.bridge registerHandler:@"page_back" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"page_back = %@",data);
        @strongobj(self);
        [self backTo:NO];
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.bridge registerHandler:@"jumpToH5" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"jumpToH5 called with: %@", data);
        if ([data isKindOfClass:[NSDictionary class]]) {
            @strongobj(self);
            if (self.isLoginPage) {
                [self.navigationController popViewControllerAnimated:NO];
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic = (NSDictionary *)data;
                NSString *url = [dic objectForKey:@"url"];
                NSString* type = [dic objectForKey:@"pageType"];
                BOOL isJumpToLogin = [type isEqualToString:@"login"];
                BOOL isOuterUrl = [type isEqualToString:@"outer"];
                SLWebViewController *dvc = [[SLWebViewController alloc] init];
                [dvc startLoadRequestWithUrl:url];
                if (isOuterUrl) {
                    dvc.isShowProgress = YES;
                }
                dvc.hidesBottomBarWhenPushed = YES;
                if (isJumpToLogin) {
                    [self.navigationController presentViewController:dvc animated:YES completion:nil];
                } else {
                    [self.navigationController pushViewController:dvc animated:YES];
                }
            });
        }
        responseCallback(data);
    }];
    
    [self.bridge registerHandler:@"closeH5" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"closeH5 called with: %@", data);
        @strongobj(self);
        [self backTo:YES];
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    
//    [self.bridge callHandler:@"JS Echo" data:nil responseCallback:^(id responseData) {
//        NSLog(@"ObjC received response: %@", responseData);
//    }];
}
- (void)setupDefailUA{
    if (self.isSetUA) {
        return;
    }
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.wkwebView];
    [self.bridge setWebViewDelegate:self];
    [self jsBridgeMethod];
    
    NSString *defaultUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"digg_default_userAgent"];
    if (stringIsEmpty(defaultUserAgent)) {
        NSString *model = [UIDevice currentDevice].model;
        NSString *systemVersion = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        defaultUserAgent = [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU iPhone OS %@ like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16B92", model, systemVersion];
    };
    NSString *modifiedUserAgent = [NSString stringWithFormat:@"%@ infoflow", defaultUserAgent];
    NSLog(@"设置 ua = %@",modifiedUserAgent);
    self.wkwebView.customUserAgent = modifiedUserAgent;
    self.isSetUA = YES;
}

- (void)startLoadRequestWithUrl:(NSString *)url{
    if(stringIsEmpty(url)){
        NSLog(@"url为空");
        @weakobj(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"url 为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongobj(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];

        
        return;
    }
    [self setupDefailUA];
    self.requestUrl = url;
    NSLog(@"加载的url = %@",url);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [self.wkwebView loadRequest:request];
}

- (WKWebView *)wkwebView{
    if (!_wkwebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        configuration.allowsInlineMediaPlayback = YES;
        
        
        _wkwebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _wkwebView.backgroundColor = [UIColor whiteColor];
        _wkwebView.scrollView.bounces = NO;
        _wkwebView.navigationDelegate = self;
        _wkwebView.allowsBackForwardNavigationGestures = YES;
        [_wkwebView.scrollView.panGestureRecognizer setEnabled:YES];
    }
    return _wkwebView;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"js bridge message =%@",message.name);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.isShowProgress) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            self.progressView.progress = self.wkwebView.estimatedProgress;
            if (self.wkwebView.estimatedProgress >= 1.0) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.progressView.alpha = 0.0;
                }];
            } else {
                self.progressView.alpha = 1.0;
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

#pragma makr - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.isShowProgress) {
        @weakobj(self);
        [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError* _Nullable error) {
            if (!error && [title length] > 0) {
                @strongobj(self);
                self.title = title;
            }
        }];
    }
}

@end

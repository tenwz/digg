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

@end

@implementation SLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.wkwebView];
    
    [self setupDefailUA];
    [self setupNavigationBarConfig];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.wkwebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setupNavigationBarConfig {
    UIImage *image = [UIImage imageNamed:@"navbar_back_icon"];
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [customButton setImage:image forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jsBridgeMethod{
    @weakobj(self);
    [self.bridge registerHandler:@"backToHomePage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"backToHomePage: %@", data);
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 0;
        responseCallback(data);
    }];
    
    [self.bridge registerHandler:@"userLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"userLogin called with: %@", data);
        if (self.loginSucessCallback) {
            self.loginSucessCallback();
        }
        NSString *userId = [NSString stringWithFormat:@"%@",[data objectForKey:@"userId"]];
        NSString *token = [NSString stringWithFormat:@"%@",[data objectForKey:@"token"]];
        SLUserEntity *entity = [[SLUserEntity alloc] init];
        entity.token = token;
        entity.userId = userId;
        [[SLUser defaultUser] saveUserInfo:entity];
        responseCallback(data);
    }];
    
    [self.bridge registerHandler:@"userLogout" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"userLogout with: %@", data);
        [[SLUser defaultUser] clearUserInfo];
        responseCallback(data);
    }];

    [self.bridge registerHandler:@"page_back" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"page_back = %@",data);
        @strongobj(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.bridge registerHandler:@"jumpToH5" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"jumpToH5 called with: %@", data);
        if ([data isKindOfClass:[NSDictionary class]]) {
            @strongobj(self);
            NSDictionary *dic = (NSDictionary *)data;
            NSString *url = [dic objectForKey:@"url"];
            SLWebViewController *dvc = [[SLWebViewController alloc] init];
            [dvc startLoadRequestWithUrl:url];
            dvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dvc animated:YES];
        }
        responseCallback(data);
    }];
    
    [self.bridge registerHandler:@"closeH5" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"closeH5 called with: %@", data);
        @strongobj(self);
        [self.navigationController popViewControllerAnimated:YES];
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
    }
    return _wkwebView;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"js bridge message =%@",message.name);
}

#pragma makr - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError* _Nullable error) {
        if (!error) {
            weakSelf.title = title;
        }
    }];
}

@end

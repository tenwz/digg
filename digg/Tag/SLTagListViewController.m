//
//  SLTagListViewController.m
//  digg
//
//  Created by Tim Bao on 2025/1/12.
//

#import "SLTagListViewController.h"
#import "SLTagListContainerViewModel.h"
#import "SLProfileDynamicTableViewCell.h"
#import "Masonry.h"
#import "CaocaoRefresh.h"
#import "SLGeneralMacro.h"
#import "SLHomePageViewModel.h"
#import "SLUser.h"
#import "SLWebViewController.h"
#import "SLAlertManager.h"

@interface SLTagListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SLTagListContainerViewModel *viewModel;
@property (nonatomic, strong) SLHomePageViewModel *homeViewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SLTagListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addRefresh];
    [self loadMessagesList:CaocaoCarMessageListRefreshTypeRefresh];
}

- (void)changeBgColor {
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)dataLoadActionCallback {
    //刷新
    [self loadMessagesList:CaocaoCarMessageListRefreshTypeRefresh];
}

- (UIView *)listView {
    [self changeBgColor];
    return self.view;
}

- (void)addRefresh {
    @weakobj(self);
    self.tableView.mj_header = [CaocaoRefreshHeader headerWithRefreshingBlock:^{
        @strongobj(self);
        [self loadMessagesList:CaocaoCarMessageListRefreshTypeRefresh];
    }];
    
    self.tableView.mj_footer = [CaocaoRefreshFooter footerWithRefreshingBlock:^{
        @strongobj(self);
        [self loadMessagesList:CaocaoCarMessageListRefreshTypeLoadMore];
    }];
}

- (void)setView:(UIView *)view{
    [super setView:view];
}

- (void)loadMessagesList:(CaocaoCarMessageListRefreshType)type {
    @weakobj(self);
    [self.viewModel loadMessageListWithRefreshType:type withPageStyle:self.index withLabel:self.label resultHandler:^(BOOL isSuccess, NSError *error) {
        @strongobj(self);
        if (isSuccess) {
            if ([self.viewModel.dataArray count] == 0) {
                self.dataState = CaocaoDataLoadStateEmpty;
            } else {
                self.dataState = CaocaoDataLoadStateNormal;
            }
        } else {
            self.dataState = CaocaoDataLoadStateError;
        }
        [self.tableView reloadData];
        [self endRefresh];
    }];
}

- (void)endRefresh
{
    if (self.viewModel.hasToEnd) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - SLEmptyWithLoginButtonViewDelegate
- (void)gotoLoginPage {
    SLWebViewController *dvc = [[SLWebViewController alloc] init];
    [dvc startLoadRequestWithUrl:[NSString stringWithFormat:@"%@/login", H5BaseUrl]];
    dvc.hidesBottomBarWhenPushed = YES;
    dvc.isLoginPage = YES;
//    @weakobj(self)
//    dvc.loginSucessCallback = ^{
//        @strongobj(self)
//    };
    [self presentViewController:dvc animated:YES completion:nil];
}

- (void)jumpToH5WithUrl:(NSString *)url andShowProgress:(BOOL)show {
    SLWebViewController *dvc = [[SLWebViewController alloc] init];
    dvc.isShowProgress = show;
    [dvc startLoadRequestWithUrl:url];
    dvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SLArticleTodayEntity *entity = self.viewModel.dataArray[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@/post/%@", H5BaseUrl, entity.articleId];
    [self jumpToH5WithUrl:url andShowProgress:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLProfileDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLProfileDynamicTableViewCell" forIndexPath:indexPath];
    if (cell) {
        SLArticleTodayEntity *entity = [self.viewModel.dataArray objectAtIndex:indexPath.row];
        [cell updateWithEntity:entity];
        @weakobj(self);
        cell.likeClick = ^(SLArticleTodayEntity *entity) {
            @strongobj(self);
            if (![SLUser defaultUser].isLogin) {
                [self gotoLoginPage];
                return;
            }
            [self.homeViewModel likeWith:entity.articleId resultHandler:^(BOOL isSuccess, NSError *error) {
                
            }];
        };
        
        cell.dislikeClick = ^(SLArticleTodayEntity *entity) {
            @strongobj(self);
            if (![SLUser defaultUser].isLogin) {
                [self gotoLoginPage];
                return;
            }
            [self.homeViewModel dislikeWith:entity.articleId resultHandler:^(BOOL isSuccess, NSError *error) {
                
            }];
        };
        
        cell.checkDetailClick = ^(SLArticleTodayEntity *entity) {
            @strongobj(self);
            [SLAlertManager showAlertWithTitle:@"提示"
                                       message:@"您确定要打开此链接吗？"
                                           url:[NSURL URLWithString:entity.url]
                                       urlText:entity.url
                                  confirmTitle:@"是"
                                   cancelTitle:@"否"
                                confirmHandler:^{
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:entity.url] options:@{} completionHandler:nil];
                                }
                                 cancelHandler:^{
                                }
                             fromViewController:self];
//            [self jumpToH5WithUrl:entity.url andShowProgress:YES];
        };
        
        cell.cancelLikeClick = ^(SLArticleTodayEntity *entity) {
            @strongobj(self);
            if (![SLUser defaultUser].isLogin) {
                [self gotoLoginPage];
                return;
            }
            [self.homeViewModel cancelLikeWith:entity.articleId resultHandler:^(BOOL isSuccess, NSError *error) {
                
            }];
        };
        cell.cancelDisLikeClick = ^(SLArticleTodayEntity *entity) {
            @strongobj(self);
            if (![SLUser defaultUser].isLogin) {
                [self gotoLoginPage];
                return;
            }
            [self.homeViewModel cancelLikeWith:entity.articleId resultHandler:^(BOOL isSuccess, NSError *error) {
                
            }];
        };
    }
    return cell;
}

#pragma mark - UI Elements
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SLProfileDynamicTableViewCell class] forCellReuseIdentifier:@"SLProfileDynamicTableViewCell"];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}


- (SLTagListContainerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SLTagListContainerViewModel alloc] init];
    }
    return _viewModel;
}

- (SLHomePageViewModel *)homeViewModel {
    if (!_homeViewModel) {
        _homeViewModel = [[SLHomePageViewModel alloc] init];
    }
    return _homeViewModel;
}

@end

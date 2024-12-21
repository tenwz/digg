//
//  SLFollowingListViewController.m
//  digg
//
//  Created by hey on 2024/10/6.
//

#import "SLFollowingListViewController.h"
#import <Masonry/Masonry.h>
#import <Masonry/Masonry.h>
#import "CaocaoRefresh.h"
#import "SLGeneralMacro.h"
#import "SLFollowingListItemCell.h"

#define kSLFollowingListItemCellID @"SLFollowingListItemCell"

@interface SLFollowingListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SLFollowingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addRefresh];
    
//    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [loginBtn setTitle:@"login" forState:UIControlStateNormal];
//    [loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:loginBtn];
//    
//    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(100, 40));
//    }];
}

//- (void)loginBtnAction:(id)sender{
////    UINavigationController *navi = [[UINavigationController alloc] init];
////    SLLoginViewController *dvc = [[SLLoginViewController alloc] init];
////    navi.viewControllers = @[dvc];
//    
//    UINavigationController *navi = [[UINavigationController alloc] init];
//    SLPublishViewController *dvc = [[SLPublishViewController alloc] init];
//    navi.modalPresentationStyle = UIModalPresentationFullScreen;
//    navi.viewControllers = @[dvc];
//    
//    [self presentViewController:navi animated:YES completion:nil];
//}

- (void)addRefresh{
    @weakobj(self);
    self.tableView.mj_header = [CaocaoRefreshHeader headerWithRefreshingBlock:^{
        @strongobj(self);
        [self loadMessagesList];
    }];
    
    self.tableView.mj_footer = [CaocaoRefreshFooter footerWithRefreshingBlock:^{
        @strongobj(self);
        [self loadMessagesList];
    }];
}

- (void)loadMessagesList{
    [self endRefresh];
}

- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];

//    if (self.viewModel.hasToEnd) {
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    } else {
//        [self.tableView.mj_footer endRefreshing];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLFollowingListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kSLFollowingListItemCellID forIndexPath:indexPath];
    if (cell) {
        [cell updateWithEntity:nil];
    }
    return cell;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SLFollowingListItemCell class] forCellReuseIdentifier:kSLFollowingListItemCellID];
    }
    return _tableView;
}

@end

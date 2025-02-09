//
//  SLProfileViewController.m
//  digg
//
//  Created by Tim Bao on 2025/1/5.
//

#import "SLProfileViewController.h"
#import "SLProfileHeaderView.h"
#import "Masonry.h"
#import "SLSegmentControl.h"
#import "SLGeneralMacro.h"
#import "SLHomePageNewsTableViewCell.h"
#import "SLEmptyWithLoginButtonView.h"
#import "SLWebViewController.h"
#import "EnvConfigHeader.h"
#import "SLUser.h"
#import "SLProfilePageViewModel.h"
#import "SDWebImage.h"
#import "SLProfileEntity.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "SLHomePageViewModel.h"
#import "SLEditProfileViewController.h"
#import "KxMenu.h"
#import "SVProgressHUD.h"
#import "SLProfileDynamicTableViewCell.h"
#import "SLTagListContainerViewController.h"
#import "digg-Swift.h"
#import "SLColorManager.h"


@interface SLProfileViewController () <SLSegmentControlDelegate, UITableViewDelegate, UITableViewDataSource, SLEmptyWithLoginButtonViewDelegate, UIScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, SLEmptyWithLoginButtonViewDelegate, SLProfileHeaderViewDelegate>

@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;

@property (nonatomic, strong) UIButton* leftBackButton;
@property (nonatomic, strong) UIButton* moreButton;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* briefLabel;
@property (nonatomic, strong) SLProfileHeaderView* headerView;

@property (nonatomic, strong) SLSegmentControl* segmentControl;
@property (nonatomic, strong) UIView* line;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *hideView;

@property (nonatomic, strong) SLEmptyWithLoginButtonView* emptyView;

@property (nonatomic, strong) SLProfilePageViewModel *viewModel;
@property (nonatomic, strong) SLHomePageViewModel *homeViewModel;

@end

@implementation SLProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [SLColorManager primaryBackgroundColor];
    [self setupUI];
    [self.hideView setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakobj(self)
    [self.viewModel isUserLogin:^(BOOL isLogin, NSError * _Nonnull error) {
        @strongobj(self)
        self.tableView.backgroundColor = UIColor.clearColor;
//        [self.view hideSkeleton];
        if (isLogin) {
            if ([self.userId length] == 0) {
                self.userId = [SLUser defaultUser].userEntity.userId;
            }
            [self updateUI];
        } else {
            [self.hideView setHidden:YES];
            [self.emptyView setHidden:NO];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.backgroundColor = UIColor.whiteColor;
}

- (void)updateUI {
    [self.hideView setHidden:YES];
    if (self.userId.length == 0) {
        [self.emptyView setHidden:NO];
    } else {
        [self.emptyView setHidden:YES];
        
        @weakobj(self);
        [self.viewModel loadUserProfileWithProfileID:self.userId resultHandler:^(BOOL isSuccess, NSError * _Nonnull error) {
            @strongobj(self)
            if (isSuccess) {
                if ([self.viewModel.entity.bgImage length] > 0) {
                    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.entity.bgImage] placeholderImage:[UIImage imageNamed:@"profile_header_bg"]];
                }
                self.nameLabel.text = self.viewModel.entity.userName;
                self.briefLabel.text = self.viewModel.entity.desc;
                if (self.viewModel.entity.isSelf && !self.fromWeb) {
                    [self.leftBackButton setHidden:YES];
                    [self.moreButton setHidden:NO];
                    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.headerImageView).offset(16);
                        make.top.equalTo(self.headerImageView).offset(52);
                        make.right.equalTo(self.moreButton.mas_left).offset(-12);
                    }];
                } else {
                    [self.leftBackButton setHidden:NO];
                    [self.moreButton setHidden:YES];
                    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.leftBackButton.mas_right).offset(12);
                        make.bottom.equalTo(self.leftBackButton.mas_centerY);
                        make.right.equalTo(self.moreButton.mas_left).offset(-12);
                    }];
                }
                self.headerView.entity = self.viewModel.entity;
                [self.tableView reloadData];
                
                [self updateTableHeaderViewHeight];
            }
        }];
    }
}

- (void)updateTableHeaderViewHeight {
    [self.headerView updateConstraintsIfNeeded];
    [self.headerView setNeedsLayout];
    [self.headerView layoutIfNeeded];
    
    CGFloat height = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = self.headerView.frame;
    frame.size.height = height;
    self.headerView.frame = frame;
    self.headerImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
    self.blurEffectView.frame = self.headerImageView.bounds;
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - Setup UI
- (void)setupUI {
    self.headerImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300);
    [self.view addSubview:self.headerImageView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurEffectView.frame = self.headerImageView.bounds;
    self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.blurEffectView.alpha = 0;
    [self.headerImageView addSubview:self.blurEffectView];
    
    [self.headerImageView addSubview:self.leftBackButton];
    [self.leftBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView).offset(16);
        make.top.equalTo(self.headerImageView).offset(52);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [self.headerImageView addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftBackButton);
        make.right.equalTo(self.headerImageView).offset(-16);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [self.headerImageView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBackButton.mas_right).offset(12);
        make.bottom.equalTo(self.leftBackButton.mas_centerY);
        make.right.equalTo(self.moreButton.mas_left).offset(-12);
    }];
    
    [self.headerImageView addSubview:self.briefLabel];
    [self.briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(98);
        make.left.right.equalTo(self.view);
        if (self.fromWeb) {
            make.bottom.equalTo(self.view);
        } else {
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        }
    }];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
    }];
    [self updateTableHeaderViewHeight];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    [self.view addSubview:self.hideView];
    [self.hideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tableView).offset(120);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - Actions
- (void)backPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMenu {
    KxMenu.titleFont = [UIFont systemFontOfSize:18];
    [KxMenu showMenuInView:self.view
                  fromRect:_moreButton.frame
                 menuItems:@[
                    [KxMenuItem menuItem:@"退出登录"
                        image:[UIImage imageNamed:@"logout_icon"]
                       target:self
                       action:@selector(logoutAction)],
                ]];
}

- (void)logoutAction {
    [SVProgressHUD show];
    @weakobj(self)
    [self.viewModel logout:^(BOOL success, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (success) {
            @strongobj(self)
            self.userId = @"";
            [self updateUI];
        }
    }];
}

#pragma mark - SLSegmentControlDelegate
- (void)segmentControl:(SLSegmentControl *)segmentControl didSelectIndex:(NSInteger)index {
    [self.tableView reloadData];
}

#pragma mark - SLEmptyWithLoginButtonViewDelegate
- (void)gotoLoginPage {
    SLWebViewController *dvc = [[SLWebViewController alloc] init];
    [dvc startLoadRequestWithUrl:[NSString stringWithFormat:@"%@/login", H5BaseUrl]];
    dvc.hidesBottomBarWhenPushed = YES;
    dvc.isLoginPage = YES;
    @weakobj(self)
    dvc.loginSucessCallback = ^{
        @strongobj(self)
        self.userId = [SLUser defaultUser].userEntity.userId;
        NSLog(@"userid = %@", self.userId);
        [self updateUI];
    };
    [self presentViewController:dvc animated:YES completion:nil];
}

- (void)jumpToH5WithUrl:(NSString *)url andShowProgress:(BOOL)show {
    SLWebViewController *dvc = [[SLWebViewController alloc] init];
    dvc.isShowProgress = show;
    [dvc startLoadRequestWithUrl:url];
    dvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
        
    CGFloat alpha = MAX(0, MIN(1, contentOffset.y / 100));
    self.nameLabel.alpha = alpha;
    self.briefLabel.alpha = alpha;
    self.blurEffectView.alpha = alpha;
    // 设置头像的变换
    CGFloat headerHeight = self.headerView.frame.size.height;
    CGFloat avatarSize = 60;
    CGFloat minAvatarSize = 30;

    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 限制最大偏移
    CGFloat avatarInitialSize = avatarSize;
    CGFloat avatarFinalSize = minAvatarSize;
    
    // 计算缩放比例
    CGFloat scaleFactor = MAX(avatarFinalSize / avatarInitialSize, 1 - offsetY / 100);
    if (scaleFactor > 1.0) {
        scaleFactor = 1.0;
    }
    
    // 应用缩放和位置变化
    self.headerView.avatarImageView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    
    // 限制 header 的压缩高度
    if (offsetY > 0) {
        self.headerView.frame = CGRectMake(0, -offsetY, self.view.bounds.size.width, headerHeight);
    }
}

#pragma mark - SLProfileHeaderViewDelegate
- (void)gotoEditPersonalInfo {
    SLEditProfileViewController* vc = [SLEditProfileViewController new];
    vc.entity = self.viewModel.entity;
    @weakobj(self)
    vc.updateSucessCallback = ^{
        @strongobj(self)
        [self updateUI];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)follow:(BOOL)cancel {
    [SVProgressHUD show];
    @weakobj(self)
    [self.viewModel followWithUserID:self.userId cancel:cancel resultHandler:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            @strongobj(self)
            self.viewModel.entity.hasFollow = cancel;
            self.headerView.entity = self.viewModel.entity;
        }
    }];
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SLArticleTodayEntity *entity;
    if (self.segmentControl.selectedIndex == 0) {
        entity = [self.viewModel.entity.feedList objectAtIndex:indexPath.row];
    } else if (self.segmentControl.selectedIndex == 1) {
        entity = [self.viewModel.entity.likeList objectAtIndex:indexPath.row];
    } else if (self.segmentControl.selectedIndex == 2) {
        entity = [self.viewModel.entity.submitList objectAtIndex:indexPath.row];
    }
    NSString *url = [NSString stringWithFormat:@"%@/post/%@", H5BaseUrl, entity.articleId];
    [self jumpToH5WithUrl:url andShowProgress:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentControl.selectedIndex == 0) {
        return self.viewModel.entity.feedList.count;
    } else if (self.segmentControl.selectedIndex == 1) {
        return self.viewModel.entity.likeList.count;
    } else if (self.segmentControl.selectedIndex == 2) {
        return self.viewModel.entity.submitList.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 41)];
    sectionView.backgroundColor = [SLColorManager primaryBackgroundColor];
    [sectionView addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView);
        make.left.equalTo(sectionView).offset(50);
        make.right.equalTo(sectionView).offset(-50);
        make.height.mas_equalTo(40);
    }];
    
    [sectionView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.mas_bottom);
        make.left.right.equalTo(sectionView);
        make.height.mas_equalTo(1);
    }];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentControl.selectedIndex == 0) {
        SLProfileDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLProfileDynamicTableViewCell" forIndexPath:indexPath];
        if (cell) {
            SLArticleTodayEntity *entity = [self.viewModel.entity.feedList objectAtIndex:indexPath.row];
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
                [self jumpToH5WithUrl:entity.url andShowProgress:YES];
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
    } else {
        SLHomePageNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLHomePageNewsTableViewCell" forIndexPath:indexPath];
        if (cell) {
            SLArticleTodayEntity *entity;
            if (self.segmentControl.selectedIndex == 1) {
                entity = [self.viewModel.entity.likeList objectAtIndex:indexPath.row];
            } else if (self.segmentControl.selectedIndex == 2) {
                entity = [self.viewModel.entity.submitList objectAtIndex:indexPath.row];
            }
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
                [self jumpToH5WithUrl:entity.url andShowProgress:YES];
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
            cell.labelClick = ^(SLArticleTodayEntity *entity) {
                if (entity.label.length > 0) {
                    @strongobj(self);
                    SLTagListContainerViewController* vc = [SLTagListContainerViewController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.label = entity.label;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            };
        }
        return cell;
    }
    return [UITableViewCell new];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有内容";
    
    NSDictionary *attributes = @{
                              NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                              NSForegroundColorAttributeName: Color16(0xC6C6C6)
                             };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 98.0/2.0;
}

#pragma makr - UI Elements
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_header_bg"]];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerImageView setUserInteractionEnabled:YES];
        _headerImageView.isSkeletonable = YES;
    }
    return _headerImageView;
}

- (UIButton *)leftBackButton {
    if (!_leftBackButton) {
        _leftBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBackButton setImage:[UIImage imageNamed:@"profile_left_btn"] forState:UIControlStateNormal];
        [_leftBackButton addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
        _leftBackButton.isSkeletonable = YES;
    }
    return _leftBackButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"profile_more_btn"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.isSkeletonable = YES;
    }
    return _moreButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.alpha = 0;
    }
    return _nameLabel;
}

- (UILabel *)briefLabel {
    if (!_briefLabel) {
        _briefLabel = [[UILabel alloc] init];
        _briefLabel.text = @"";
        _briefLabel.textColor = UIColor.whiteColor;
        _briefLabel.font = [UIFont systemFontOfSize:12];
        _briefLabel.alpha = 0;
    }
    return _briefLabel;
}

- (SLProfileHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[SLProfileHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (SLSegmentControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[SLSegmentControl alloc] initWithFrame:CGRectZero];
        _segmentControl.titles = @[@"动态", @"赞同", @"收藏"];
        _segmentControl.delegate = self; // 设置代理为当前控制器
        _segmentControl.isSkeletonable = YES;
    }
    return _segmentControl;
}

- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [SLColorManager cellDivideLineColor];
    }
    return _line;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [SLColorManager primaryBackgroundColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SLHomePageNewsTableViewCell class] forCellReuseIdentifier:@"SLHomePageNewsTableViewCell"];
        [_tableView registerClass:[SLProfileDynamicTableViewCell class] forCellReuseIdentifier:@"SLProfileDynamicTableViewCell"];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.estimatedRowHeight = 100;
        _tableView.sectionHeaderHeight = 51;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;

        _tableView.isSkeletonable = YES;
    }
    return _tableView;
}

- (SLEmptyWithLoginButtonView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SLEmptyWithLoginButtonView alloc] initWithFrame:CGRectZero];
        _emptyView.backgroundColor = [SLColorManager primaryBackgroundColor];
        _emptyView.delegate = self;
        [_emptyView setHidden:YES];
    }
    return _emptyView;
}

- (SLProfilePageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SLProfilePageViewModel alloc] init];
    }
    return _viewModel;
}

- (SLHomePageViewModel *)homeViewModel {
    if (!_homeViewModel) {
        _homeViewModel = [[SLHomePageViewModel alloc] init];
    }
    return _homeViewModel;
}

- (UIView *)hideView {
    if (!_hideView) {
        _hideView = [[UIView alloc] initWithFrame:CGRectZero];
        _hideView.backgroundColor = [SLColorManager primaryBackgroundColor];
    }
    return _hideView;
}

@end

//
//  SLHomePageViewController.m
//  digg
//
//  Created by hey on 2024/9/24.
//

#import "SLHomePageViewController.h"
#import "SLGeneralMacro.h"
#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
#import "SLHomepageNewsViewController.h"
#import "UIView+CommonKit.h"
#import "SLHomeWebViewController.h"
#import "SLHomePageViewModel.h"

@interface SLHomePageViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) JXCategoryNumberView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, assign) BOOL isNeedIndicatorPositionChangeItem;
@property (nonatomic, strong) JXCategoryNumberView *myCategoryView;
@property (nonatomic, strong) NSMutableDictionary <NSString *, id<JXCategoryListContentViewDelegate>> *listCache;
@property (nonatomic, strong) SLHomePageViewModel *viewModel;

@end

@implementation SLHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.listContainerView];
    self.titles = @[@"今天", @"发现", @"为你"];

    CGFloat categoryViewHeight = 44;
    self.categoryView.frame = CGRectMake(0, STATUSBAR_HEIGHT, self.view.bounds.size.width-categoryViewHeight, categoryViewHeight);
    self.searchBtn.frame = CGRectMake(self.view.bounds.size.width - 24 - 16, STATUSBAR_HEIGHT+9, 24, 24);
    self.listContainerView.frame = CGRectMake(0, categoryViewHeight+STATUSBAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height-(categoryViewHeight+STATUSBAR_HEIGHT)-self.tabBarController.tabBar.frame.size.height);
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.counts = @[@0, @0, @0];
    self.myCategoryView.numberLabelOffset = CGPointMake(-2, 5);
    self.myCategoryView.numberStringFormatterBlock = ^NSString *(NSInteger number) {
        if (number > 99) {
            return @"99+";
        }
        return [NSString stringWithFormat:@"%ld", (long)number];
    };
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = Color16(0xFF1852);
    lineView.indicatorWidth = 28;
    self.myCategoryView.indicators = @[lineView];
    
    @weakobj(self);
    [self.viewModel getForYouRedPoint:^(NSInteger number, NSError *error) {
        if (!error) {
            @strongobj(self);
            self.myCategoryView.counts = @[@0, @0, @(number)];
        }
    }];
}

- (void)searchBtnAction:(id)sender{
    SLWebViewController *web = [[SLWebViewController alloc] init];
    [web startLoadRequestWithUrl:@"http://39.106.147.0/post/31516"];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (JXCategoryNumberView *)myCategoryView {
    return (JXCategoryNumberView *)self.categoryView;
}

- (JXCategoryNumberView *)preferredCategoryView {
    return [[JXCategoryNumberView alloc] init];
}

#pragma mark - JXCategoryViewDelegate

// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
//    if (index == HomePageSyleProduct) {
//        self.view.backgroundColor = Color16(0xF7F7F7);
//    }else{
//        self.view.backgroundColor = [UIColor whiteColor];
//    }
    
    self.view.backgroundColor = [UIColor whiteColor];

}

// 滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    if (index == 2) {
        self.myCategoryView.counts = @[@0, @0, @0];
    }
    
}

#pragma mark - JXCategoryListContainerViewDelegate

// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

// 返回各个列表菜单下的实例，该实例需要遵守并实现 <JXCategoryListContentViewDelegate> 协议
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
//    SLHomePageNewsViewController *list = [[SLHomePageNewsViewController alloc] init];
//    list.pageStyle = index;
    
    NSString *targetTitle = self.titles[index];
    id<JXCategoryListContentViewDelegate> list = _listCache[targetTitle];
    if (list) {
        //②之前已经初始化了对应的list，就直接返回缓存的list，无需再次初始化
        return list;
    }else {
        UIViewController *dvc;
        if (index == 0) {
            SLHomePageNewsViewController *listVC = [[SLHomePageNewsViewController alloc] init];
            listVC.pageStyle = index;
            //①自己缓存已经初始化的列表
            _listCache[targetTitle] = listVC;
            dvc = listVC;
        }else if (index == 1){
            SLHomeWebViewController *vc = [[SLHomeWebViewController alloc] init];
//            发现
            NSString *url = [NSString stringWithFormat:@"%@/home/recent",H5BaseUrl];
            [vc startLoadRequestWithUrl:url];
            dvc = vc;
        }else if (index == 2){
            SLHomeWebViewController *vc = [[SLHomeWebViewController alloc] init];
//            发现
            NSString *url = [NSString stringWithFormat:@"%@/home/forYou",H5BaseUrl];
            [vc startLoadRequestWithUrl:url];
            dvc = vc;
        }
        
        return dvc;
    }
}


// 分页菜单视图
- (JXCategoryBaseView *)categoryView {
    if (!_categoryView) {
        _categoryView = [self preferredCategoryView];
        _categoryView.numberBackgroundColor = UIColor.redColor;
        _categoryView.delegate = self;
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.titleFont = [UIFont boldSystemFontOfSize:18];
        _categoryView.titleLabelZoomScale = 1.125;
        _categoryView.titleSelectedColor = [UIColor blackColor];
        _categoryView.titleColor = Color16(0x7B7B7B);
        // !!!: 将列表容器视图关联到 categoryView
        _categoryView.listContainer = self.listContainerView;
        _categoryView.cellSpacing = 24;
        _categoryView.averageCellSpacingEnabled = NO;
    }
    return _categoryView;
}

// 列表容器视图
- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setImage:[UIImage imageNamed:@"notice"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (SLHomePageViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[SLHomePageViewModel alloc] init];
    }
    return _viewModel;
}

@end

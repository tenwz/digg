//
//  HomeViewController.m
//  JRTTDemo
//
//  Created by 赵 on 2018/1/29.
//  Copyright © 2018年 袁书辉. All rights reserved.
//


#import "TitleModel.h"
#import "HomeMenuCollectionViewCell.h"
#import "HomeMenuView.h"
#import <YYModel/YYModel.h>
#import "HomeViewController.h"
#import "TitleModel.h"
#import <Masonry/Masonry.h>
#import "CDViewController.h"
#import "SLGeneralMacro.h"
#import "SLHomeCategoryModel.h"
#import "SLHomePageNewsViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)  UIView *MenuBottomView;
@property (strong, nonatomic)  UIScrollView *scrollView;

@property (nonatomic,strong) HomeMenuView * menuView;

@property (nonatomic,assign) NSInteger selectedIdx;

@property (nonatomic,strong) NSMutableArray * titleArray;

@property (nonatomic,assign) BOOL isShou;
@end

@implementation HomeViewController
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray new];
    }
    return _titleArray;
}

-(HomeMenuView *)menuView
{
    if(!_menuView){
        __weak typeof(self) weakSelf = self;
        _menuView = [HomeMenuView getViewWithNibSelectedBlock:^(NSIndexPath *idxPath, NSMutableArray *dataArray) {
            weakSelf.isShou = NO;
            weakSelf.selectedIdx = idxPath.row;
            [weakSelf changeVC:idxPath.row];
        } cellIdentifer:@"HomeMenuCollectionViewCell"];
    }
    
    return _menuView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self setupDefaultData];
    [self.view addSubview:self.MenuBottomView];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.scrollView];
    
    [self.MenuBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(STATUSBAR_HEIGHT);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.MenuBottomView);
        make.left.equalTo(self.MenuBottomView);
        make.right.equalTo(self.MenuBottomView);
        make.bottom.equalTo(self.MenuBottomView).offset(-1);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.menuView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    

    [self updateVC];
    
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
}

- (void)setupDefaultData{
    SLHomeCategoryModel *today = [[SLHomeCategoryModel alloc] init];
    today.index = 0;
    today.categoryName = @"今天";
    
    SLHomeCategoryModel *zuixin = [[SLHomeCategoryModel alloc] init];
    zuixin.index = 1;
    zuixin.categoryName = @"最新";
    
    SLHomeCategoryModel *zuopin = [[SLHomeCategoryModel alloc] init];
    zuopin.index = 2;
    zuopin.categoryName = @"作品";
    
    SLHomeCategoryModel *taolun = [[SLHomeCategoryModel alloc] init];
    taolun.index = 3;
    taolun.categoryName = @"讨论";
    
    SLHomeCategoryModel *wenda = [[SLHomeCategoryModel alloc] init];
    wenda.index = 4;
    wenda.categoryName = @"问答";
    
    SLHomeCategoryModel *jinxuan = [[SLHomeCategoryModel alloc] init];
    jinxuan.index = 5;
    jinxuan.categoryName = @"精修";
    
    self.titleArray = [NSMutableArray arrayWithArray:@[today,zuixin,zuopin,taolun,wenda,jinxuan]];
}


-(void)updateVC
{
   [self.menuView.viewModel updateData:self.titleArray];
    //    跟视图控制器
    
    for (UIViewController * vc in self.childViewControllers) {
       
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    for (SLHomeCategoryModel *obj in self.titleArray) {
        SLHomePageNewsViewController * vc = [[SLHomePageNewsViewController alloc] init];
        vc.pageStyle = obj.index;
        [self addChildViewController:vc];
        
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*self.titleArray.count, self.scrollView.frame.size.height);
    [self changeVC:0];
}


-(void)changeVC:(NSInteger)idx
{
    CGFloat left = idx*kScreenWidth;
    [self.scrollView setContentOffset:CGPointMake(left, 0) animated:YES];
    
    [self addVC:idx];
}
-(void)addVC:(NSInteger)idx
{
    CGFloat left = idx*kScreenWidth;
    
    UIViewController * vc =  self.childViewControllers[idx];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(left, 0, kScreenWidth, self.scrollView.frame.size.height);
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:vc.view];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isShou = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isShou) {
        return;
        
    }
    //    scrollView
    
    CGFloat idx = scrollView.contentOffset.x/kScreenWidth;
    
    if (idx-self.selectedIdx>0&&idx-self.selectedIdx<1) {
        if (idx+1<=self.childViewControllers.count) {
            [self addVC:idx+1];
            CGFloat d =fabsf(idx-self.selectedIdx) ;
//            NSLog(@"====%f",d);
            HomeMenuCollectionViewCell * cell1 = [self getCellWithIdex:self.selectedIdx+1];
            HomeMenuCollectionViewCell * cell = [self getCellWithIdex:self.selectedIdx];
            
            [self fromCell:cell toCell1:cell1 d:d];
            
        }
        
    }else if (idx-self.selectedIdx<=0&&idx-self.selectedIdx>=-1){
        if (idx>=0) {
            [self addVC:idx];
            HomeMenuCollectionViewCell * cell1 = [self getCellWithIdex:self.selectedIdx-1];
            HomeMenuCollectionViewCell * cell = [self getCellWithIdex:self.selectedIdx];
            CGFloat d =fabsf(idx-self.selectedIdx) ;
            [self fromCell:cell toCell1:cell1 d:d];
        }
        
    }
}

-(void)fromCell:(HomeMenuCollectionViewCell*)cell toCell1:(HomeMenuCollectionViewCell*)cell1 d:(CGFloat)d
{
    cell.title.font = [UIFont systemFontOfSize:16+d];
//    cell1.title.textColor = RGB(34+d*(249-34),34+(118-34)*d,34+(118-34)*d);
    cell.title.textColor = Color16(0x7B7B7B);
    cell1.title.font = [UIFont systemFontOfSize:18-d];
//    cell.title.textColor =/* RGB(249-d*(249-34),118-(118-34)*d,118-(118-34)*d);*/
    cell1.title.textColor = [UIColor blackColor];
   
}


-(HomeMenuCollectionViewCell*)getCellWithIdex:(NSInteger)idx
{
    NSIndexPath * idxPath = [NSIndexPath indexPathForRow:idx inSection:0];
    HomeMenuCollectionViewCell * cell = (HomeMenuCollectionViewCell *)[self.menuView.collectionView cellForItemAtIndexPath:idxPath];
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger idx = scrollView.contentOffset.x/kScreenWidth;
    
    //    HomeMenuCollectionViewCell * cell1 = [self getCellWithIdex:self.selectedIdx];
    //    cell1.selected = NO;
    
    self.selectedIdx = idx;
    [self.menuView clickIdx:idx];
    
}

- (UIView *)MenuBottomView{
    if (!_MenuBottomView) {
        _MenuBottomView = [[UIView alloc] init];
        _MenuBottomView.backgroundColor = [UIColor whiteColor];
    }
    return _MenuBottomView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        
    }
    return _scrollView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

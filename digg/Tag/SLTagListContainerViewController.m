//
//  SLTagListContainerViewController.m
//  digg
//
//  Created by Tim Bao on 2025/1/12.
//

#import "SLTagListContainerViewController.h"
#import "SLGeneralMacro.h"
#import "Masonry.h"
#import "SLTagListContainerViewModel.h"
#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
#import "SLTagListViewController.h"

@interface UILabel (LineCheck)

- (BOOL)isTextExceedingLines:(NSInteger)maxLines;

@end

@implementation UILabel (LineCheck)

- (BOOL)isTextExceedingLines:(NSInteger)maxLines {
    if (!self.text || !self.font) return NO;
    
    // 获取单行高度
    CGFloat singleLineHeight = [@"Single Line" sizeWithAttributes:@{NSFontAttributeName: self.font}].height;
    
    // 获取文本的实际高度
    CGFloat maxWidth = self.frame.size.width - 32;
    CGRect textRect = [self.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName: self.font}
                                              context:nil];
    CGFloat textHeight = textRect.size.height;
    
    // 比较实际高度与允许的最大高度
    return textHeight > singleLineHeight * maxLines;
}

@end

@interface SLTagListContainerViewController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) UIButton *leftBackButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* briefLabel;
@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) JXCategoryNumberView *myCategoryView;

@property (nonatomic, strong) SLTagListContainerViewModel *viewModel;

@end

@implementation SLTagListContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color16(0xF2F2F2);
    
    [self setupUI];
    self.titleLabel.text = self.label;
    [self requestData];
}

#pragma mark - Methods
- (void)setupUI {
    [self.view addSubview:self.leftBackButton];
    [self.leftBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.view).offset(49);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftBackButton.mas_bottom).offset(25);
        make.left.equalTo(self.leftBackButton);
        make.right.equalTo(self.view).offset(-16);
    }];
    
    [self.view addSubview:self.briefLabel];
    [self.briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    [self.view addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.briefLabel.mas_bottom).offset(8);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreButton.mas_bottom).offset(23);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.titles = @[@"编辑精选", @"最新", @"最热"];
    self.myCategoryView.titles = self.titles;
    CGFloat categoryViewHeight = 44;
    [self.contentView addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(12);
        make.height.mas_equalTo(categoryViewHeight);
    }];
    [self.contentView addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.categoryView.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView);
    }];

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = Color16(0xFF1852);
    lineView.indicatorWidth = 28;
    self.myCategoryView.indicators = @[lineView];
}

- (void)requestData {
    [self requestLabelInfo];
    [self requestTabList];
}

- (void)requestLabelInfo {
    @weakobj(self)
    [self.viewModel loadLabelInfoWithLabelId:self.label resultHandler:^(BOOL isSuccess, NSError * _Nonnull error) {
        @strongobj(self)
        if (isSuccess) {
            self.briefLabel.text = self.viewModel.content;
            if ([self.briefLabel isTextExceedingLines: 2]) {
                [self.moreButton setHidden:NO];
            } else {
                [self.moreButton setHidden:YES];
            }
        }
    }];
}

- (void)requestTabList {
    
}

- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryTitleView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

#pragma mark - JXCategoryViewDelegate
// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
}

// 滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
}

#pragma mark - JXCategoryListContainerViewDelegate
// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

// 返回各个列表菜单下的实例，该实例需要遵守并实现 <JXCategoryListContentViewDelegate> 协议
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    SLTagListViewController *vc = [[SLTagListViewController alloc] init];
    vc.index = index;
    vc.label = self.label;
    return vc;
}

#pragma mark - Actions
- (void)backPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreBrief {
    self.briefLabel.numberOfLines = 0;
    [self.moreButton setHidden:YES];
}

#pragma mark - UI Elements
- (UIButton *)leftBackButton {
    if (!_leftBackButton) {
        _leftBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBackButton setImage:[UIImage imageNamed:@"tag_left_icon"] forState:UIControlStateNormal];
        [_leftBackButton addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBackButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _titleLabel;
}

- (UILabel *)briefLabel {
    if (!_briefLabel) {
        _briefLabel = [[UILabel alloc] init];
        _briefLabel.text = @"";
        _briefLabel.textColor = Color16(0x999999);
        _briefLabel.font = [UIFont systemFontOfSize:12];
        _briefLabel.numberOfLines = 2;
    }
    return _briefLabel;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:Color16(0x666666) forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreButton addTarget:self action:@selector(moreBrief) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.clipsToBounds = NO;
        _contentView.layer.cornerRadius = 16.0;
        _contentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    return _contentView;
}

// 分页菜单视图
- (JXCategoryBaseView *)categoryView {
    if (!_categoryView) {
        _categoryView = [self preferredCategoryView];
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

- (SLTagListContainerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SLTagListContainerViewModel alloc] init];
    }
    return _viewModel;
}

@end

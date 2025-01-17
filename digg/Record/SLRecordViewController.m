//
//  SLRecordViewController.m
//  digg
//
//  Created by Tim Bao on 2025/1/16.
//

#import "SLRecordViewController.h"
#import "SLGeneralMacro.h"
#import "Masonry.h"
#import "SLHomeTagView.h"
#import "SLRecordViewTagInputCollectionViewCell.h"
#import "SLRecordViewTagCollectionViewCell.h"
#import "SLCustomFlowLayout.h"
#import "SLRecordViewModel.h"
#import "SVProgressHUD.h"

#import "digg-Swift.h"

@interface SLRecordViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIView* navigationView;
//@property (nonatomic, strong) UIButton *leftBackButton;
@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) SLHomeTagView *tagView;
@property (nonatomic, strong) UITextField *titleField; // 标题输入框
@property (nonatomic, strong) UITextField *linkField;  // 链接输入框
@property (nonatomic, strong) RZRichTextView *textView;    // 多行文本输入框
@property (nonatomic, strong) UIView *line1View;
@property (nonatomic, strong) UIView *line2View;
@property (nonatomic, strong) UIView *line3View;

@property (nonatomic, strong) UICollectionView *collectionView; // 显示标签的集合视图
@property (nonatomic, strong) NSMutableArray *tags;             // 存储标签的数组
@property (nonatomic, strong) NSIndexPath *editingIndexPath;    // 正在编辑的标签的 IndexPath
@property (nonatomic, assign) BOOL isEditing;                   // 是否处于编辑状态

@property (nonatomic, strong) SLRecordViewModel *viewModel;

@end

@implementation SLRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tags = [NSMutableArray array];
    [self setupUI];
}

#pragma mark - Methods
- (void)setupUI {
    [self.view addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NAVBAR_HEIGHT + 5);
    }];
    
//    [self.navigationView addSubview:self.leftBackButton];
//    [self.leftBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.navigationView).offset(16);
//        make.top.equalTo(self.navigationView).offset(5 + STATUSBAR_HEIGHT);
//        make.height.mas_equalTo(32);
//    }];
    
    [self.navigationView addSubview:self.commitButton];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationView).offset(-16);
        make.top.equalTo(self.navigationView).offset(5 + STATUSBAR_HEIGHT);
        make.height.mas_equalTo(32);
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    [self.contentView addSubview:self.tagView];
    [self.contentView addSubview:self.titleField];
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(60);
    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleField);
        make.left.equalTo(self.contentView).offset(20);
    }];
    [self.contentView addSubview:self.line1View];
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleField.mas_bottom);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    [self.contentView addSubview:self.linkField];
    [self.linkField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1View.mas_bottom);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(60);
    }];
    [self.contentView addSubview:self.line2View];
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linkField.mas_bottom);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2View.mas_bottom);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.mas_equalTo(250);
    }];
    [self.contentView addSubview:self.line3View];
    [self.line3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.mas_equalTo(0.5);
    }];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line3View.mas_bottom).offset(16);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.collectionView reloadData];
}

#pragma mark - Clear Button

// 创建清除按钮
- (UIButton *)createClearButtonForTextField:(UITextField *)textField {
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[UIImage systemImageNamed:@"xmark.circle.fill"] forState:UIControlStateNormal];
    clearButton.frame = CGRectMake(0, 0, 30, 30);
    [clearButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    return clearButton;
}

// 清空输入框
- (void)clearTextField:(UIButton *)sender {
    if ([self.titleField.rightView isEqual:sender]) {
        self.titleField.text = @"";
    } else if ([self.linkField.rightView isEqual:sender]) {
        self.linkField.text = @"";
    }
}

- (void)clearAll {
    self.titleField.text = @"";
    self.linkField.text = @"";
    self.textView.text = @"";
    [self.tags removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - Actions
//- (void)backPage {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)commitBtnClick {
    NSString* title = [self.titleField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if (title.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加标题"];
        return;
    }
    [SVProgressHUD show];
    @weakobj(self)
     [self.viewModel subimtRecord:title content:self.textView.text htmlContent:self.textView.code2html labels:self.tags resultHandler:^(BOOL isSuccess, NSError * _Nonnull error) {
        @strongobj(self)
         [SVProgressHUD dismiss];
         if (isSuccess) {
             [self clearAll];
         }
    }];
    
}

#pragma mark - UICollectionView DataSource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tags.count + 1; // +1 用于显示“添加标签”入口
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.tags.count) {
        SLRecordViewTagInputCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SLRecordViewTagInputCollectionViewCell" forIndexPath:indexPath];
        [cell configDataWithIndex:indexPath.item];
        [cell startInput:self.isEditing];
        cell.inputField.enabled = YES;
        cell.inputField.delegate = self;
        [cell.inputField addTarget:self action:@selector(startEditing:) forControlEvents:UIControlEventEditingDidBegin];
        return cell;
    } else {
        SLRecordViewTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SLRecordViewTagCollectionViewCell" forIndexPath:indexPath];
        NSString* name = self.tags[indexPath.item];
        [cell configDataWithTagName:name index:indexPath.item];
        @weakobj(self)
        cell.removeTag = ^(NSString * _Nonnull tagName, NSInteger index) {
            @strongobj(self)
            [self.tags removeObjectAtIndex:index];
            [self.collectionView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        };
        return cell;
    }
}

#pragma mark - Action

- (void)startEditing:(UITextField *)sender {
    if (self.isEditing) {
        return; // 如果已经在编辑模式，返回
    }
    
    self.isEditing = YES;
    self.editingIndexPath = [NSIndexPath indexPathForItem:self.tags.count inSection:0];
    
    // 让输入框成为第一响应者
    SLRecordViewTagInputCollectionViewCell *cell = (SLRecordViewTagInputCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.editingIndexPath];
    [cell startInput:YES];
    [cell.inputField becomeFirstResponder];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.isEditing = NO;
    
    if (textField.text.length > 0) {
        // 新标签插入到第一个位置
        NSString* text = textField.text;
        if (text.length > 30) {
            [SVProgressHUD showErrorWithStatus:@"标签字数不能超过30字符"];
            text = [text substringWithRange:NSMakeRange(0, 30)];
        }
        [self.tags addObject:text];
    }
    textField.text = @"";
    [self.collectionView reloadData]; // 刷新数据
    return YES;
}

#pragma mark - UI Elements
- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [UIView new];
        _navigationView.backgroundColor = UIColor.whiteColor;
    }
    return _navigationView;
}

//- (UIButton *)leftBackButton {
//    if (!_leftBackButton) {
//        _leftBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_leftBackButton setTitle:@"取消" forState:UIControlStateNormal];
//        [_leftBackButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
//        [_leftBackButton addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _leftBackButton;
//}

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_commitButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (SLHomeTagView *)tagView {
    if (!_tagView) {
        _tagView = [[SLHomeTagView alloc] init];
        [_tagView setContentCompressionResistancePriority:UILayoutPriorityRequired
                                          forAxis:UILayoutConstraintAxisHorizontal];
        [_tagView setHidden:YES];
    }
    return _tagView;
}

- (UITextField *)titleField {
    if (!_titleField) {
        _titleField = [[UITextField alloc] init];
        _titleField.placeholder = @"添加标题";
        _titleField.borderStyle = UITextBorderStyleNone;
        _titleField.font = [UIFont systemFontOfSize:24];
        _titleField.rightView = [self createClearButtonForTextField:self.titleField];
        _titleField.rightViewMode = UITextFieldViewModeWhileEditing;
        _titleField.textColor = UIColor.blackColor;
    }
    return _titleField;
}

- (UITextField *)linkField {
    if (!_linkField) {
        _linkField = [[UITextField alloc] init];
        _linkField.placeholder = @"链接";
        _linkField.borderStyle = UITextBorderStyleNone;
        _linkField.font = [UIFont systemFontOfSize:16];
        _linkField.rightView = [self createClearButtonForTextField:self.linkField];
        _linkField.rightViewMode = UITextFieldViewModeWhileEditing;
        _linkField.textColor = UIColor.blackColor;
    }
    return _linkField;
}

- (RZRichTextView *)textView {
    if (!_textView) {
        _textView = [[RZRichTextView alloc] initWithFrame:CGRectZero viewModel:[RZRichTextViewModel sharedWithEdit:YES]];
        _textView.font = [UIFont systemFontOfSize:16];
    }
    return _textView;
}

- (UIView *)line1View {
    if (!_line1View) {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = Color16(0xEEEEEE);
    }
    return _line1View;
}

- (UIView *)line2View {
    if (!_line2View) {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = Color16(0xEEEEEE);
    }
    return _line2View;
}

- (UIView *)line3View {
    if (!_line3View) {
        _line3View = [[UIView alloc] init];
        _line3View.backgroundColor = Color16(0xEEEEEE);
    }
    return _line3View;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        SLCustomFlowLayout *layout = [[SLCustomFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.estimatedItemSize = CGSizeMake(100, 25);
        layout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[SLRecordViewTagInputCollectionViewCell class] forCellWithReuseIdentifier:@"SLRecordViewTagInputCollectionViewCell"];
        [_collectionView registerClass:[SLRecordViewTagCollectionViewCell class] forCellWithReuseIdentifier:@"SLRecordViewTagCollectionViewCell"];
    }
    return _collectionView;
}

- (SLRecordViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SLRecordViewModel new];
    }
    return _viewModel;
}

@end

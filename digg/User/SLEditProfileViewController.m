//
//  SLEditProfileViewController.m
//  digg
//
//  Created by Tim Bao on 2025/1/7.
//

#import "SLEditProfileViewController.h"
#import "SLGeneralMacro.h"
#import "Masonry.h"


@interface SLEditProfileViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *leftBackButton;
@property (nonatomic, strong) UIButton *saveBackButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UIImageView* avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UILabel *briefLabel;
@property (nonatomic, strong) UITextView *briefTextView;

@end

@implementation SLEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupUI];
}

#pragma mark - Methods
- (void)setupUI {
    [self.view addSubview:self.leftBackButton];
    [self.leftBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.view).offset(12);
        make.width.mas_equalTo(80);
    }];
    
    [self.view addSubview:self.saveBackButton];
    [self.saveBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.view).offset(12);
        make.width.mas_equalTo(80);
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBackButton.mas_right);
        make.right.equalTo(self.saveBackButton.mas_left);
        make.centerY.equalTo(self.leftBackButton);
    }];
    
    [self.view addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftBackButton.mas_bottom).offset(16);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(150);
    }];
    
    [self.view addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom).offset(-40);
        make.left.equalTo(self.view).offset(16);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    CGSize size = [self.nameLabel sizeThatFits:CGSizeZero];
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(50);
        make.size.mas_equalTo(size);
    }];
    
    [self.view addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(8);
        make.right.equalTo(self.view).offset(-16);
    }];
    
    [self.view addSubview:self.briefLabel];
    [self.briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(30);
        make.size.mas_equalTo(size);
    }];
    
    [self.view addSubview:self.briefTextView];
    [self.briefTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.briefLabel).offset(-8);
        make.left.equalTo(self.briefLabel.mas_right).offset(8);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(200);
    }];
}

#pragma mark - Actions
- (void)backPage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveInfo {
    //TODO:
}

- (void)chageBgImage {
    //actionsheet
}

- (void)chageAvatarImage {
    //actionsheet
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UI Elements
- (UIButton *)leftBackButton {
    if (!_leftBackButton) {
        _leftBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBackButton setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBackButton setTitleColor:Color16(0x999999) forState:UIControlStateNormal];
        _leftBackButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leftBackButton addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBackButton;
}

- (UIButton *)saveBackButton {
    if (!_saveBackButton) {
        _saveBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBackButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBackButton setTitleColor:Color16(0x222222) forState:UIControlStateNormal];
        _saveBackButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveBackButton addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBackButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"编辑个人资料";
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_header_bg"]];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
        [_headerImageView setUserInteractionEnabled: YES];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chageBgImage)];
        [_headerImageView addGestureRecognizer:tap];
    }
    return _headerImageView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default_img"]];
        _avatarImageView.layer.cornerRadius = 40;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _avatarImageView.layer.borderWidth = 2;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.zPosition = 1; // 提高层级
        
        [_avatarImageView setUserInteractionEnabled: YES];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chageAvatarImage)];
        [_avatarImageView addGestureRecognizer:tap];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"姓名";
        _nameLabel.textColor = UIColor.blackColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.placeholder = @"请输入您的姓名";
        _nameTextField.font = [UIFont systemFontOfSize:18];
        _nameTextField.textColor = [UIColor blackColor];
        _nameTextField.keyboardType = UIKeyboardTypeDefault;
        _nameTextField.returnKeyType = UIReturnKeyDone;
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}

- (UILabel *)briefLabel {
    if (!_briefLabel) {
        _briefLabel = [[UILabel alloc] init];
        _briefLabel.text = @"简介";
        _briefLabel.textColor = UIColor.blackColor;
        _briefLabel.font = [UIFont boldSystemFontOfSize:18];
        _briefLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _briefLabel;
}

- (UITextView *)briefTextView {
    if (!_briefTextView) {
        _briefTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _briefTextView.font = [UIFont systemFontOfSize:18];
        _briefTextView.textColor = [UIColor blackColor];
        _briefTextView.keyboardType = UIKeyboardTypeDefault;
        _briefTextView.returnKeyType = UIReturnKeyDefault;
    }
    return _briefTextView;
}

@end

//
//  SLLoginViewController.m
//  digg
//
//  Created by hey on 2024/10/6.
//

#import "SLLoginViewController.h"
#import "SLGeneralMacro.h"
#import <Masonry/Masonry.h>
#import "SLUserLoginPrivacyView.h"
#import "SLWebViewController.h"

@interface SLLoginViewController ()

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) SLUserLoginPrivacyView *loginPrivacyView;

@end

@implementation SLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createViews];
    self.loginPrivacyView.privacyStatus = UserLoginPrivacyStatusNormal;
}

- (void)closeBtnAction:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginBtnAction:(id)sender{
    
}

- (void)createViews{
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.logoImgView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.subtitleLabel];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.loginPrivacyView];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(STATUSBAR_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(198);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.logoImgView.mas_bottom).offset(10);
        make.height.mas_offset(40);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.loginPrivacyView.mas_top).offset(-10);
    }];
    
    [self.loginPrivacyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-200);
        make.left.equalTo(self.view).offset(40);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
}

- (UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIImageView *)logoImgView{
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] init];
        _logoImgView.backgroundColor = [UIColor blackColor];
    }
    return _logoImgView;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:26];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"BlackPaper";
        _subtitleLabel.text = @"来一句slogan来一句slogan";
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel){
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = [UIColor blackColor];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subtitleLabel;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 8;
        _loginBtn.backgroundColor = [UIColor blackColor];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.textColor = [UIColor whiteColor];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _loginBtn;
}

- (SLUserLoginPrivacyView *)loginPrivacyView{
    if (!_loginPrivacyView) {
        _loginPrivacyView = [[SLUserLoginPrivacyView alloc] init];
        @weakobj(self);
        _loginPrivacyView.clickedCallBack = ^(NSString *url) {
            @strongobj(self);
            SLWebViewController *vc = [[SLWebViewController alloc] init];
            [vc startLoadRequestWithUrl:@"https://www.baidu.com"];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _loginPrivacyView;
}


@end

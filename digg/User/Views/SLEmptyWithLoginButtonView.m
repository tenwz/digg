//
//  SLEmptyWithLoginButtonView.m
//  digg
//
//  Created by Tim Bao on 2025/1/6.
//

#import "SLEmptyWithLoginButtonView.h"
#import "Masonry.h"

@interface SLEmptyWithLoginButtonView()

@end

@implementation SLEmptyWithLoginButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.loginBtn];
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 50));
        }];
    }
    return self;
}

- (void)gotoLoginPage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoLoginPage)]) {
        [self.delegate gotoLoginPage];
    }
}

#pragma mark - UI Elements
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _loginBtn.layer.cornerRadius = 8;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
        _loginBtn.layer.borderWidth = 1;
        [_loginBtn addTarget:self action:@selector(gotoLoginPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

@end

//
//  SLPublishViewController.m
//  digg
//
//  Created by hey on 2024/10/11.
//

#import "SLPublishViewController.h"
#import "SLGeneralMacro.h"
#import <Masonry/Masonry.h>

@interface SLPublishViewController ()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentTipLabel;
@property (nonatomic, strong) UITextField *contentTextField;
@property (nonatomic, strong) UIView *line1View;
@property (nonatomic, strong) UILabel *titleTipLabel;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UIView *line2View;
@property (nonatomic, strong) UILabel *desTipLabel;
@property (nonatomic, strong) UILabel *desTip2Label;
@property (nonatomic, strong) UITextView *desTextView;
@property (nonatomic, strong) UIView *line3View;
@property (nonatomic, strong) UILabel *tagTipLabel;
@property (nonatomic, strong) UILabel *tagTip2Label;
@property (nonatomic, strong) UIView *line4View;

@end

@implementation SLPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self createViews];
}

- (void)cancenBtnAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)publishBtnAction:(id)sender{
    
}

- (void)createViews{
    
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.publishBtn];
    [self.view addSubview:self.contentView];
    
    [self.contentView addSubview:self.contentTipLabel];
    [self.contentView addSubview:self.contentTextField];
    [self.contentView addSubview:self.line1View];
    
    [self.contentView addSubview:self.titleTipLabel];
    [self.contentView addSubview:self.titleTextField];
    [self.contentView addSubview:self.line2View];
    
    [self.contentView addSubview:self.desTipLabel];
    [self.contentView addSubview:self.desTip2Label];
    [self.contentView addSubview:self.desTextView];
    [self.contentView addSubview:self.line3View];
    
    [self.contentView addSubview:self.tagTipLabel];
    [self.contentView addSubview:self.tagTip2Label];
    [self.contentView addSubview:self.line4View];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.view).offset(10+STATUSBAR_HEIGHT);
        make.height.mas_equalTo(16);
    }];
    
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.view).offset(10+STATUSBAR_HEIGHT);
        make.height.mas_equalTo(16);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
    }];
    
    
    [self.contentTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(23);
        make.width.mas_equalTo(60);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentTipLabel.mas_right).offset(8);
        make.centerY.equalTo(self.contentTipLabel.mas_centerY);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentTipLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.titleTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.line1View.mas_bottom);
    }];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleTipLabel.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.titleTipLabel.mas_centerY);
    }];
    
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1View);
        make.right.equalTo(self.line1View);
        make.top.equalTo(self.titleTipLabel.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.desTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.line2View.mas_bottom);
    }];
    
    [self.desTip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desTipLabel.mas_right);
        make.centerY.equalTo(self.desTipLabel);
        make.right.equalTo(self.contentView);
    }];
    
    [self.desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.desTipLabel.mas_bottom);
        make.height.mas_equalTo(150);
    }];
    
    [self.line3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.line1View);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.desTextView.mas_bottom);
    }];
    
    [self.tagTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.line3View.mas_bottom);
    }];
    
    [self.tagTip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagTipLabel.mas_right);
        make.centerY.equalTo(self.tagTipLabel.mas_centerY);
    }];
    
    [self.line4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.line1View);
        make.top.equalTo(self.tagTipLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
}


- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setTitleColor:Color16(0x363636) forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

- (UIButton *)publishBtn{
    if (!_publishBtn) {
        _publishBtn = [[UIButton alloc] init];
        [_publishBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(publishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _publishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_publishBtn setTitleColor:Color16(0x363636) forState:UIControlStateNormal];
    }
    return _publishBtn;
}


- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UILabel *)contentTipLabel{
    if (!_contentTipLabel) {
        _contentTipLabel = [[UILabel alloc] init];
        _contentTipLabel.text = @"内容链接";
        _contentTipLabel.font = [UIFont boldSystemFontOfSize:14];
        _contentTipLabel.textColor = Color16(0x363636);
    }
    return _contentTipLabel;
}

- (UITextField *)contentTextField{
    if (!_contentTextField) {
        _contentTextField = [[UITextField alloc] init];
        _contentTextField.textColor = Color16(0x005ECC);
        _contentTextField.font = [UIFont systemFontOfSize:12];
        _contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _contentTextField;
}

- (UIView *)line1View{
    if (!_line1View) {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = Color16(0x6F6F6F);
    }
    return _line1View;
}

- (UILabel *)titleTipLabel{
    if (!_titleTipLabel) {
        _titleTipLabel = [[UILabel alloc] init];
        _titleTipLabel.text = @"添加标题*";
        _titleTipLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleTipLabel.textColor = Color16(0x363636);
    }
    return _titleTipLabel;
}

- (UITextField *)titleTextField{
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.font = [UIFont systemFontOfSize:12];
    }
    return _titleTextField;
}

- (UIView *)line2View{
    if (!_line2View) {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = Color16(0xDCDCDC);
    }
    return _line2View;
}

- (UILabel *)desTipLabel{
    if (!_desTipLabel) {
        _desTipLabel = [[UILabel alloc] init];
        _desTipLabel.text = @"添加说明";
        _desTipLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _desTipLabel;
}

- (UILabel *)desTip2Label{
    if (!_desTip2Label) {
        _desTip2Label = [[UILabel alloc] init];
        _desTip2Label.text = @"（文章预览，默认AI生成）";
        _desTip2Label.textColor = Color16(0x888888);
        _desTip2Label.font = [UIFont systemFontOfSize:12];
    }
    return _desTip2Label;
}

- (UITextView *)desTextView{
    if (!_desTextView) {
        _desTextView = [[UITextView alloc] init];
        _desTextView.font = [UIFont systemFontOfSize:12];
    }
    return _desTextView;
}

- (UIView *)line3View {
    if (!_line3View) {
        _line3View = [[UIView alloc] init];
        _line3View.backgroundColor = Color16(0xDCDCDC);
    }
    return _line3View;
}

- (UILabel *)tagTipLabel{
    if (!_tagTipLabel) {
        _tagTipLabel = [[UILabel alloc] init];
        _tagTipLabel.text = @"标签";
        _tagTipLabel.textColor = Color16(0x363636);
        _tagTipLabel.font = [UIFont systemFontOfSize:14];
    }
    return _tagTipLabel;
}

- (UILabel *)tagTip2Label{
    if (!_tagTip2Label) {
        _tagTip2Label = [[UILabel alloc] init];
        _tagTip2Label.text = @"（可选，帮助内容更好地被发现）";
        _tagTip2Label.textColor = Color16(0x888888);
        _tagTip2Label.font = [UIFont systemFontOfSize:12];
    }
    return _tagTip2Label;
}

- (UIView *)line4View {
    if (!_line4View) {
        _line4View = [[UIView alloc] init];
        _line4View.backgroundColor = Color16(0xDCDCDC);
    }
    return _line4View;
}

@end

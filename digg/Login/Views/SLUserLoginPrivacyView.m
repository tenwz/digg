//
//  CaocaoUserLoginPrivacyView.m
//  Pods
//
//  Created by zhangjin on 2022/3/6.
//	
//

#import "SLUserLoginPrivacyView.h"
#import "SLGeneralMacro.h"
#import <pop/POP.h>
#import "CaocaoClickableAttributedTextLabel.h"
#import <Masonry/Masonry.h>

@interface SLUserLoginPrivacyView ()

@property (nonatomic, strong) UIButton    *selectButton;
@property (nonatomic, strong) CaocaoClickableAttributedTextLabel *protocolView;

@property (nonatomic, copy) NSString *privacyName;
@property (nonatomic, copy) NSString *privacyUrl;

@property (nonatomic, strong) NSMutableArray *protocolModelsList;

@end


@implementation SLUserLoginPrivacyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
        [self setupConstraints];
        [self showWithPrivacyView];
    }
    return self;
}

#pragma mark - Load Subviews

/**
 添加子控件
 */
- (void)loadSubviews {
    [self addSubview:self.selectButton];
    [self addSubview:self.protocolView];
}

/**
 添加约束布局
 */
- (void)setupConstraints {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@30.f);
        make.left.top.mas_equalTo(0);
    }];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectButton.mas_right).offset(4);
        make.top.equalTo(self.selectButton).offset(8);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)showAnimation {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.6f, 0.6f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.dynamicsFriction    = 15;
    scaleAnimation.dynamicsTension     = 530;
    [self.selectButton.layer pop_addAnimation:scaleAnimation forKey:@"ScaleAnimation"];
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.fromValue = @0.25;
    alphaAnimation.toValue = @1.0;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.1 :0.25 :1];
    [self.selectButton pop_addAnimation:alphaAnimation forKey:@"layerAlphaSpringAnimation"];
}

- (void)showWithPrivacyView{
    
    [self.protocolModelsList removeAllObjects];
    
    CaocaoClickableAttributedTextConfigModel *partOne = [[CaocaoClickableAttributedTextConfigModel alloc] init];
    partOne.text = @"我已阅读并同意";
    partOne.color = [UIColor darkGrayColor];
    partOne.font = [UIFont systemFontOfSize:12];
    [self.protocolModelsList addObject:partOne];
    @weakobj(self);
    CaocaoClickableAttributedTextConfigModel *partTwo = [[CaocaoClickableAttributedTextConfigModel alloc] init];
    partTwo.text = @"《服务协议》";
    partTwo.color = Color16(0x9B9BA5);
    partTwo.font = [UIFont systemFontOfSize:12];
    partTwo.clickedCallBack = ^{
        if (self.clickedCallBack) {
            self.clickedCallBack(@"https://www.baidu.com");
        }
    };
    [self.protocolModelsList addObject:partTwo];
    
    CaocaoClickableAttributedTextConfigModel *partThree = [[CaocaoClickableAttributedTextConfigModel alloc] init];
    partThree.text = @"《隐私政策》";
    partThree.color = Color16(0x9B9BA5);
    partThree.font = [UIFont systemFontOfSize:12];
    
    partThree.clickedCallBack = ^{
        if (self.clickedCallBack) {
            self.clickedCallBack(@"https://www.baidu.com");
        }
    };
    [self.protocolModelsList addObject:partThree];
    
    [self.protocolView showWithAttributedTextConfigModels:self.protocolModelsList];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    CGRect rect = CGRectMake(-7, -7, 44, 44);
//    if (CGRectContainsPoint(rect, point)) {
//        return self.selectButton;
//    }
//    
//    return [super hitTest:point withEvent:event];
//}
#pragma mark - actions

- (void)selectAction:(UIButton *)sender {
    if (self.privacyStatus == UserLoginPrivacyStatusNormal) {
        self.privacyStatus = UserLoginPrivacyStatusActive;
    } else {
        self.privacyStatus = UserLoginPrivacyStatusNormal;
    }
}

#pragma mark - Setter、Getter
#pragma mark setter
- (void)setPrivacyStatus:(UserLoginPrivacyStatus)privacyStatus {
    _privacyStatus = privacyStatus;
    if (privacyStatus == UserLoginPrivacyStatusNormal) {
        [self.selectButton setImage:[UIImage imageNamed:@"user_yxux_checkbox_small_normal"] forState:UIControlStateNormal];
    } else {
        [self.selectButton setImage:[UIImage imageNamed:@"user_yxux_checkbox_small_selected"] forState:UIControlStateNormal];
        [self showAnimation];
    }
}


#pragma mark getter
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (CaocaoClickableAttributedTextLabel *)protocolView {
    if (!_protocolView) {
        _protocolView = [[CaocaoClickableAttributedTextLabel alloc] init];
    }
    return _protocolView;
}

- (NSMutableArray *)protocolModelsList {
    if (!_protocolModelsList) {
        _protocolModelsList = [NSMutableArray array];
    }
    return _protocolModelsList;
}

@end

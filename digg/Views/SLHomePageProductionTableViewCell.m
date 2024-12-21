//
//  SLHomePageDiscussionTableViewCell.m
//  digg
//
//  Created by hey on 2024/10/12.
//

#import "SLHomePageProductionTableViewCell.h"
#import <Masonry/Masonry.h>
#import "SLGeneralMacro.h"
#import "CaocaoButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+UXing.h"

@interface SLHomePageProductionTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *userIconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dotLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) CaocaoButton *likeBtn;
@property (nonatomic, strong) UILabel *dot1Label;
@property (nonatomic, strong) CaocaoButton *dislikeBtn;
@property (nonatomic, strong) UILabel *dot2Label;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UILabel *dot3Label;
@property (nonatomic, strong) UIButton *checkBtn;

@property (nonatomic, strong) SLArticleTodayEntity *entity;
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation SLHomePageProductionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createViews];
    }
    return self;
}

- (void)updateWithEntity:(SLArticleTodayEntity *)entiy{
    self.entity = entiy;
    self.titleLabel.text = entiy.title;
    self.contentLabel.text = entiy.content;
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",entiy.likeCnt] forState:UIControlStateNormal];
    [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%ld",entiy.dislikeCnt] forState:UIControlStateNormal];
    [self.userIconImgView sd_setImageWithURL:[NSURL URLWithString:entiy.userAvatar]];
    self.nameLabel.text = entiy.username;
    self.timeLabel.text = [NSString timeStmpWith:entiy.gmtCreate];
    
    if (!self.isSelected) {
        //重置
        self.likeBtn.selected = false;
        self.dislikeBtn.selected = false;
    }
//
//    self.titleLabel.text = @"尤瓦尔·赫拉利：宗教与科学的区别 警惕绝对的真理";
//    self.contentLabel.text = @"科学之所以能够推动人类知识的进步，正是因为它容许对现有理论的质疑和挑战。科学家的工作基于“证据至上”的原则，一项理论如果得不到新证据";
//    [self.likeBtn setTitle:@"12" forState:UIControlStateNormal];
//    [self.dislikeBtn setTitle:@"0" forState:UIControlStateNormal];
//    self.userIconImgView.backgroundColor = [UIColor lightGrayColor];
//    self.nameLabel.text = @"理工科的MBA";
//    self.timeLabel.text = @"昨天 14:21";
}


- (void)likeBtnAction:(id)sender{
    if (self.likeClick) {
        self.likeClick(self.entity);
    }
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",self.entity.likeCnt + 1] forState:UIControlStateNormal];
    [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%ld",self.entity.dislikeCnt] forState:UIControlStateNormal];
    
    self.likeBtn.selected = YES;
    self.dislikeBtn.selected = NO;
}

- (void)dislikeBtnAction:(id)sender{
    if (self.dislikeClick) {
        self.dislikeClick(self.entity);
    }
    
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",self.entity.likeCnt] forState:UIControlStateNormal];
    [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%ld",self.entity.dislikeCnt+1] forState:UIControlStateNormal];
    self.likeBtn.selected = NO;
    self.dislikeBtn.selected = YES;
}

- (void)createViews{
    [self.contentView addSubview:self.bgView];
    
    [self.bgView addSubview:self.userIconImgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.dotLabel];
    [self.bgView addSubview:self.timeLabel];
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.likeBtn];
    [self.bgView addSubview:self.dot1Label];
    [self.bgView addSubview:self.dislikeBtn];
    [self.bgView addSubview:self.dot2Label];
    [self.bgView addSubview:self.messageBtn];
    [self.bgView addSubview:self.dot3Label];
    [self.bgView addSubview:self.checkBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.userIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.bgView).offset(12);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIconImgView.mas_centerY);
        make.left.equalTo(self.userIconImgView.mas_right).offset(10);
    }];
    
    [self.dotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 16));
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.left.equalTo(self.nameLabel.mas_right).offset(6);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.left.equalTo(self.dotLabel.mas_right).offset(6);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.top.equalTo(self.userIconImgView.mas_bottom).offset(8);
        make.right.equalTo(self.contentView).offset(-12);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.right.equalTo(self.bgView).offset(-12);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(16);
        make.left.equalTo(self.bgView).offset(12);
        make.bottom.equalTo(self.bgView).offset(-18);
    }];
    
    [self.dot1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 16));
        make.centerY.equalTo(self.likeBtn.mas_centerY);
        make.left.equalTo(self.likeBtn.mas_right).offset(6);
    }];
    
    [self.dislikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeBtn.mas_right).offset(18);
        make.centerY.equalTo(self.likeBtn.mas_centerY);
        make.height.equalTo(self.likeBtn.mas_height);
    }];
    
    [self.dot2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 16));
        make.centerY.equalTo(self.dislikeBtn.mas_centerY);
        make.left.equalTo(self.dislikeBtn.mas_right).offset(6);
    }];
   
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dislikeBtn.mas_right).offset(18);
        make.centerY.equalTo(self.likeBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.dot3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 16));
        make.centerY.equalTo(self.messageBtn.mas_centerY);
        make.left.equalTo(self.messageBtn.mas_right).offset(6);
    }];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageBtn.mas_right).offset(18);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self.likeBtn.mas_centerY);
    }];
    
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8;
    }
    return _bgView;
}

- (UIImageView *)userIconImgView{
    if (!_userIconImgView) {
        _userIconImgView = [[UIImageView alloc] init];
        _userIconImgView.layer.masksToBounds = YES;
        _userIconImgView.layer.cornerRadius = 10;
    }
    return _userIconImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = Color16(0x585858);
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _nameLabel;
}

- (UILabel *)dotLabel{
    if (!_dotLabel) {
        _dotLabel = [[UILabel alloc] init];
        _dotLabel.text = @"·";
        _dotLabel.textColor = Color16(0xA0A0A0);
        _dotLabel.font = [UIFont systemFontOfSize:12];
    }
    return _dotLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = Color16(0x797979);
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 3;
        _contentLabel.textColor = Color16(0x5D5D5D);
    }
    return _contentLabel;
}

- (UIButton *)likeBtn{
    if(!_likeBtn){
        _likeBtn = [[CaocaoButton alloc] init];
        _likeBtn.imageButtonType = CaocaoRightImageButton;
        _likeBtn.margin = 2;
        [_likeBtn setTitle:@"--" forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_likeBtn setTitleColor:Color16(0x585858) forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"agree_selected"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

- (UIButton *)dislikeBtn{
    if (!_dislikeBtn) {
        _dislikeBtn = [[CaocaoButton alloc] init];
        _dislikeBtn.margin = 2;
        _dislikeBtn.imageButtonType = CaocaoRightImageButton;
        [_dislikeBtn setTitle:@"--" forState:UIControlStateNormal];
        _dislikeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_dislikeBtn setTitleColor:Color16(0x585858) forState:UIControlStateNormal];
        [_dislikeBtn setImage:[UIImage imageNamed:@"disagree"]forState:UIControlStateNormal];
        [_dislikeBtn setImage:[UIImage imageNamed:@"disagree_selected"] forState:UIControlStateSelected];
        [_dislikeBtn addTarget:self action:@selector(dislikeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dislikeBtn;
}

- (UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [[UIButton alloc] init];
        [_messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    }
    return _messageBtn;
}

- (UIButton *)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [[UIButton alloc] init];
        [_checkBtn setTitle:@"查看" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:Color16(0x005ECC) forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _checkBtn;
}

- (UILabel *)dot1Label{
    if (!_dot1Label) {
        _dot1Label = [[UILabel alloc] init];
        _dot1Label.text = @"·";
        _dot1Label.textColor = Color16(0xA0A0A0);
        _dot1Label.font = [UIFont systemFontOfSize:12];
    }
    return _dot1Label;
}

- (UILabel *)dot2Label{
    if (!_dot2Label) {
        _dot2Label = [[UILabel alloc] init];
        _dot2Label.text = @"·";
        _dot2Label.textColor = Color16(0xA0A0A0);
        _dot2Label.font = [UIFont systemFontOfSize:12];
    }
    return _dot2Label;
}

- (UILabel *)dot3Label{
    if (!_dot3Label) {
        _dot3Label = [[UILabel alloc] init];
        _dot3Label.text = @"·";
        _dot3Label.textColor = Color16(0xA0A0A0);
        _dot3Label.font = [UIFont systemFontOfSize:12];
    }
    return _dot3Label;
}

@end

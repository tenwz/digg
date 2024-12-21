//
//  SLFollowingListItemCell.m
//  digg
//
//  Created by hey on 2024/10/11.
//

#import "SLFollowingListItemCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SLGeneralMacro.h"
#import "CaocaoButton.h"

@interface SLFollowingListItemCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *userIconImgView;
@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) CaocaoButton *followingBtn;//关注
@property (nonatomic, strong) UIButton *followedBtn;//已关注
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) CaocaoButton *likeBtn;
@property (nonatomic, strong) UILabel *dot1Label;
@property (nonatomic, strong) CaocaoButton *dislikeBtn;
@property (nonatomic, strong) UILabel *dot2Label;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UILabel *dot3Label;
@property (nonatomic, strong) UIButton *checkBtn;

@end

@implementation SLFollowingListItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)updateWithEntity:(id)entity{
    self.userIconImgView.backgroundColor = [UIColor lightGrayColor];
    self.titleLabel.text = @"专为中文网页内容设计的排版样式增强——赫蹏";
    self.contentLabel.text = @"HyperCard是一套为苹果Mac和Apple IIGS电脑开发的应用程序和编程工具。在万维网出现之前，它是最成功的超媒体系统之一。HyperCard于1987年发布，售价";
    self.nameLabel.text = @"理工科的MBA·认为文章有用";
    self.followedBtn.hidden = NO;
    
}

- (void)followingBtnAction:(id)sender{
    
}

- (void)followedBtnAction:(id)sender{
    
}

- (void)likeBtnAction:(id)sender{
    
}

- (void)dislikeBtnAction:(id)sender{
    
}

- (void)createViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.userIconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.followedBtn];
    [self.contentView addSubview:self.followingBtn];
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentView addSubview:self.likeBtn];
    [self.contentView addSubview:self.dot1Label];
    [self.contentView addSubview:self.dislikeBtn];
    [self.contentView addSubview:self.dot2Label];
    [self.contentView addSubview:self.messageBtn];
    [self.contentView addSubview:self.dot3Label];
    [self.contentView addSubview:self.checkBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    
    [self.userIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIconImgView.mas_centerY);
        make.left.equalTo(self.userIconImgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-60);
    }];
    
    [self.followedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIconImgView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.mas_equalTo(18);
    }];
    
    [self.followingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIconImgView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.mas_equalTo(18);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.userIconImgView.mas_bottom).offset(7);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(18);
        make.left.equalTo(self.contentView).offset(16);
        make.bottom.equalTo(self.contentView).offset(-10);
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

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
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

- (UIButton *)followedBtn{
    if (!_followedBtn) {
        _followedBtn = [[UIButton alloc] init];
        [_followedBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [_followedBtn setTitleColor:Color16(0xA0A0A0) forState:UIControlStateNormal];
        _followedBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_followedBtn addTarget:self action:@selector(followedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _followedBtn.hidden = YES;
    }
    return _followingBtn;
}

- (CaocaoButton *)followingBtn{
    if (!_followingBtn) {
        _followingBtn = [[CaocaoButton alloc] init];
        _followingBtn.imageButtonType = CaocaoLeftImageButton;
        _followingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_followingBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_followingBtn setTitleColor:Color16(0x585858) forState:UIControlStateNormal];
        [_followingBtn addTarget:self action:@selector(followingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _followingBtn.hidden = YES;
    }
    return _followingBtn;
}

- (UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 3;
        _contentLabel.textColor = Color16(0x585858);
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

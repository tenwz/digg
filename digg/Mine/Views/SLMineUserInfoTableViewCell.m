//
//  SLMineUserInfoTableViewCell.m
//  digg
//
//  Created by hey on 2024/10/13.
//

#import "SLMineUserInfoTableViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SLGeneralMacro.h"

@interface SLMineUserInfoTableViewCell ()

@property (nonatomic, strong) UIImageView *userIconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *followCountLabel;//关注 数量
@property (nonatomic, strong) UILabel *followTipLabel;
@property (nonatomic, strong) UILabel *followedCountLabel;//被关注 数量
@property (nonatomic, strong) UILabel *followedTipLabel;
@property (nonatomic, strong) UILabel *likeCountLabel;//被点赞的数量
@property (nonatomic, strong) UILabel *likeTipLabel;
@property (nonatomic, strong) UILabel *signInfoLabel;

@end

@implementation SLMineUserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)updateWithEntity:(id)entity{
    
}

- (void)createViews{
    [self.contentView addSubview:self.userIconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.followCountLabel];
    [self.contentView addSubview:self.followTipLabel];
    [self.contentView addSubview:self.followedCountLabel];
    [self.contentView addSubview:self.followedTipLabel];
    [self.contentView addSubview:self.likeCountLabel];
    [self.contentView addSubview:self.likeTipLabel];
    [self.contentView addSubview:self.signInfoLabel];
    
    [self.userIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIconImgView.mas_centerY);
        make.left.equalTo(self.userIconImgView.mas_right).offset(12);
    }];
    
    [self.followCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.userIconImgView.mas_bottom).offset(8);
        make.height.mas_equalTo(30);
    }];
    
    [self.followTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.followCountLabel.mas_bottom).offset(4);
        make.height.mas_equalTo(13);
    }];
    
    [self.followedCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(133);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.followCountLabel.mas_top);
    }];
    
    [self.followedCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followedCountLabel.mas_left);
        make.top.equalTo(self.followTipLabel.mas_top);
        make.height.mas_equalTo(13);
    }];
    
    [self.likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(260);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.followCountLabel.mas_top);
    }];
    
    [self.likeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeTipLabel.mas_left);
        make.top.equalTo(self.followTipLabel.mas_top);
        make.height.mas_equalTo(13);
    }];
    
    [self.signInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.followCountLabel.mas_bottom).offset(14);
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
}

- (UIImageView *)userIconImgView{
    if (!_userIconImgView) {
        _userIconImgView = [[UIImageView alloc] init];
        _userIconImgView.layer.masksToBounds = YES;
        _userIconImgView.layer.cornerRadius = 18;
    }
    return _userIconImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _nameLabel;
}

- (UILabel *)followCountLabel{
    if (!_followCountLabel) {
        _followCountLabel = [[UILabel alloc] init];
        _followCountLabel.font = [UIFont systemFontOfSize:24];
        _followCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followCountLabel;
}

- (UILabel *)followTipLabel{
    if (!_followTipLabel) {
        _followTipLabel = [[UILabel alloc] init];
        _followTipLabel.font = [UIFont systemFontOfSize:10];
        _followTipLabel.textColor = Color16(0x5D5D5D);
        _followTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followTipLabel;
}

- (UILabel *)followedCountLabel{
    if (!_followedCountLabel) {
        _followedCountLabel = [[UILabel alloc] init];
        _followedCountLabel.font = [UIFont systemFontOfSize:24];
        _followedCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followedCountLabel;
}

- (UILabel *)followedTipLabel{
    if (!_followedTipLabel) {
        _followedTipLabel = [[UILabel alloc] init];
        _followedTipLabel.font = [UIFont systemFontOfSize:10];
        _followedTipLabel.textColor = Color16(0x5D5D5D);
        _followedTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followedTipLabel;
}

- (UILabel *)likeCountLabel{
    if (!_likeCountLabel) {
        _likeCountLabel = [[UILabel alloc] init];
        _likeCountLabel.font = [UIFont systemFontOfSize:24];
        _likeCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _likeCountLabel;
}

- (UILabel *)likeTipLabel{
    if (!_likeTipLabel) {
        _likeTipLabel = [[UILabel alloc] init];
        _likeTipLabel.font = [UIFont systemFontOfSize:10];
        _likeTipLabel.textColor = Color16(0x5D5D5D);
        _likeTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _likeTipLabel;
}

- (UILabel *)signInfoLabel{
    if (!_signInfoLabel) {
        _signInfoLabel = [[UILabel alloc] init];
        _signInfoLabel.numberOfLines = 2;
        _signInfoLabel.textColor = Color16(0x5D5D5D);
        _signInfoLabel.font = [UIFont systemFontOfSize:12];
    }
    return _signInfoLabel;
}

@end

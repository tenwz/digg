//
//  SLHomePageDiscussionTableViewCell.m
//  digg
//
//  Created by hey on 2024/10/12.
//

#import "SLHomePageQATableViewCell.h"
#import <Masonry/Masonry.h>
#import "SLGeneralMacro.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+UXing.h"

@interface SLHomePageQATableViewCell ()

@property (nonatomic, strong) UIImageView *msgImgView;
@property (nonatomic, strong) UILabel *msgCountLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *userIconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dotLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *discontentView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *discontentLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SLHomePageQATableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)updateWithEntity:(SLCommentFeedEntity *)entity{
    self.msgCountLabel.text = [NSString stringWithFormat:@"%ld",entity.articleCommentCnt];
    self.titleLabel.text = entity.title;
    [self.userIconImgView sd_setImageWithURL:[NSURL URLWithString:entity.avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    self.nameLabel.text = entity.username;
    self.timeLabel.text = [NSString timeStmpWith:entity.gmtCreate];
    
    self.nickNameLabel.text = entity.replyUsername;
    self.discontentLabel.text = entity.replyContent;
    
    self.contentLabel.text = entity.content;
    
//    self.msgCountLabel.text = @"99";
//    self.titleLabel.text = @"美元理财可以买吗？";
//    self.userIconImgView.backgroundColor = [UIColor lightGrayColor];
//    self.nameLabel.text = @"理工科的MBA";
//    self.timeLabel.text = @"昨天 14:21";
//    self.nickNameLabel.text = @"momo";
//    self.discontentLabel.text = @"可以买，而且窗口很短。。。因为国内很快跟上降息";
//    self.contentLabel.text = @"我3月份买的，收益已经被汇率跌完了。还不知直接买人民币理财";
}

- (void)createViews{
    [self.contentView addSubview:self.msgImgView];
    [self.contentView addSubview:self.msgCountLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.userIconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dotLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.contentView addSubview:self.discontentView];
    [self.discontentView addSubview:self.nickNameLabel];
    [self.discontentView addSubview:self.discontentLabel];
    
    [self.contentView addSubview:self.contentLabel];
    
    [self.msgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.equalTo(self.contentView).offset(12);
    }];
    
    [self.msgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.msgImgView.mas_centerX);
        make.top.equalTo(self.msgImgView.mas_bottom).offset(4);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.msgImgView.mas_right).offset(14);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    
    [self.userIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
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
    
    [self.discontentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.userIconImgView.mas_bottom).offset(6);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discontentView).offset(10);
        make.top.equalTo(self.discontentView).offset(8);
    }];
    
    [self.discontentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel.mas_right).offset(6);
        make.top.equalTo(self.discontentView).offset(8);
        make.right.equalTo(self.discontentView).offset(-10);
        make.bottom.equalTo(self.discontentView).offset(-8);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.discontentView.mas_bottom).offset(6);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-16);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    
}

- (UIImageView *)msgImgView{
    if (!_msgImgView) {
        _msgImgView = [[UIImageView alloc] init];
        [_msgImgView setImage:[UIImage imageNamed:@"message"]];
    }
    return _msgImgView;
}

- (UILabel *)msgCountLabel{
    if (!_msgCountLabel) {
        _msgCountLabel = [[UILabel alloc] init];
        _msgCountLabel.textColor = Color16(0x5B5B5B);
        _msgCountLabel.font = [UIFont systemFontOfSize:12];
        _msgCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _msgCountLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
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

- (UIView *)discontentView{
    if (!_discontentView) {
        _discontentView = [[UIView alloc] init];
        _discontentView.backgroundColor = Color16(0xF8F8F8);
        _discontentView.layer.masksToBounds = YES;
        _discontentView.layer.cornerRadius = 4;
    }
    return _discontentView;
}

- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = Color16(0x585858);
        _nickNameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _nickNameLabel;
}

- (UILabel *)discontentLabel{
    if (!_discontentLabel) {
        _discontentLabel = [[UILabel alloc] init];
        _discontentLabel.textColor = Color16(0x797979);
        _discontentLabel.font = [UIFont systemFontOfSize:10];
        _discontentLabel.numberOfLines = 3;
    }
    return _discontentLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = Color16(0x5D5D5D);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}


@end

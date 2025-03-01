//
//  SLProfileDynamicTableViewCell.m
//  digg
//
//  Created by Tim Bao on 2025/1/8.
//

#import "SLProfileDynamicTableViewCell.h"
#import <Masonry/Masonry.h>
#import "SLGeneralMacro.h"
#import "CaocaoButton.h"
#import "SLHomeTagView.h"
#import "SDWebImage.h"
#import "SLColorManager.h"

@interface SLProfileDynamicTableViewCell ()

@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) CaocaoButton *likeBtn;
@property (nonatomic, strong) UILabel *dot1Label;
@property (nonatomic, strong) CaocaoButton *dislikeBtn;
@property (nonatomic, strong) UILabel *dot2Label;
@property (nonatomic, strong) CaocaoButton *messageBtn;
@property (nonatomic, strong) UILabel *dot3Label;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) SLArticleTodayEntity *entity;
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation SLProfileDynamicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [SLColorManager primaryBackgroundColor];
        self.contentView.backgroundColor = [SLColorManager primaryBackgroundColor];
        [self createViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.likeBtn layoutSubviews];
    [self.dislikeBtn layoutSubviews];
    [self.messageBtn layoutSubviews];
}

- (void)updateWithEntity:(SLArticleTodayEntity *)entiy{
    self.entity = entiy;
    if (entiy.avatar) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:entiy.avatar]];
    } else if (entiy.userAvatar) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:entiy.userAvatar]];
    }
    self.nickNameLabel.text = entiy.username;
    if ([entiy.actionName length] > 0) {
        //格式化时间
        NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:entiy.gmtCreate/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateStr = [dateFormatter stringFromDate: detailDate];
        self.timeLabel.text = [NSString stringWithFormat:@"%@ · %@", dateStr, entiy.actionName];
    }

    self.titleLabel.text = entiy.title;
    CGFloat lineSpacing = 6;
    NSString *contentStr = entiy.content;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    [attributes setObject:[SLColorManager cellContentColor] forKey:NSForegroundColorAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    if (contentStr != nil) {
        self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:contentStr attributes:attributes];
    }

    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",entiy.likeCnt] forState:UIControlStateNormal];
    [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%ld",entiy.dislikeCnt] forState:UIControlStateNormal];
    [self.messageBtn setTitle:[NSString stringWithFormat:@"%ld",entiy.commentsCnt] forState:UIControlStateNormal];

    if (!self.isSelected) {
        //重置
        self.likeBtn.selected = false;
        self.dislikeBtn.selected = false;
    }
    
    [self layoutIfNeeded];
}

- (void)createViews {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.likeBtn];
    [self.contentView addSubview:self.dot1Label];
    [self.contentView addSubview:self.dislikeBtn];
    [self.contentView addSubview:self.dot2Label];
    [self.contentView addSubview:self.messageBtn];
    [self.contentView addSubview:self.dot3Label];
    [self.contentView addSubview:self.checkBtn];
    [self.contentView addSubview:self.lineView];
    
    CGFloat offset = 16;

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(offset);
        make.top.equalTo(self.contentView).offset(offset);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(12);
        make.centerY.equalTo(self.avatarImageView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel.mas_right).offset(8);
        make.centerY.equalTo(self.avatarImageView);
        make.right.lessThanOrEqualTo(self.contentView).offset(-offset);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(12);
        make.left.equalTo(self.contentView).offset(offset);
        make.right.equalTo(self.contentView).offset(-offset);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(offset);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView).offset(-offset);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(offset);
        make.bottom.equalTo(self.lineView).offset(-8);
    }];
    
    [self.dot1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 16));
        make.centerY.equalTo(self.likeBtn.mas_centerY);
        make.left.equalTo(self.likeBtn.mas_right).offset(12);
    }];
    
    [self.dislikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dot1Label.mas_right).offset(12);
        make.centerY.equalTo(self.likeBtn.mas_centerY);
        make.height.equalTo(self.likeBtn.mas_height);
    }];
    
    [self.dot2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 16));
        make.centerY.equalTo(self.dislikeBtn.mas_centerY);
        make.left.equalTo(self.dislikeBtn.mas_right).offset(12);
    }];
   
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dot2Label.mas_right).offset(12);
        make.centerY.equalTo(self.likeBtn.mas_centerY);
        make.height.equalTo(self.likeBtn.mas_height);
    }];
    
    [self.dot3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 16));
        make.centerY.equalTo(self.messageBtn.mas_centerY);
        make.left.equalTo(self.messageBtn.mas_right).offset(12);
    }];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dot3Label.mas_right).offset(12);
        make.centerY.equalTo(self.likeBtn.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(offset);
        make.right.equalTo(self.contentView).offset(-offset);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)likeBtnAction:(id)sender {
    if (!self.likeBtn.selected) {
        if (self.likeClick) {
            self.likeClick(self.entity);
        }
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",self.entity.likeCnt + 1] forState:UIControlStateNormal];
        [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%ld",self.entity.dislikeCnt] forState:UIControlStateNormal];
        
        self.likeBtn.selected = YES;
        self.dislikeBtn.selected = NO;
    } else {
        if (self.cancelLikeClick) {
            self.cancelLikeClick(self.entity);
        }
        if (self.likeBtn.selected) {
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",self.entity.likeCnt] forState:UIControlStateNormal];
        }
        self.likeBtn.selected = NO;
    }
    
    [self layoutIfNeeded];
}

- (void)dislikeBtnAction:(id)sender {
    if (!self.dislikeBtn.selected) {
        if (self.dislikeClick) {
            self.dislikeClick(self.entity);
        }
        
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",self.entity.likeCnt] forState:UIControlStateNormal];
        [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%ld",self.entity.dislikeCnt+1] forState:UIControlStateNormal];
        self.likeBtn.selected = NO;
        self.dislikeBtn.selected = YES;
    } else {
        if (self.cancelDisLikeClick) {
            self.cancelDisLikeClick(self.entity);
        }
        if (self.dislikeBtn.selected) {
            [self.dislikeBtn setTitle:[NSString stringWithFormat:@"%ld",self.entity.dislikeCnt] forState:UIControlStateNormal];
        }
        self.dislikeBtn.selected = NO;
    }
    
    [self layoutIfNeeded];
}

- (void)checkBtnAction:(id)sender{
    if (self.checkDetailClick) {
        self.checkDetailClick(self.entity);
    }
}

#pragma mark - Property
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = UIColor.lightGrayColor;
        _avatarImageView.layer.cornerRadius = 13;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nickNameLabel {
    if(!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
        _nickNameLabel.textColor = [SLColorManager cellNickNameColor];
    }
    return _nickNameLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = Color16(0xB6B6B6);
        [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [SLColorManager cellTitleColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 2;
        _contentLabel.textColor = [SLColorManager cellContentColor];
    }
    return _contentLabel;
}

- (CaocaoButton *)likeBtn {
    if(!_likeBtn){
        _likeBtn = [[CaocaoButton alloc] init];
        _likeBtn.imageButtonType = CaocaoRightImageButton;
        _likeBtn.margin = 4;
        [_likeBtn setTitle:@"--" forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_likeBtn setTitleColor:[SLColorManager caocaoButtonTextColor] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"agree_selected"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_likeBtn sizeToFit];
    }
    return _likeBtn;
}

- (CaocaoButton *)dislikeBtn {
    if (!_dislikeBtn) {
        _dislikeBtn = [[CaocaoButton alloc] init];
        _dislikeBtn.margin = 4;
        _dislikeBtn.imageButtonType = CaocaoRightImageButton;
        [_dislikeBtn setTitle:@"--" forState:UIControlStateNormal];
        _dislikeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_dislikeBtn setTitleColor:[SLColorManager caocaoButtonTextColor] forState:UIControlStateNormal];
        [_dislikeBtn setImage:[UIImage imageNamed:@"disagree"]forState:UIControlStateNormal];
        [_dislikeBtn setImage:[UIImage imageNamed:@"disagree_selected"] forState:UIControlStateSelected];
        [_dislikeBtn addTarget:self action:@selector(dislikeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_dislikeBtn sizeToFit];
    }
    return _dislikeBtn;
}

- (CaocaoButton *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [[CaocaoButton alloc] init];
        _messageBtn.margin = 4;
        _messageBtn.imageButtonType = CaocaoRightImageButton;
        [_messageBtn setTitle:@"--" forState:UIControlStateNormal];
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_messageBtn setTitleColor:[SLColorManager caocaoButtonTextColor] forState:UIControlStateNormal];
        [_messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
        [_messageBtn sizeToFit];
    }
    return _messageBtn;
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [[UIButton alloc] init];
        [_checkBtn setTitle:@"查看" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:[SLColorManager cellContentColor] forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}

- (UILabel *)dot1Label {
    if (!_dot1Label) {
        _dot1Label = [[UILabel alloc] init];
        _dot1Label.text = @"·";
        _dot1Label.textColor = Color16(0xA0A0A0);
        _dot1Label.font = [UIFont systemFontOfSize:12];
    }
    return _dot1Label;
}

- (UILabel *)dot2Label {
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [SLColorManager cellDivideLineColor];
    }
    return _lineView;
}

@end

//
//  SLProfileHeaderView.m
//  digg
//
//  Created by Tim Bao on 2025/1/5.
//

#import "SLProfileHeaderView.h"
#import "Masonry.h"
#import "SLGeneralMacro.h"
#import "SLTagCollectionViewCell.h"
#import "SDWebImage.h"

@interface SLProfileHeaderView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView* headerBGView;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UIButton* editorButton;
@property (nonatomic, strong) UIButton* focusButton;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* briefLabel;

@property (nonatomic, strong) UILabel *followLabel;
@property (nonatomic, strong) UILabel *attentionLabel;
@property (nonatomic, strong) UILabel *collectLabel;

@property (nonatomic, strong) UILabel* tagLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SLProfileHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        
        [self addSubview:self.headerBGView];
        self.contentView.clipsToBounds = NO;
        self.contentView.layer.cornerRadius = 16.0;
        self.contentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        [self addSubview:self.contentView];

        [self.contentView addSubview:self.avatarImageView];

        [self.contentView addSubview:self.editorButton];

        [self.contentView addSubview:self.focusButton];

        [self.contentView addSubview:self.nameLabel];

        [self.contentView addSubview:self.briefLabel];

        [self.contentView addSubview:self.followLabel];

        [self.contentView addSubview:self.attentionLabel];

        [self.contentView addSubview:self.collectLabel];

        [self.contentView addSubview:self.tagLabel];

        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - Update
- (void)updateConstraints {
    
    [self.headerBGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(self.headerBGView.mas_bottom);
    }];
    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14);
        make.top.equalTo(self.contentView.mas_top).offset(-30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.editorButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    [self.focusButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(12);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [self.briefLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [self.followLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.briefLabel.mas_bottom).offset(16);
        make.left.equalTo(self.contentView).offset(16);
    }];
    [self.attentionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.followLabel);
        make.left.equalTo(self.followLabel.mas_right).offset(20);
        make.height.equalTo(self.followLabel);
    }];
    [self.collectLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.followLabel);
        make.left.equalTo(self.attentionLabel.mas_right).offset(20);
        make.height.equalTo(self.followLabel);
    }];
    [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.followLabel.mas_bottom).offset(16);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagLabel.mas_bottom).offset(12);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.mas_equalTo(31);
        make.bottom.equalTo(self.contentView);
    }];
    
    [super updateConstraints];
}

- (void)setEntity:(SLProfileEntity *)entity {
    _entity = entity;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:entity.avatar]
                 placeholderImage:[UIImage imageNamed:@"profile_header_bg"]];
    
    self.nameLabel.text = entity.userName;
    self.briefLabel.text = entity.desc;
    if (entity.isSelf) {
        [self.focusButton setHidden:YES];
        [self.editorButton setHidden:NO];
    } else {
        [self.focusButton setHidden:NO];
        [self.editorButton setHidden:YES];
        if (entity.hasFollow) {
            [self.focusButton setTitle:@"正在关注" forState:UIControlStateNormal];
        } else {
            [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
        }
    }
    NSString* txt = [NSString stringWithFormat:@"%ld 粉丝", entity.followCnt];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
    // 设置字体和颜色
    UIFont *bigFont = [UIFont systemFontOfSize:18];
    UIColor *bigColor = [UIColor blackColor];
    UIFont *smallFont = [UIFont systemFontOfSize:12];
    UIColor *smallColor = Color16(0x999999);
    
    [attributedString addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, txt.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:bigColor range:NSMakeRange(0, txt.length)];
    
    NSRange range = [txt rangeOfString:@"粉丝"];
    [attributedString addAttribute:NSFontAttributeName value:smallFont range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:smallColor range:range];
    self.followLabel.attributedText = attributedString;
    
    NSString* attentionString = [NSString stringWithFormat:@"%ld 关注", entity.beFollowedCnt];
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:attentionString];
    
    [attributedString1 addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, attentionString.length)];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:bigColor range:NSMakeRange(0, attentionString.length)];
    
    NSRange range1 = [attentionString rangeOfString:@"关注"];
    [attributedString1 addAttribute:NSFontAttributeName value:smallFont range:range1];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:smallColor range:range1];
    self.attentionLabel.attributedText = attributedString;
    
    NSString* collectionString = [NSString stringWithFormat:@"%ld 点赞", entity.likedArticleCnt];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:collectionString];
    
    [attributedString2 addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, collectionString.length)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:bigColor range:NSMakeRange(0, collectionString.length)];
    
    NSRange range2 = [collectionString rangeOfString:@"点赞"];
    [attributedString2 addAttribute:NSFontAttributeName value:smallFont range:range2];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:smallColor range:range2];
    self.collectLabel.attributedText = attributedString2;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.entity.labels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SLTagCollectionViewCell" forIndexPath:indexPath];
    cell.label = self.entity.labels[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UI Elements
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default_img"]];
        _avatarImageView.layer.cornerRadius = 30;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.zPosition = 1; // 提高层级
    }
    return _avatarImageView;
}

- (UIButton *)editorButton {
    if (!_editorButton) {
        _editorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editorButton.layer.cornerRadius = 15;
        _editorButton.layer.masksToBounds = YES;
        _editorButton.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.15].CGColor;
        _editorButton.layer.borderWidth = 1;
        [_editorButton setTitle:@"编辑信息" forState:UIControlStateNormal];
        [_editorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _editorButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editorButton setHidden: YES];
    }
    return _editorButton;
}

- (UIButton *)focusButton {
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _focusButton.layer.cornerRadius = 15;
        _focusButton.layer.masksToBounds = YES;
        _focusButton.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.15].CGColor;
        _focusButton.layer.borderWidth = 1;
        [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [_focusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _focusButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_focusButton setHidden: NO];
    }
    return _focusButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = UIColor.blackColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nameLabel;
}

- (UILabel *)briefLabel {
    if (!_briefLabel) {
        _briefLabel = [[UILabel alloc] init];
        _briefLabel.text = @"";
        _briefLabel.textColor = Color16(0x222222);
        _briefLabel.font = [UIFont systemFontOfSize:12];
        _briefLabel.numberOfLines = 0;
    }
    return _briefLabel;
}

- (UILabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [[UILabel alloc] init];
        NSString* txt = @"0 粉丝";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
        // 设置字体和颜色
        UIFont *bigFont = [UIFont systemFontOfSize:18];
        UIColor *bigColor = [UIColor blackColor];
        UIFont *smallFont = [UIFont systemFontOfSize:12];
        UIColor *smallColor = Color16(0x999999);
        
        [attributedString addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, txt.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:bigColor range:NSMakeRange(0, txt.length)];
        
        NSRange range = [txt rangeOfString:@"粉丝"];
        [attributedString addAttribute:NSFontAttributeName value:smallFont range:range];
        [attributedString addAttribute:NSForegroundColorAttributeName value:smallColor range:range];
        _followLabel.attributedText = attributedString;
    }
    return _followLabel;
}

- (UILabel *)attentionLabel {
    if (!_attentionLabel) {
        _attentionLabel = [[UILabel alloc] init];
        NSString* txt = @"0 关注";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
        // 设置字体和颜色
        UIFont *bigFont = [UIFont systemFontOfSize:18];
        UIColor *bigColor = [UIColor blackColor];
        UIFont *smallFont = [UIFont systemFontOfSize:12];
        UIColor *smallColor = Color16(0x999999);
        
        [attributedString addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, txt.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:bigColor range:NSMakeRange(0, txt.length)];
        
        NSRange range = [txt rangeOfString:@"关注"];
        [attributedString addAttribute:NSFontAttributeName value:smallFont range:range];
        [attributedString addAttribute:NSForegroundColorAttributeName value:smallColor range:range];
        _attentionLabel.attributedText = attributedString;
    }
    return _attentionLabel;
}

- (UILabel *)collectLabel {
    if (!_collectLabel) {
        _collectLabel = [[UILabel alloc] init];
        NSString* txt = @"0 点赞";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
        
        // 设置字体和颜色
        UIFont *bigFont = [UIFont systemFontOfSize:18];
        UIColor *bigColor = [UIColor blackColor];
        UIFont *smallFont = [UIFont systemFontOfSize:12];
        UIColor *smallColor = Color16(0x999999);
        
        [attributedString addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, txt.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:bigColor range:NSMakeRange(0, txt.length)];
        
        NSRange range = [txt rangeOfString:@"点赞"];
        [attributedString addAttribute:NSFontAttributeName value:smallFont range:range];
        [attributedString addAttribute:NSForegroundColorAttributeName value:smallColor range:range];
        _collectLabel.attributedText = attributedString;
    }
    return _collectLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.text = @"我的标签";
        _tagLabel.textColor = UIColor.blackColor;
        _tagLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _tagLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.estimatedItemSize = CGSizeMake(93, 31);
        layout.minimumInteritemSpacing = 12;
        layout.minimumLineSpacing = 12;
        
        // 创建 UICollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SLTagCollectionViewCell class] forCellWithReuseIdentifier:@"SLTagCollectionViewCell"];
    }
    return _collectionView;
}

- (UIView *)headerBGView {
    if (!_headerBGView) {
        _headerBGView = [UIView new];
        _headerBGView.backgroundColor = UIColor.clearColor;
    }
    return _headerBGView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

@end

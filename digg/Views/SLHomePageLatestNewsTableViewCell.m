//
//  SLHomePageLatestNewsTableViewCell.m
//  digg
//
//  Created by hey on 2024/10/11.
//

#import "SLHomePageLatestNewsTableViewCell.h"
#import <Masonry/Masonry.h>
#import "SLGeneralMacro.h"

@interface SLHomePageLatestNewsTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SLHomePageLatestNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
    }];
}

- (void)updateWithEntity:(SLArticleTodayEntity *)entiy{
    self.titleLabel.text = entiy.title;
    self.contentLabel.text = [NSString stringWithFormat:@"%@ · %@ · %@  · %@  · %@",entiy.source,entiy.username,[self timeStmpWith:entiy.gmtModified],[NSString stringWithFormat:@"%ld讨论",entiy.commentsCnt],[NSString stringWithFormat:@"%ld人认为有用",entiy.likeCnt]];
//    self.contentLabel.text = @"文艺复兴 · 达芬奇 · 18小时前  · 12讨论 · 99人认为有用";
}

- (NSString *)timeStmpWith:(NSTimeInterval)gmtModified{
    NSDate *currentDate = [NSDate date];
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:gmtModified/1000];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:targetDate toDate:currentDate options:0];
    NSInteger diffInDays = components.day;
    
    if (diffInDays == 0) {
        return @"今天";
    } else if (diffInDays == 1) {
        return @"昨天";
    } else {
        return [NSString stringWithFormat:@"%ld天前", (long)diffInDays];
    }
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
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 2;
        _contentLabel.textColor = Color16(0x585858);
    }
    return _contentLabel;
}

@end

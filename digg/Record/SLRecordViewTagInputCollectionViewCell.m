//
//  SLRecordViewTagInputCollectionViewCell.m
//  digg
//
//  Created by Tim Bao on 2025/1/17.
//

#import "SLRecordViewTagInputCollectionViewCell.h"
#import "Masonry.h"
#import "SLGeneralMacro.h"

@interface SLRecordViewTagInputCollectionViewCell()

@property (nonatomic, strong) UIView *bashOutlineView;
@property (nonatomic, strong) UIImageView* addIconImageView;
@property (nonatomic, strong) UILabel* addNameLabel;
@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation SLRecordViewTagInputCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.bashOutlineView];
//    [self.bashOutlineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
    [self.bashOutlineView addSubview:self.addIconImageView];
//    [self.addIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bashOutlineView).offset(15);
//        make.centerY.equalTo(self.bashOutlineView);
//        make.size.mas_equalTo(CGSizeMake(12, 12));
//    }];
//    CGSize size = [self.addNameLabel sizeThatFits:CGSizeZero];
    [self.bashOutlineView addSubview:self.addNameLabel];
//    [self.addNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.addIconImageView.mas_right).offset(5);
//        make.centerY.top.bottom.equalTo(self.bashOutlineView);
//        make.height.mas_equalTo(25);
//        make.width.mas_equalTo(size.width);
//        make.right.equalTo(self.bashOutlineView).offset(-15);
//    }];
    [self.contentView addSubview:self.inputField];
//    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
    [self updateConstraints];
}

- (void)configDataWithIndex:(NSInteger)index {
    if (index == 0) {
        self.addNameLabel.text = @"标签";
    } else {
        self.addNameLabel.text = [NSString stringWithFormat:@"%ld级标签", index];
    }
    [self updateConstraints];
}

- (void)startInput:(BOOL)start {
    if (start) {
        [self.bashOutlineView setHidden:YES];
        [self.addIconImageView setHidden:YES];
        [self.addNameLabel setHidden:YES];
        [self.borderLayer setHidden:YES];
    } else {
        [self.bashOutlineView setHidden:NO];
        [self.addIconImageView setHidden:NO];
        [self.addNameLabel setHidden:NO];
        [self.borderLayer setHidden:NO];
    }
}

- (void)updateConstraints {

    [self.bashOutlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.addIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bashOutlineView).offset(15);
        make.centerY.equalTo(self.bashOutlineView);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    CGSize size = [self.addNameLabel sizeThatFits:CGSizeZero];
    [self.addNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addIconImageView.mas_right).offset(5);
        make.centerY.top.bottom.equalTo(self.bashOutlineView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(size.width);
        make.right.equalTo(self.bashOutlineView).offset(-15);
    }];
    [self.inputField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.borderLayer.bounds = self.bashOutlineView.bounds;
    self.borderLayer.position = CGPointMake(CGRectGetMidX(self.bashOutlineView.bounds), CGRectGetMidY(self.bashOutlineView.bounds));
    self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.borderLayer.bounds cornerRadius:12.5].CGPath;
//    self.borderLayer.lineWidth = 6 / [[UIScreen mainScreen] scale];
    self.borderLayer.lineDashPattern = @[@(3), @(1)];//前边是虚线的长度，后边是虚线之间空隙的长度
    self.borderLayer.lineDashPhase = 1;
    //实线边框
    self.borderLayer.fillColor = [UIColor clearColor].CGColor;
    self.borderLayer.strokeColor = Color16(0xDCDCDC).CGColor;
}

#pragma mark - UI Elements
- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [[UITextField alloc] initWithFrame:CGRectZero];
        _inputField.borderStyle = UITextBorderStyleNone;
        _inputField.font = [UIFont systemFontOfSize:14];
    }
    return _inputField;
}

- (UIView *)bashOutlineView {
    if (!_bashOutlineView) {
        _bashOutlineView = [UIView new];
        _bashOutlineView.backgroundColor = UIColor.clearColor;
//        _bashOutlineView.clipsToBounds = YES;
//        _bashOutlineView.layer.cornerRadius = 12.5;
        
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        [self.layer addSublayer:borderLayer];
        self.borderLayer = borderLayer;
    }
    return _bashOutlineView;
}

- (UIImageView *)addIconImageView {
    if (!_addIconImageView) {
        _addIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_tag_icon"]];
    }
    return _addIconImageView;
}

- (UILabel *)addNameLabel {
    if (!_addNameLabel) {
        _addNameLabel = [[UILabel alloc] init];
        _addNameLabel.text = @"标签";
        _addNameLabel.textColor = Color16(0x868686);
        _addNameLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _addNameLabel;
}

@end

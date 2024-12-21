//
//  SLHomeTagView.m
//  digg
//
//  Created by hey on 2024/11/24.
//

#import "SLHomeTagView.h"
#import <Masonry/Masonry.h>
#import "SLGeneralMacro.h"

@interface SLHomeTagView ()

@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation SLHomeTagView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = Color16A(0xFF1852, 0.1);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
        [self addSubview:self.tagLabel];
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(4);
            make.right.equalTo(self).offset(-4);
            make.bottom.equalTo(self).offset(-4);
        }];
    }
    return self;
}

- (void)updateWithLabel:(NSString *)label{
    self.tagLabel.text = label;
}

- (UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = Color16(0xFF1852);
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    return _tagLabel;
}

@end

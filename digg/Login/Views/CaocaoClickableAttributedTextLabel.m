//
//  CaocaoClickableAttributedTextLabel.m
//  AESCrypt-ObjC
//
//  Created by zhangjin on 2022/3/7.
//

#import "CaocaoClickableAttributedTextLabel.h"
#import <MPITextKit/MPITextKit.h>
#import <Masonry/Masonry.h>

@interface CaocaoClickableAttributedTextConfigModel ()

@property (nonatomic, copy) NSString *linkValue;

@end

@implementation CaocaoClickableAttributedTextConfigModel

- (NSAttributedString *)getShowAttributedStringWithIndex:(NSInteger)index{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange range = NSMakeRange(0, self.text.length);
    [attributedString addAttribute:NSFontAttributeName value:self.font range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:self.color range:range];
    if (self.clickedCallBack) {
        self.linkValue = [NSString stringWithFormat:@"%ld",index];
        MPITextLink *link = [[MPITextLink alloc] initWithValue:self.linkValue];
        [attributedString addAttribute:MPITextLinkAttributeName value:link range:range];
        [attributedString addAttribute:MPITextHighlightedAttributeName value:@(NO) range:range];
    }
    return attributedString.copy;
}

@end

@interface CaocaoClickableAttributedTextLabel () <MPILabelDelegate>

@property (nonatomic, strong) MPILabel *attributedTextLabel;

@property (nonatomic, copy) NSArray *configModelsList;

@end

@implementation CaocaoClickableAttributedTextLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadSubviews];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Load Subviews

/**
 添加子控件
 */
- (void)loadSubviews {
    [self addSubview:self.attributedTextLabel];
}

/**
 添加约束布局
 */
- (void)setupConstraints {
    [self.attributedTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.attributedTextLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.attributedTextLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
}

- (void)showWithAttributedTextConfigModels:(NSArray<CaocaoClickableAttributedTextConfigModel *> *)configModels {
    self.configModelsList = configModels;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [self.configModelsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CaocaoClickableAttributedTextConfigModel *model = (CaocaoClickableAttributedTextConfigModel *)obj;
        [attributedString appendAttributedString:[model getShowAttributedStringWithIndex:idx]];
    }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    self.attributedTextLabel.attributedText = attributedString;
}

#pragma mark - MPILabelDelegate
- (void)label:(MPILabel *)label didInteractWithLink:(MPITextLink *)link forAttributedText:(NSAttributedString *)attributedText inRange:(NSRange)characterRange interaction:(MPITextItemInteraction)interaction {
    
    NSInteger selectIndex = [(NSString *)link.value integerValue];
    CaocaoClickableAttributedTextConfigModel *model = [self.configModelsList objectAtIndex:selectIndex];
    if (model.clickedCallBack) {
        model.clickedCallBack();
    }
}


#pragma mark - Setter、Getter
#pragma mark setter


#pragma mark getter

- (MPILabel *)attributedTextLabel {
    if (!_attributedTextLabel) {
        _attributedTextLabel = [[MPILabel alloc] init];
        _attributedTextLabel.textAlignment = NSTextAlignmentLeft;
        _attributedTextLabel.numberOfLines = 0;
        _attributedTextLabel.delegate = self;
        _attributedTextLabel.textVerticalAlignment = MPITextVerticalAlignmentTop;
        _attributedTextLabel.font = [UIFont systemFontOfSize:12];
        _attributedTextLabel.isAccessibilityElement = YES;
    }
    return _attributedTextLabel;
}

- (NSAttributedString *)resultAttributedString {
    return self.attributedTextLabel.attributedText;;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    self.attributedTextLabel.textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment {
    return self.attributedTextLabel.textAlignment;
}

@end

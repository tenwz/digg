//
//  CaocaoClickableAttributedTextLabel.h
//  AESCrypt-ObjC
//
//  Created by zhangjin on 2022/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CaocaoClickableAttributedTextConfigModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void(^clickedCallBack)(void);
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIFont *font;

@end

@interface CaocaoClickableAttributedTextLabel : UIView

@property (nonatomic, copy, readonly) NSAttributedString *resultAttributedString;

@property (nonatomic, assign) NSTextAlignment textAlignment;

- (void)showWithAttributedTextConfigModels:(NSArray<CaocaoClickableAttributedTextConfigModel *> *)configModels;

@end

NS_ASSUME_NONNULL_END

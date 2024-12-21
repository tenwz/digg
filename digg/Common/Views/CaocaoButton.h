//
//  CaocaoButton.h
//  CaocaoBaseCoreFlowForCallCar
//
//  Created by 梁世伟 on 2021/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CaocaoImageButtonType) {
    CaocaoCenterImageButton = 0, //中间图,无title
    CaocaoLeftImageButton,       //左图 右title
    CaocaoUpImageButton,         //上图 下title
    CaocaoRightImageButton,       //右图 左title
    CaocaoLeftImageButtonAndLeftAligment,   //左图 右title 左对齐
    CaocaoRightImageButtonAndRightAligment   //右图 右title 右对齐
};

@interface CaocaoButton : UIButton
@property (nonatomic, assign) CaocaoImageButtonType imageButtonType;
///左右间距  默认0
@property (nonatomic, assign) CGFloat margin;

@end

NS_ASSUME_NONNULL_END

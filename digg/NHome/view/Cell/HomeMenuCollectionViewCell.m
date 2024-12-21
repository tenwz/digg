//
//  HomeMenuCollectionViewCell.m
//  JRTTDemo
//
//  Created by 赵 on 2018/1/26.
//  Copyright © 2018年 袁书辉. All rights reserved.
//


#import "TitleModel.h"
#import "HomeMenuCollectionViewCell.h"
#import "SLHomeCategoryModel.h"
#import "SLGeneralMacro.h"

@implementation HomeMenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)bindData:(id)data indexPath:(NSIndexPath *)indexPath
{
    SLHomeCategoryModel * title = data[indexPath.row];
    self.title.text = title.categoryName;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.title.textColor = [UIColor blackColor];
        self.title.font = [UIFont systemFontOfSize:18];
    }else{
        self.title.textColor = Color16(0x7B7B7B);
        self.title.font = [UIFont systemFontOfSize:16];
    }
}



@end

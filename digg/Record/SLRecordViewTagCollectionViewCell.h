//
//  SLRecordViewTagCollectionViewCell.h
//  digg
//
//  Created by Tim Bao on 2025/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRecordViewTagCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^removeTag)(NSString *tagName, NSInteger index);

@property (nonatomic, strong) UIButton* closeButton;

- (void)configDataWithTagName:(NSString *)name index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END

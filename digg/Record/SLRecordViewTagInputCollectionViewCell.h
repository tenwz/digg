//
//  SLRecordViewTagInputCollectionViewCell.h
//  digg
//
//  Created by Tim Bao on 2025/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRecordViewTagInputCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UITextField *inputField;

- (void)configDataWithIndex:(NSInteger)index;
- (void)startInput:(BOOL)start;

@end

NS_ASSUME_NONNULL_END

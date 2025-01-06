//
//  SLSegmentControl.h
//  digg
//
//  Created by Tim Bao on 2025/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SLSegmentControl;

@protocol SLSegmentControlDelegate <NSObject>

@optional
- (void)segmentControl:(SLSegmentControl *)segmentControl didSelectIndex:(NSInteger)index;

@end

@interface SLSegmentControl : UIView

@property (nonatomic, weak) id<SLSegmentControlDelegate> delegate;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END

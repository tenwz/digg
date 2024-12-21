//
//  SLHomePageDiscussionTableViewCell.h
//  digg
//
//  Created by hey on 2024/10/12.
//

#import <UIKit/UIKit.h>
#import "SLArticleTodayEntity.h"

@interface SLHomePageProductionTableViewCell : UITableViewCell

- (void)updateWithEntity:(SLArticleTodayEntity *)entity;

@property (nonatomic, copy) void(^likeClick)(SLArticleTodayEntity *entity);

@property (nonatomic, copy) void(^dislikeClick)(SLArticleTodayEntity *entity);

@end



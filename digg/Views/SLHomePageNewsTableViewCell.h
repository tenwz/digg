//
//  SLHomePageNewsTableViewCell.h
//  digg
//
//  Created by hey on 2024/9/26.
//

#import <UIKit/UIKit.h>
#import "SLArticleTodayEntity.h"

@interface SLHomePageNewsTableViewCell : UITableViewCell

- (void)updateWithEntity:(SLArticleTodayEntity *)entiy;

@property (nonatomic, copy) void(^likeClick)(SLArticleTodayEntity *entity);

@property (nonatomic, copy) void(^dislikeClick)(SLArticleTodayEntity *entity);

@property (nonatomic, copy) void(^cancelLikeClick)(SLArticleTodayEntity *entity);

@property (nonatomic, copy) void(^cancelDisLikeClick)(SLArticleTodayEntity *entity);

@property (nonatomic, copy) void(^checkDetailClick)(SLArticleTodayEntity *entity);

@property (nonatomic, copy) void(^labelClick)(SLArticleTodayEntity *entity);

@end

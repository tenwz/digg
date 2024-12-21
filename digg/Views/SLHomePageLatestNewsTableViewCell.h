//
//  SLHomePageLatestNewsTableViewCell.h
//  digg
//
//  Created by hey on 2024/10/11.
//

#import <UIKit/UIKit.h>
#import "SLArticleTodayEntity.h"

@interface SLHomePageLatestNewsTableViewCell : UITableViewCell

- (void)updateWithEntity:(SLArticleTodayEntity *)entiy;

@end

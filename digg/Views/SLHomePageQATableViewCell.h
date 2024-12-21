//
//  SLHomePageDiscussionTableViewCell.h
//  digg
//
//  Created by hey on 2024/10/12.
//

#import <UIKit/UIKit.h>
#import "SLCommentFeedEntity.h"
//问答栏目,类名取得不太好

@interface SLHomePageQATableViewCell : UITableViewCell

- (void)updateWithEntity:(SLCommentFeedEntity *)entity;

@end


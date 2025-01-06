//
//  SLProfileEntity.h
//  digg
//
//  Created by Tim Bao on 2025/1/6.
//

#import <Foundation/Foundation.h>
#import "SLArticleTodayEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLProfileEntity : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *bgImage;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *desc; //description
@property (nonatomic, assign) NSInteger followCnt;
@property (nonatomic, assign) NSInteger beFollowedCnt;
@property (nonatomic, assign) NSInteger karma; //积分
@property (nonatomic, copy) NSArray<NSString *>* labels;
@property (nonatomic, assign) BOOL isSelf; //self
@property (nonatomic, assign) BOOL hasFollow;
@property (nonatomic, assign) NSInteger submitArticleCnt;
@property (nonatomic, assign) NSInteger likedArticleCnt;
@property (nonatomic, assign) NSInteger commentCnt;
@property (nonatomic, strong) NSArray<SLArticleTodayEntity*>* submitList;
@property (nonatomic, strong) NSArray<SLArticleTodayEntity*>* likeList;
@property (nonatomic, strong) NSArray<SLArticleTodayEntity*>* feedList;

@end

NS_ASSUME_NONNULL_END

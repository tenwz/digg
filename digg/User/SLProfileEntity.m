//
//  SLProfileEntity.m
//  digg
//
//  Created by Tim Bao on 2025/1/6.
//

#import "SLProfileEntity.h"

@implementation SLProfileEntity

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isSelf" : @"self",
           @"desc" : @"description"
           };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
            @"submitList" : [SLArticleTodayEntity class],
            @"likeList" : [SLArticleTodayEntity class],
            @"feedList" : [SLArticleTodayEntity class],
          };
}

@end

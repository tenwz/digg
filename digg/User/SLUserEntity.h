//
//  SLUserEntity.h
//  digg
//
//  Created by hey on 2024/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLUserEntity : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *userId;

@end

NS_ASSUME_NONNULL_END

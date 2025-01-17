//
//  SLRecordViewModel.h
//  digg
//
//  Created by Tim Bao on 2025/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRecordViewModel : NSObject

- (void)subimtRecord:(NSString *)title content:(NSString *)content htmlContent:(NSString *)htmlContent labels:(NSArray *)labels resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler;

- (void)updateImage:(NSData *)imageData progress:(void(^)(CGFloat total, CGFloat current))progressHandler resultHandler:(void(^)(BOOL isSuccess, NSError *error))handler;

@end

NS_ASSUME_NONNULL_END

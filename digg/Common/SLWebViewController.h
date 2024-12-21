//
//  SLWebViewController.h
//  digg
//
//  Created by hey on 2024/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLWebViewController : UIViewController

@property (nonatomic, copy) NSString *uxTitle;
@property (nonatomic, copy) void(^loginSucessCallback) ();

- (void)startLoadRequestWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END

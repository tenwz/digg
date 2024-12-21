//
//  CaocaoRootViewController.m
//  CaocaoCommonKit
//
//  Created by luminary on 2017/8/16.
//

#import "CaocaoRootViewController.h"
#import "SLGeneralMacro.h"
#import "UIView+CommonKit.h"


@interface CaocaoRootViewController ()

@property (nonatomic, strong) CaocaoLoadDataDefaultView *dataLoadView;

@end

@implementation CaocaoRootViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - getter

- (CaocaoLoadDataDefaultView *)dataLoadView {
    if (!_dataLoadView) {
        _dataLoadView = [[CaocaoLoadDataDefaultView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _dataLoadView.delegate = self;
    }
    return _dataLoadView;
}


- (void)setDataState:(CaocaoDataLoadState)dataState {
    _dataState = dataState;
    switch (dataState) {
        case CaocaoDataLoadStateNormal:
            [self resetStateToNormal];
            break;
        case CaocaoDataLoadStateLoading:
            [self resetStateToLoading];
            break;
        case CaocaoDataLoadStateError:
            [self resetStateToDone];
            break;
        case CaocaoDataLoadStateEmpty:
            [self resetStateToEmpty];
            break;
        case CaocaoDataLoadStateNetWork:
            [self resetStateToDone];
            break;
        case CaocaoDataLoadStateSuccess:
            [self resetStateToSuccess];
            break;
        default:
            break;
    }
}

#pragma mark - resetState

- (void)resetStateToNormal {
    if (self.dataLoadView.superview) {
        [self.dataLoadView removeFromSuperview];
        self.dataLoadView = nil;
    }
}

- (void)resetStateToLoading {
    if (!self.dataLoadView.superview) {
        [self.view addSubview:self.dataLoadView];
    }
    self.dataLoadView.frame = [self dataStateViewFramePerfer];
    self.dataLoadView.imgUrl = [self dataStateImagePerfer];
    //设置加载文案
    [self.dataLoadView loadStateText:[self dataStateStringPerfer] mode:CaocaoDataModeLoading];
}

- (void)resetStateToEmpty {
    if (!self.dataLoadView.superview) {
        [self.view addSubview:self.dataLoadView];
    }
    self.dataLoadView.frame = [self dataStateViewFramePerfer];
    //设置加载文案
    self.dataLoadView.imgUrl = [self dataStateImagePerfer];
    [self.dataLoadView loadStateText:[self dataStateStringPerfer]  mode:CaocaoDataModeEmpty];
}

- (void)resetStateToDone {
    if (!self.dataLoadView.superview) {
        [self.view addSubview:self.dataLoadView];
    }
    self.dataLoadView.frame = [self dataStateViewFramePerfer];
    //设置加载文案
    self.dataLoadView.imgUrl = [self dataStateImagePerfer];
    [self.dataLoadView loadStateText:[self dataStateStringPerfer] mode:CaocaoDataModeDone];
    [self.dataLoadView loadCallbackText:[self callbackActionStringPerfer] otherCallbackText:[self otherCallbackStringPerfer]];
}

- (void)resetStateToSuccess {
    [self resetStateToNormal];
}

- (NSString *)dataStateStringPerfer {
    if (self.dataState == CaocaoDataLoadStateLoading) {
        return @"数据加载中...";
    } else if (self.dataState == CaocaoDataLoadStateError || self.dataState == CaocaoDataLoadStateNetWork) {
        return @"页面加载失败，请稍后重试";
    }
    return @"暂无数据";
}

- (NSString *)dataStateImagePerfer {
    if (self.dataState == CaocaoDataLoadStateError) {
        return @"common_blank_img_err";
    } else if (self.dataState == CaocaoDataLoadStateNetWork) {
        return @"common_blank_img_network";
    } else if (self.dataState == CaocaoDataLoadStateLoading) {
        return @"screen_loading.gif";
    }
    return @"common_blank_img_default";
}

- (CGRect)dataStateViewFramePerfer {
    return CGRectMake(0, 0, self.view.width, self.view.height);
}

- (NSString *)callbackActionStringPerfer {
    return @"重试";
}

- (NSString *)otherCallbackStringPerfer {
    return @"";
}


#pragma mark - delegate

- (void)dataLoadActionCallback {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

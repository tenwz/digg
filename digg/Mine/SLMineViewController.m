//
//  SLMineViewController.m
//  digg
//
//  Created by hey on 2024/10/6.
//

#import "SLMineViewController.h"
#import "SLLoginViewController.h"
#import "SLPublishViewController.h"
#import <Masonry/Masonry.h>

@interface SLMineViewController ()

@end

@implementation SLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
  
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}




@end

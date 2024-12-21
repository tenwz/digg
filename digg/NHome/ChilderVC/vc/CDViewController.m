//
//  CDViewController.m
//  JRTTDemo
//
//  Created by 赵 on 2018/1/26.
//  Copyright © 2018年 袁书辉. All rights reserved.
//

#import "CDViewController.h"

@interface CDViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _y;
}
@property (strong, nonatomic)  UITableView *tableView;


@end

@implementation CDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
}


@end

//
//  MoreVC.m
//  KissHealth
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "MoreVC.h"
#import "MoreTableView.h"

@interface MoreVC ()
{
    MoreTableView *_tableView;
}

@end

@implementation MoreVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _createView];
    
}

- (void)_createView
{
    _tableView = [[MoreTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

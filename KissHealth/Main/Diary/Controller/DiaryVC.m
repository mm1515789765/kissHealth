//
//  DiaryVC.m
//  KissHealth
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DiaryVC.h"
#import "KHDiaryDetailView.h"
#import "KHDiaryModel.h"

@interface DiaryVC ()
{
    KHDiaryDetailView *_detailView;
}


@end

@implementation DiaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    [self _createDetailView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    KHDiaryModel *sharedModel = [KHDiaryModel sharedDiaryModel];
    
//    NSLog(@"%ld", sharedModel.foodKal);
    [_detailView reloadTableViewData];
    [_detailView layoutSubviews];
}

- (void)_createDetailView
{
    _detailView = [[KHDiaryDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20 - 44) diaryModel:[KHDiaryModel sharedDiaryModel]];
    
//    _detailView.diaryModel = [KHDiaryModel sharedDiaryModel];
    
    [self.view addSubview:_detailView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

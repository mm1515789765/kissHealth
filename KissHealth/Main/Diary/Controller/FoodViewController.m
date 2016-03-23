 //
//  FoodViewController.m
//  KissHealth
//
//  Created by Macx on 16/2/15.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "FoodViewController.h"
#import "KHFoodTableView.h"
#import "KHDiaryModel.h"
#import "FoodModel.h"
#import "KHDiaryDetailModel.h"
#import "KHExciseTableView.h"
#import "ExciseDetailViewController.h"

@interface FoodViewController ()
{
    KHFoodTableView *_foodTableView;
    KHExciseTableView *_exciseTableView;
}

@end

@implementation FoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.view.backgroundColor = [UIColor whiteColor];
    [self _createBackButton];
    [self _createFoodTableView];
}

- (void)_createBackButton
{    
    UIImage *backImg = [UIImage imageNamed:@"ic_nav_arrow_left"];
    UIImage *checkImg = [UIImage imageNamed:@"ic_nav_checkmark_active"];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(barBackButtonAction:)];
    UIBarButtonItem *checkButton = [[UIBarButtonItem alloc] initWithImage:checkImg style:UIBarButtonItemStylePlain target:self action:@selector(barCheckButtonAction:)];
    
    checkButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = checkButton;
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)barBackButtonAction:(UIBarButtonItem *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)barCheckButtonAction:(UIBarButtonItem *)button
{
    _foodEat = _foodTableView.checkFood;
    _exciseDone = _exciseTableView.checkExcise;
    KHDiaryModel *sharedModel = [KHDiaryModel sharedDiaryModel];
    
    if ([self.title isEqualToString:@"早餐"]) {
        [sharedModel.detailModel.breakfastList addObject:_foodEat];
        [self barBackButtonAction:nil];
    }
    
    if ([self.title isEqualToString:@"午餐"]) {
        [sharedModel.detailModel.lunchList addObject:_foodEat];
        [self barBackButtonAction:nil];
    }
    
    if ([self.title isEqualToString:@"晚餐"]) {
        [sharedModel.detailModel.dinnerList addObject:_foodEat];
        [self barBackButtonAction:nil];
    }
    
    if ([self.title isEqualToString:@"零食"]) {
        [sharedModel.detailModel.snackList addObject:_foodEat];
        [self barBackButtonAction:nil];
    }
    
    if ([self.title isEqualToString:@"运动"]) {
//        [self presentViewController:[[ExciseDetailViewController alloc] init] animated:YES completion:^{
//            
//        }];
        
        ExciseDetailViewController *exciseVC = [[ExciseDetailViewController alloc] init];
        exciseVC.exciseModel = _exciseDone;
        
        [self.navigationController pushViewController:exciseVC animated:YES];
    }
    
    
    [sharedModel reloadData];
    
}

- (void)_createFoodTableView
{
    if ([self.title isEqualToString:@"早餐"] || [self.title isEqualToString:@"午餐"] || [self.title isEqualToString:@"晚餐"] || [self.title isEqualToString:@"零食"]) {
        
        _foodTableView = [[KHFoodTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titleName:self.title];
        
        [self.view addSubview:_foodTableView];
        
    }
    
    if ([self.title isEqualToString:@"运动"]) {
        
        _exciseTableView = [[KHExciseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titleName:self.title];
        
        [self.view addSubview:_exciseTableView];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
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

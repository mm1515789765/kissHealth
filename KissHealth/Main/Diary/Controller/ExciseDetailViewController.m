//
//  ExciseDetailViewController.m
//  KissHealth
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "ExciseDetailViewController.h"
#import "ExciseModel.h"
#import "KHDiaryModel.h"
#import "KHDiaryDetailModel.h"

@interface ExciseDetailViewController () <UITextFieldDelegate>

@end

@implementation ExciseDetailViewController
{
    UILabel *_kaloriNumberLabel;
    ExciseModel *_finishedModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self _createBackButton];
    [self _createExciseView];
}

- (void)_createExciseView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 25)];
    
    titleLabel.text = self.exciseModel.name;
    _finishedModel = [[ExciseModel alloc] init];
    _finishedModel.name = self.exciseModel.name;
    
    [self.view addSubview:titleLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 101)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIView *grayColorLine = [[UIView alloc] initWithFrame:CGRectMake(10, 50, kScreenWidth, 1)];
    grayColorLine.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth / 2, 50)];
    UILabel *kaloriLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10, 51, kScreenWidth / 2, 50)];
    timeLabel.text = @"运动时长（分钟）";
    kaloriLabel.text = @"消耗的卡路里";
    
    int x = (kScreenWidth - 20) / 2;
    
    UITextField *timeTF = [[UITextField alloc] initWithFrame:CGRectMake(x, 0, kScreenWidth / 2, 50)];
    timeTF.placeholder = @"如：30";
    timeTF.keyboardType = UIKeyboardTypeNumberPad;
    timeTF.textAlignment = NSTextAlignmentRight;
    timeTF.delegate = self;
    
    [timeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _kaloriNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 51, kScreenWidth / 2, 50)];
    _kaloriNumberLabel.text = @"0";
    _kaloriNumberLabel.textAlignment = NSTextAlignmentRight;
    
    [backView addSubview:_kaloriNumberLabel];
    [backView addSubview:timeTF];
    [backView addSubview:timeLabel];
    [backView addSubview:kaloriLabel];
    [backView addSubview:grayColorLine];
    [self.view addSubview:backView];
    
    
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
    KHDiaryModel *sharedModel = [KHDiaryModel sharedDiaryModel];
    
    [sharedModel.detailModel.exciseList addObject:_finishedModel];
    [sharedModel reloadData];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>]
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSInteger time = [textField.text integerValue];
    
    if (textField.text.length > 4) {
        textField.text = [textField.text substringToIndex:4];
        textField.text = @"1440";
    }
    
    if (time > 1440) {
        textField.text = @"1440";
        time = 1440;
    }
    
    NSInteger kaliro = time * self.exciseModel.kalori;
    _kaloriNumberLabel.text = [NSString stringWithFormat:@"%ld", kaliro];

    _finishedModel.finishedKal = kaliro;
    _finishedModel.finishedTime = time;
    
    [self.view layoutSubviews];
    
    if (textField.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
}

//- (void)setExciseModel:(ExciseModel *)exciseModel
//{
//    if (exciseModel != nil) {
//        
//        _exciseModel = exciseModel;
//        
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

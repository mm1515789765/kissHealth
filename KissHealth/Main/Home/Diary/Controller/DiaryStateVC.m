//
//  DiaryStateVC.m
//  KissHealth
//
//  Created by Macx on 16/2/17.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DiaryStateVC.h"

@interface DiaryStateVC ()
{
    UIBarButtonItem *_backButton;
    UIBarButtonItem *_rightButton;
}

@end

@implementation DiaryStateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"新状态";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _createBarButton];
}

- (void)_createBarButton
{
    UIImage *backImg = [UIImage imageNamed:@"ic_nav_close"];
    UIImage *rightImg = [UIImage imageNamed:@"ic_nav_checkmark_active"];
    
    _backButton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction:)];
    
    _rightButton = [[UIBarButtonItem alloc] initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction:)];
    
    _rightButton.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = _backButton;
    self.navigationItem.rightBarButtonItem = _rightButton;
    
}

- (void)barButtonAction:(UIBarButtonItem *)button
{
    if (button == _backButton) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    if (button == _rightButton) {
        
    }
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

//
//  TimeButtonView.m
//  KissHealth
//
//  Created by Lix on 16/2/7.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "TimeButtonView.h"
#import "ProgressVC.h"
#define kTopViewHeight 40

@interface TimeButtonView()

{
    //Pickerview 背景视图
    UIView * backgroundView;
}

@end

@implementation TimeButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        [self _createPickerView];
        [self _createTopView];
        [self _createTopButton];
        [self _createCoverView];
        [self _createBackgroundView];
    }
    return self;
}

//创建阴影遮挡视图
- (void)_createCoverView

{
    UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height -  216 -40)];
    
    coverView.backgroundColor = [UIColor colorWithWhite:0.600 alpha:0.500];
    
    
    [self addSubview:coverView];
}


//创建pickView
- (void) _createPickerView
{
    _nameArray = @[@"1周",@"1个月",@"2个月",@"3个月",@"6个月",@"1年",@"全部"];
    
    if (_pickerView == nil) {
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        [_pickerView selectRow:0 inComponent:0 animated:YES]; //设置选中行
        
        
        [self addSubview:_pickerView];
//        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 216)];
//        backView.backgroundColor = [UIColor colorWithWhite:0.702 alpha:0.1];
//        
//        [self addSubview:backView];
        
    }
    
}

//创建背景视图
- (void) _createBackgroundView
{
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 216 , self.frame.size.width, self.frame.size.height - 216)];
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    [self insertSubview:backgroundView belowSubview:_pickerView];
    
};

// 创建顶部的蓝色View
- (void) _createTopView
{
    UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 216 - kTopViewHeight, kScreenWidth, kTopViewHeight)];
    [topView setImage:[UIImage imageNamed:@"nav_bar_background@2x.png"]];
    
    [self addSubview:topView];
}

//创建顶部View上的两个button

- (void) _createTopButton
{
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20, kScreenHeight - 216 - kTopViewHeight + 10, 25, 25) ;
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"ic_nav_close@2x.png"] forState:UIControlStateNormal];
    cancelButton.tag = 101;
    [cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    UIButton * agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.frame = CGRectMake(kScreenWidth - 25 - 20, kScreenHeight - 216 - kTopViewHeight + 10, 25, 25);
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"ic_nav_checkmark@2x.png"] forState:UIControlStateNormal];
    agreeButton.tag = 102;
    [agreeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:agreeButton];
    
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 101) {
        [self removeFromSuperview];
    }else if (sender.tag == 102){

        [self removeFromSuperview];
    }
}





- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _nameArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * lable = [[UILabel alloc] init];
    lable.text = _nameArray[row];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:25];
    
    return lable;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.titleBlock) {
        self.titleBlock(_nameArray[row]);
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    
//    NSLog(@"1111");
}
// scrolls the specified row to center.

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
//    NSLog(@"%ld",component);
    return component;
    
}
// returns selected row. -1 if nothing selected



@end

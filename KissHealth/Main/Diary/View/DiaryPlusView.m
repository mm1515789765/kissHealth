//
//  DiaryPlusVIew.m
//  KissHealth
//
//  Created by Macx on 16/2/17.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DiaryPlusView.h"
#import "FoodViewController.h"
#import "BaseNavigationController.h"
#import "KHDiaryModel.h"
#import "waterModel.h"
#import "KHDiaryDetailModel.h"
#import "DiaryVC.h"

@interface DiaryPlusView () <UIPickerViewDelegate, UIPickerViewDelegate>

@end

@implementation DiaryPlusView
{
    UIControl *_maskView;
    UIView *_backView;
    
    NSArray *_proTitleList;
    NSString *_checkMark;
}

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.title = title;
        
        [self _createMaskView];
        [self _createPickerView];
    }
    return self;
}

- (void)_createMaskView
{
    if (_maskView == nil) {
        _maskView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [_maskView addTarget:self action:@selector(maskViewAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_maskView];
}

- (void)_createPickerView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 300)];
    }
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background"]];
    [_backView addSubview:topView];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    [closeButton setImage:[UIImage imageNamed:@"ic_nav_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(maskViewAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 45, 0, 40, 40)];
    [checkButton setImage:[UIImage imageNamed:@"ic_nav_checkmark_active"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkMarkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:checkButton];
    [topView addSubview:closeButton];
    
    if ([self.title isEqualToString:@"水"]) {
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 31; i++) {
            [arr addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        _proTitleList = [NSArray arrayWithArray:arr];

        _backView.backgroundColor = [UIColor whiteColor];
        _plusPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.2, 30, kScreenWidth* 0.6, 190)];
        
        [_backView addSubview:_plusPickerView];
        [_maskView addSubview:_backView];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _backView.transform = CGAffineTransformMakeTranslation(0, -220);
            
        } completion:NULL];
    }
    
    if ([self.title isEqualToString:@"食物"]) {

        _proTitleList = @[
                          @"早餐",
                          @"午餐",
                          @"晚餐",
                          @"零食"
                          ];
        
        _backView.backgroundColor = [UIColor whiteColor];
        _plusPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.2, 30, kScreenWidth * 0.6, 200)];
        
        [_backView addSubview:_plusPickerView];
        [_maskView addSubview:_backView];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _backView.transform = CGAffineTransformMakeTranslation(0, -230);
            
        } completion:NULL];
    }
    
    if ([self.title isEqualToString:@"运动"]) {
        
        _proTitleList = @[
                          @"有氧运动",
                          @"力量"
                          ];
        
        _backView.backgroundColor = [UIColor whiteColor];
        _plusPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.2, 10, kScreenWidth* 0.6, 110)];
        
        [_backView addSubview:_plusPickerView];
        [_maskView addSubview:_backView];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _backView.transform = CGAffineTransformMakeTranslation(0, -140);
            
        } completion:NULL];
    }
    
    _plusPickerView.delegate = self;
    _plusPickerView.dataSource = self;
    _plusPickerView.showsSelectionIndicator = YES;
    
    _checkMark = _proTitleList[0];
    
}

#pragma mark - ButtonAction
- (void)maskViewAction:(UIControl *)maskView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _backView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        _maskView.hidden = YES;
        _maskView = nil;
        _plusPickerView = nil;
        _backView = nil;
        
        [self removeFromSuperview];
    }];

}

- (void)checkMarkButtonAction:(UIButton *)button
{   
    KHDiaryModel *sharedModel = [KHDiaryModel sharedDiaryModel];
    
    if ([self.title isEqualToString:@"水"]) {
        NSInteger cup = [_checkMark integerValue];
        
        if (cup > 0) {
            WaterModel *water = [[WaterModel alloc] init];
            water.name = @"水";
            water.CupNumber = [_checkMark integerValue];
            [sharedModel.detailModel.waterList addObject:water];
            
            if (sharedModel.itemList.count < 6) {
                [sharedModel.itemList addObject:@"水"];
            }
        }

    }

    if ([self.title isEqualToString:@"食物"]) {
        
        FoodViewController *foodVC = [[FoodViewController alloc] init];
        foodVC.title = _checkMark;
        
        KHTabBarVC *tabBarVC = self.tabBarVC;
        [tabBarVC.diaryNavi  pushViewController:foodVC animated:YES];
    }
    
    if ([self.title isEqualToString:@"运动"]) {
        
        FoodViewController *exciseVC = [[FoodViewController alloc] init];
        exciseVC.title = self.title;
        
        KHTabBarVC *tabBarVC = self.tabBarVC;
        [tabBarVC.diaryNavi  pushViewController:exciseVC animated:YES];
        
    }
    
    self.tabBarVC.selectedIndex = 1;
    UIButton *item = [self.tabBarVC.tabBar viewWithTag:1001];    
    [self.tabBarVC selectVC:item];
    
    DiaryVC *diaryVC = (DiaryVC *)self.tabBarVC.diaryNavi.topViewController;
    [diaryVC viewWillAppear:YES];
    [self maskViewAction:nil];
}

#pragma mark - PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([self.title isEqualToString:@"水"]) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _proTitleList.count;
    }
    
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _proTitleList[row];
    }
    
    if (component == 1) {
        return @"杯";
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _checkMark = _proTitleList[row];
}

- (KHTabBarVC *)tabBarVC
{
    UIResponder *responder = self;
    
    do {
        responder = responder.nextResponder;
        
        if ([responder isKindOfClass:[KHTabBarVC class]]) {
            break;
        }
        
    } while (YES);
    
    return (KHTabBarVC *)responder;
}

@end

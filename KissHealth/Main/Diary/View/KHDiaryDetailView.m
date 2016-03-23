//
//  KHDiaryDetailView.m
//  KissHealth
//
//  Created by Macx on 16/2/15.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHDiaryDetailView.h"
#import "KHDiaryTableView.h"
#import "KHDiaryModel.h"
#import "DiaryVC.h"

@interface KHDiaryDetailView ()

@end

@implementation KHDiaryDetailView
{
    NSArray *_missionTitleArr;
    NSArray *_missionArr;
    KHDiaryTableView *_diaryTableView;
    UITextField *_alertTF;
}

- (instancetype)initWithFrame:(CGRect)frame diaryModel:(KHDiaryModel *)sharedModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.diaryModel = sharedModel;
        
        _missionTitleArr = @[
                        @"目标",
                        @"食物",
                        @"运动",
                        @"剩余"
                        ];
        
        _missionArr = @[
                           @"+",
                           @"-",
                           @"=",
                           ];
        
        [self _createHeaderView];
        [self _createTableView];
    }
    return self;
}

- (void)reloadTableViewData
{
    [_diaryTableView reloadData];
}

#pragma mark - TableView
- (void)_createTableView
{
    _diaryTableView = [[KHDiaryTableView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight - 20 - 44 - 100) style:UITableViewStylePlain diaryModel:_diaryModel];
    
    [self addSubview:_diaryTableView];
}

- (void)setDiaryModel:(KHDiaryModel *)diaryModel
{
    if (_diaryModel != diaryModel) {
        _diaryModel = diaryModel;
        
        for (int i = 0; i < 4; i++) {
            UIButton *button = [self viewWithTag:1000 + i];
            
            NSString *title = [self.diaryModel.diaryArr[i / 2] stringValue];
            
            [button setTitle:title forState:UIControlStateNormal];
            
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [self viewWithTag:2200 + i];
        NSString *title = [self.diaryModel.diaryArr[i] stringValue];
        [button setTitle:title forState:UIControlStateNormal];
        
    }
    
}

#pragma mark - HeaderView
- (void)_createHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 35)];
    titleLabel.center = titleView.center;
    
    titleLabel.text = @"今天";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    
    [titleView addSubview:titleLabel];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, kScreenWidth, 1)];
    blackView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    [titleView addSubview:blackView];
    
    
    
    
    UIView *missionView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, 60)];
    
    for (int i = 0; i < 7; i++) {
        int x;
        int y;
        int width = (kScreenWidth - 3 *15 - 10) / 4;
        int height = 35;
        
        if ((i % 2) == 0) {
            x = 5 + (i / 2) * (15 + width);
            y = 5;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y + 36, width, 15)];
            
            NSString *title = [self.diaryModel.diaryArr[i / 2] stringValue];
            
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.tag = 2200 + (i / 2);
            
            [button addTarget:self action:@selector(headerbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.text = _missionTitleArr[i / 2];
            label.font = [UIFont systemFontOfSize:13 weight:-0.2];
            
            [missionView addSubview:button];
            [missionView addSubview:label];
        }
        else{
            x = 7.5 + ((i / 2) + 1) * width+ (i / 2) * 15;
            y = 17;
            UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 10, 10)];
            
            testLabel.text = _missionArr[i / 2];
            testLabel.textAlignment = NSTextAlignmentCenter;
            
            [missionView addSubview:testLabel];
        }
    }
    
    [headerView addSubview:missionView];
    [headerView addSubview:titleView];
    [self addSubview:headerView];
}

- (void)headerbuttonAction:(UIButton *)button
{
    if (button.tag == 2200) {
        
        UIAlertController *targetAlert = [UIAlertController alertControllerWithTitle:@"设置目标" message:@"请输入目标卡路里的值" preferredStyle:UIAlertControllerStyleAlert];
        
        [targetAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            
            
        }]];
        
        [targetAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            KHDiaryModel *sharedModel = [KHDiaryModel sharedDiaryModel];
            
            sharedModel.targetKal = [_alertTF.text integerValue];
            
            [self.viewController viewWillAppear:YES];
            
            
        }]];
        
        [targetAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            _alertTF = textField;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }];
        
        
        
        [self.viewController presentViewController:targetAlert animated:YES completion:NULL];
    }
    
    
}

- (DiaryVC *)viewController
{
    UIResponder *responder = self;
    
    do {
        responder = responder.nextResponder;
        
        if ([responder isKindOfClass:[DiaryVC class]]) {
            break;
        }
        
    } while (YES);
    
    return (DiaryVC *)responder;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField.text.length > 5) {
        textField.text = [textField.text substringToIndex:5];
    }
    
}

@end

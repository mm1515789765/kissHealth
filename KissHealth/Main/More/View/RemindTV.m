//
//  RemindTV.m
//  KissHealth
//
//  Created by Apple on 16/2/22.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "RemindTV.h"

@interface RemindTV ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *_weightArray;
    NSArray *_weekArray;
    NSArray *_frequencyArray;
    NSMutableArray *_dateArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minutesArray;
    
    NSMutableArray *_sectionArray;
    NSMutableArray *_rowTextArray;
    
    UIView *_weightView;
    UIView *_frequencyView;
    UIView *_weekView;
    UIView *_dateView;
    UIView *_timeView;
    UIView *_glassView;
    
    NSInteger _index;
}

@end

@implementation RemindTV


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style isAdd:(BOOL)isAdd
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        [self _createArrayAndView];
    }
    return self;
}

- (void)_createArrayAndView
{
    NSArray *arr = @[@"如果我未记录,提醒我",@"频率",@"周几",@"时间"];
    _sectionArray = [NSMutableArray arrayWithArray:arr];
    
    NSArray *arr1 = @[@"体重",@"每周",@"星期一",@"07:30"];
    _rowTextArray = [NSMutableArray arrayWithArray:arr1];
    
    _weightArray = @[@"体重",@"早餐",@"午餐",@"晚餐",@"零食",@"任何项目达到1天",@"任何项目达到3天",@"任何项目达到7天"];
    _weekArray = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    _frequencyArray = @[@"每天",@"每周",@"每月"];
    
    _dateArray = [NSMutableArray array];
    
    for (int i = 1 ; i < 32; i++) {
        [_dateArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _hourArray = [NSMutableArray array];
    
    for (int i = 0; i < 24; i++) {
        if (i < 10) {
            [_hourArray addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [_hourArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    _minutesArray = [NSMutableArray array];
    
    for (int i = 0; i < 60; i++) {
        
        if (i < 10) {
            [_minutesArray addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [_minutesArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    _glassView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _glassView.backgroundColor = [UIColor blackColor];
    _glassView.alpha = .3;
    _glassView.hidden = YES;
    _weightView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight,kScreenWidth, kPkViewHeight)];
    _frequencyView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight,kScreenWidth, kPkViewHeight)];
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight,kScreenWidth, kPkViewHeight)];
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight,kScreenWidth, kPkViewHeight)];
    _weekView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight,kScreenWidth, kPkViewHeight)];
    
    NSArray *arr2 = @[_weightView,_frequencyView,_weekView,_dateView,_timeView];
    for (int i = 0; i < arr2.count; i++) {
        
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kPkViewHeight)];
        picker.backgroundColor = [UIColor whiteColor];
        picker.delegate = self;
        picker.dataSource = self;
        picker.tag = 500 + i;
        [arr2[i] addSubview:picker];
    }
    
    [self addHeaderView:_weightView];
    [self addHeaderView:_frequencyView];
    [self addHeaderView:_weekView];
    [self addHeaderView:_dateView];
    [self addHeaderView:_timeView];
    
    [self addSubview:_glassView];
    [self addSubview:_weightView];
    [self addSubview:_frequencyView];
    [self addSubview:_weekView];
    [self addSubview:_dateView];
    [self addSubview:_timeView];
}

- (void)addHeaderView:(UIView *)view
{
    UIView *pkHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    pkHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background@2x.png"]];
    
    CGFloat MinY = (40 - 30) / 2;
    UIButton *pkHeadLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, MinY, 30, 30)];
    pkHeadLeftBtn.tag = 302;
    [pkHeadLeftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pkHeadLeftBtn setImage:[UIImage imageNamed:@"ic_nav_close@2x"] forState:UIControlStateNormal];
    UIButton *pkHeadRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, MinY, 30, 30)];
    pkHeadRightBtn.tag = 303;
    [pkHeadRightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pkHeadRightBtn setImage:[UIImage imageNamed:@"ic_nav_checkmark@2x"] forState:UIControlStateNormal];
    [pkHeaderView addSubview:pkHeadRightBtn];
    [pkHeaderView addSubview:pkHeadLeftBtn];
    
    [view addSubview:pkHeaderView];
}

- (void)btnAction:(UIButton *)button
{
    switch (button.tag) {
        case 302:
            [self pkViewHiddenOpen];
            break;
        case 303:
            [self changeArray];
            [self pkViewHiddenOpen];
            [self reloadData];
            break;
        default:
            break;
    }
}

- (void)changeArray
{
    switch (_selectPkViewIndex) {
        case 1:
        {
            NSInteger i = [_weightArray indexOfObject:_isSureString];
            
            if (i == 0) {
                
                NSArray *arr = @[@"如果我未记录,提醒我",@"频率",@"周几",@"时间"];
                NSArray *arr1 = @[@"体重",@"每周",@"星期一",@"07:30"];
                
                _sectionArray = [NSMutableArray arrayWithArray:arr];
                _rowTextArray = [NSMutableArray arrayWithArray:arr1];
                
            }else{
                
                NSArray *arr = @[@"如果我未记录,提醒我",@"时间"];
                _sectionArray = [NSMutableArray arrayWithArray:arr];
                NSArray *arr1 = @[_isSureString,@"12:00"];
                _rowTextArray = [NSMutableArray arrayWithArray:arr1];
            }
        }
            break;
        case 2:
        {
            NSInteger i = [_frequencyArray indexOfObject:_isSureString];
            
            if (i == 0) {
                
                NSArray *arr = @[@"如果我未记录,提醒我",@"频率",@"时间"];
                NSArray *arr1 = @[@"体重",@"每天",@"12:00"];
                
                _sectionArray = [NSMutableArray arrayWithArray:arr];
                _rowTextArray = [NSMutableArray arrayWithArray:arr1];
            }
            if (i == 1) {
                
                NSArray *arr = @[@"如果我未记录,提醒我",@"频率",@"周几",@"时间"];
                NSArray *arr1 = @[@"体重",@"每周",@"星期一",@"12:00"];
                
                _sectionArray = [NSMutableArray arrayWithArray:arr];
                _rowTextArray = [NSMutableArray arrayWithArray:arr1];
            }
            if (i == 2) {
                
                NSArray *arr = @[@"如果我未记录,提醒我",@"频率",@"日期",@"时间"];
                NSArray *arr1 = @[@"体重",@"每月",@"1",@"12:00"];
                
                _sectionArray = [NSMutableArray arrayWithArray:arr];
                _rowTextArray = [NSMutableArray arrayWithArray:arr1];
            }
        }
            break;
        case 3:
        {
            [_rowTextArray replaceObjectAtIndex:2 withObject:_isSureString];
        }
            break;
        case 4:
        {
            [_rowTextArray replaceObjectAtIndex:2 withObject:_isSureString];
        }
            break;
        case 5:
        {
            if (_rowTextArray.count < 3) {
                
                [_rowTextArray replaceObjectAtIndex:1 withObject:_isSureString];
            }else if (_rowTextArray.count == 3){
                
                [_rowTextArray replaceObjectAtIndex:2 withObject:_isSureString];
            }else{
                
                [_rowTextArray replaceObjectAtIndex:3 withObject:_isSureString];
            }
        }
            break;
        default:
            break;
    }
}

- (void)pkViewHiddenClose
{
    _glassView.hidden = NO;
    CGRect frame = CGRectMake(0, kPkViewHeight + 64, kScreenWidth, kPkViewHeight);
    if ([_rowTextArray[0] isEqualToString:@"体重"]) {
        
        if ([_rowTextArray[1] isEqualToString:@"每周"]) {
            
            switch (_index) {
                case 0:
                {[UIView animateWithDuration:.3 animations:^{
                    _weightView.frame = frame;
                }];}
                    break;
                case 1:
                {[UIView animateWithDuration:.3 animations:^{
                    _frequencyView.frame = frame;
                }];}
                    break;
                case 2:
                {[UIView animateWithDuration:.3 animations:^{
                    _weekView.frame = frame;
                }];}
                    break;
                case 3:
                {[UIView animateWithDuration:.3 animations:^{
                    _timeView.frame = frame;
                }];}
                    break;
                case 4:
                {[UIView animateWithDuration:.3 animations:^{
                    _dateView.frame = frame;
                }];}
                    break;
                default:
                    break;
            }
        }
        if ([_rowTextArray[1] isEqualToString:@"每天"]) {
            switch (_index) {
                case 0:
                {[UIView animateWithDuration:.3 animations:^{
                    _weightView.frame = frame;
                }];}
                    break;
                case 1:
                {[UIView animateWithDuration:.3 animations:^{
                    _frequencyView.frame = frame;
                }];}
                    break;
                case 2:
                {[UIView animateWithDuration:.3 animations:^{
                    _timeView.frame = frame;
                }];}
                    break;
                default:
                    break;
            }
        }
        if ([_rowTextArray[1] isEqualToString:@"每月"]) {
            
            switch (_index) {
                case 0:
                {[UIView animateWithDuration:.3 animations:^{
                    _weightView.frame = frame;
                }];}
                    break;
                case 1:
                {[UIView animateWithDuration:.3 animations:^{
                    _frequencyView.frame = frame;
                }];}
                    break;
                case 2:
                {[UIView animateWithDuration:.3 animations:^{
                    _dateView.frame = frame;
                }];}
                    break;
                case 3:
                {[UIView animateWithDuration:.3 animations:^{
                    _timeView.frame = frame;
                }];}
                    break;
                default:
                    break;
            }
        }
    }else{
        switch (_index) {
            case 0:
            {[UIView animateWithDuration:.3 animations:^{
                _weightView.frame = frame;
            }];}
                break;
            case 1:
            {[UIView animateWithDuration:.3 animations:^{
                _timeView.frame = frame;
            }];}
            default:
                break;
        }
    }
}

- (void)pkViewHiddenOpen
{
    _glassView.hidden = YES;
    CGRect frame = CGRectMake(0, kScreenHeight, kScreenWidth, kPkViewHeight);
    if ([_rowTextArray[0] isEqualToString:@"体重"]) {
        
        if ([_rowTextArray[1] isEqualToString:@"每周"]) {
            
            switch (_index) {
                case 0:
                {[UIView animateWithDuration:.3 animations:^{
                    _weightView.frame = frame;
                }];}
                    break;
                case 1:
                {[UIView animateWithDuration:.3 animations:^{
                    _frequencyView.frame = frame;
                }];}
                    break;
                case 2:
                {[UIView animateWithDuration:.3 animations:^{
                    _weekView.frame = frame;
                }];}
                    break;
                case 3:
                {[UIView animateWithDuration:.3 animations:^{
                    _timeView.frame = frame;
                }];}
                    break;
                case 4:
                {[UIView animateWithDuration:.3 animations:^{
                    _dateView.frame = frame;
                }];}
                    break;
                default:
                    break;
            }
        }
        if ([_rowTextArray[1] isEqualToString:@"每天"]) {
            switch (_index) {
                case 0:
                {[UIView animateWithDuration:.3 animations:^{
                    _weightView.frame = frame;
                }];}
                    break;
                case 1:
                {[UIView animateWithDuration:.3 animations:^{
                    _frequencyView.frame = frame;
                }];}
                    break;
                case 2:
                {[UIView animateWithDuration:.3 animations:^{
                    _timeView.frame = frame;
                }];}
                    break;
                default:
                    break;
            }
        }
        if ([_rowTextArray[1] isEqualToString:@"每月"]) {
            
            switch (_index) {
                case 0:
                {[UIView animateWithDuration:.3 animations:^{
                    _weightView.frame = frame;
                }];}
                    break;
                case 1:
                {[UIView animateWithDuration:.3 animations:^{
                    _frequencyView.frame = frame;
                }];}
                    break;
                case 2:
                {[UIView animateWithDuration:.3 animations:^{
                    _dateView.frame = frame;
                }];}
                    break;
                case 3:
                {[UIView animateWithDuration:.3 animations:^{
                    _timeView.frame = frame;
                }];}
                    break;
                default:
                    break;
            }
        }
    }else{
        switch (_index) {
            case 0:
            {[UIView animateWithDuration:.3 animations:^{
                _weightView.frame = frame;
            }];}
                break;
            case 1:
            {[UIView animateWithDuration:.3 animations:^{
                _timeView.frame = frame;
            }];}
            default:
                break;
        }
    }
}

#pragma mark - Tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _rowTextArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remindCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"remindCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _rowTextArray[indexPath.section];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionArray[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath.section;
    [self pkViewHiddenClose];
}

#pragma - mark UIPickerView  datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 504) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 500:
            return _weightArray.count;
            break;
        case 501:
            return _frequencyArray.count;
            break;
        case 502:
            return _weekArray.count;
            break;
        case 503:
            return _dateArray.count;
            break;
        case 504:
            if (component == 0) {
                return _hourArray.count;
            }
            return _minutesArray.count;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 500:
            return _weightArray[row];
            break;
        case 501:
            return _frequencyArray[row];
            break;
        case 502:
            return _weekArray[row];
            break;
        case 503:
            return _dateArray[row];
            break;
        case 504:
            if (component == 0) {
                return _hourArray[row];
            }
            return _minutesArray[row];
            break;
        default:
            break;
    }
    return nil;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView.tag == 504) {
        return 80;
    }
    return 220;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 500:
        {
            NSString *str = _weightArray[row];
            _isSureString = str;
            _selectPkViewIndex = 1;
        }
            break;
        case 501:
        {
            NSString *str = _frequencyArray[row];
            _isSureString = str;
            _selectPkViewIndex = 2;
        }
            break;
        case 502:
        {
            NSString *str = _weekArray[row];
            _isSureString = str;
            _selectPkViewIndex = 3;
        }
            break;
        case 503:
        {
            NSString *str = _dateArray[row];
            _isSureString = str;
            _selectPkViewIndex = 4;
        }
            break;
        case 504:
        {
            NSInteger selectIndex1 = [pickerView selectedRowInComponent:0];
            NSInteger selectIndex2 = [pickerView selectedRowInComponent:1];
            
            NSString *str = [NSString stringWithFormat:@"%@:%@",[_hourArray objectAtIndex:selectIndex1],[_minutesArray objectAtIndex:selectIndex2]];
            _isSureString = str;
            _selectPkViewIndex = 5;
        }
            break;
        default:
            break;
    }
}

@end

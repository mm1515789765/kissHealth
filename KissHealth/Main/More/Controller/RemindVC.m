//
//  RemindVC.m
//  KissHealth
//
//  Created by Apple on 16/2/3.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "RemindVC.h"
#import "RemindCell.h"
#import "MoreModel.h"

@interface RemindVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
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

    UILabel *_noReminderlabel;
    
    NSInteger _index;
    
    UIView *_addReminderView;
    UITableView *_addReminderTV;
    
    UITableView *_reminderTV;
    NSMutableArray *_remindSectionArray;
    NSMutableArray *_remindTitleArray;
    NSMutableArray *_remindSubTitleArray;
    
    NSMutableArray *_modelArray;
}

@end

@implementation RemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提醒";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
    _isSureString = [NSString string];
    [self _createRightLeftItem];
    [self _createNoReminderLabel];
    
    [self _createAddReminderView];
    [self _createArrayAndView];
}

- (void)_createRightLeftItem
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftButton.tag = 300;
    [leftButton setImage:[UIImage imageNamed:@"ic_nav_arrow_left@2x"] forState:UIControlStateNormal];
    leftButton.showsTouchWhenHighlighted = YES;
    [leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightButton.tag = 301;
    [rightButton setImage:[UIImage imageNamed:@"ic_nav_add@2x"] forState:UIControlStateNormal];
    rightButton.showsTouchWhenHighlighted = YES;
    [rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)_createNoReminderLabel
{
    NSString *str = @"            你尚未设置提醒。\n点击上面的“+”按钮添加新提醒";
    
    CGFloat minX = (kScreenWidth - 200) / 2 + 10;
    CGFloat minY = self.view.center.y - 40;
    _noReminderlabel = [[UILabel alloc] initWithFrame:CGRectMake(minX, minY, 200, 40)];
    _noReminderlabel.text = str;
    _noReminderlabel.font = [UIFont systemFontOfSize:13];
    _noReminderlabel.numberOfLines = 2;
}

- (void)_createArrayAndView
{
    _modelArray = [NSMutableArray array];
    _remindSectionArray = [NSMutableArray array];
    
    _foodSectionArray = [NSMutableArray array];
    _weightSectionArray = [NSMutableArray array];
    _generalSectionArray = [NSMutableArray array];

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
    
    [self.view addSubview:_glassView];
    [self.view addSubview:_weightView];
    [self.view addSubview:_frequencyView];
    [self.view addSubview:_weekView];
    [self.view addSubview:_dateView];
    [self.view addSubview:_timeView];
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

- (void)_createAddReminderView
{
    if (!_reminderTV) {
        
        _reminderTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _reminderTV.tag = 2222;
        _reminderTV.delegate = self;
        _reminderTV.dataSource = self;
        
        [_reminderTV registerNib:[UINib nibWithNibName:@"RemindCell" bundle:NULL] forCellReuseIdentifier:@"remindCell"];
    }
    
    _addReminderView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    _addReminderView.backgroundColor = [UIColor redColor];
    
    _addReminderTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    _addReminderTV.delegate = self;
    _addReminderTV.dataSource = self;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background@2x.png"]];
    
    CGFloat minX = headerView.center.x - 34;
    CGFloat minY = headerView.center.y + 3.5;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(minX, minY, 68, 7)];
    label.text = @"添加提醒";
    label.textColor = [UIColor whiteColor];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    leftButton.tag = 304;
    leftButton.showsTouchWhenHighlighted = YES;
    [leftButton setImage:[UIImage imageNamed:@"ic_nav_close@2x"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 45, 25, 30, 30)];
    rightButton.tag = 305;
    rightButton.showsTouchWhenHighlighted = YES;
    [rightButton setImage:[UIImage imageNamed:@"ic_nav_checkmark@2x"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
   
    [headerView addSubview:label];
    [headerView addSubview:leftButton];
    [headerView addSubview:rightButton];
    [self.view addSubview:_reminderTV];
    [self.view addSubview:_noReminderlabel];
    [self.view addSubview:_addReminderView];
    [_addReminderView addSubview:_addReminderTV];
    [_addReminderView addSubview:headerView];
}

- (void)btnAction:(UIButton *)button
{
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    CGRect frame1 = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    switch (button.tag) {
        case 300:
            self.tabBarController.tabBar.hidden = NO;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 301:
        {[UIView animateWithDuration:.5 animations:^{
            _addReminderView.frame = frame;
        } completion:^(BOOL finished) {
            self.navigationController.navigationBar.hidden = YES;
        }];}
            break;
        case 302:
            [self pkViewHiddenOpen];
            break;
        case 303:
            [self changeArray];
            [self pkViewHiddenOpen];
            [_addReminderTV reloadData];
            break;
        case 304:
        {[UIView animateWithDuration:.5 animations:^{
            self.navigationController.navigationBar.hidden = NO;
            _addReminderView.frame = frame1;
        }];}
            break;
        case 305:
        {[UIView animateWithDuration:.5 animations:^{
            self.navigationController.navigationBar.hidden = NO;
            _addReminderView.frame = frame1;
            _noReminderlabel.hidden = YES;
            [self _createModel];
            [_reminderTV reloadData];
        }];}
            break;
        default:
            break;
    }
}

- (void)_createModel
{
    MoreModel *model = [[MoreModel alloc] init];
    
    if ([_rowTextArray[0] isEqualToString:@"体重"]) {
        
        BOOL isInclude = [self isIncludeString:@"体重"];
        if (!isInclude) {
           
            [_remindSectionArray addObject:@"体重"];
        }
        
        if ([_rowTextArray[1] isEqualToString:@"每天"]) {
            
            model.title = _rowTextArray[1];
            model.subTitle = _rowTextArray[2];
        }
        
        if ([_rowTextArray[1] isEqualToString:@"每周"]) {
            
            model.title = [NSString stringWithFormat:@"%@%@",_rowTextArray[1],_rowTextArray[2]];
            model.subTitle = _rowTextArray[3];
        }
        
        if ([_rowTextArray[1] isEqualToString:@"每月"]) {
            
            model.title = [NSString stringWithFormat:@"%@%@日",_rowTextArray[1],_rowTextArray[2]];
            model.subTitle = _rowTextArray[3];
        }
        
        [_weightSectionArray addObject:model];
    }

    if ([_rowTextArray[0] rangeOfString:@"餐"].location != NSNotFound || [_rowTextArray[0] rangeOfString:@"零食"].location != NSNotFound) {
        
        BOOL isInclude = [self isIncludeString:@"餐食"];
        if (!isInclude) {
            
            [_remindSectionArray addObject:@"餐食"];
        }
        model.title = _rowTextArray[0];
        model.subTitle = _rowTextArray[1];
        [_foodSectionArray addObject:model];
    }
    
    if ([_rowTextArray[0] rangeOfString:@"任何"].location != NSNotFound) {
        
        BOOL isInclude = [self isIncludeString:@"General"];
        if (!isInclude) {
            
            [_remindSectionArray addObject:@"General"];
        }
       
        model.title = _rowTextArray[0];
        model.subTitle = _rowTextArray[1];
        
        [_generalSectionArray addObject:model];
    }
    
    [_modelArray addObject:model];
}

- (BOOL)isIncludeString:(NSString *)string
{
    for (NSString *str in _remindSectionArray) {
        
        if ([str isEqualToString:string]) {
            
            return YES;
        }
    }
    return NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma - mark  设置不固定section，row的方法

- (NSInteger)sectionRowNumberWithstring:(NSString *)string
{
    int i = 0;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (MoreModel *model in _modelArray) {
        
        if ([model.title isEqualToString:@"零食"]) {
            
            [arr addObject:@"餐食"];
        }
        
        if ([model.title rangeOfString:@"每周"].location != NSNotFound || [model.title rangeOfString:@"每月"].location != NSNotFound || [model.title rangeOfString:@"每天"].location != NSNotFound) {
            
            [arr addObject:@"体重"];
        }else{
        
            [arr addObject:model.title];
        }
    }
    
    for (int j = 0; j < arr.count; j++) {
        
        if ([arr[j] rangeOfString:string].location != NSNotFound) {
                
            i++;
        }
    }
    return i;
}

- (NSString *)changeString:(NSString *)string
{
    if ([string isEqualToString:@"餐食"]) {
        return @"餐";
    }
    if ([string isEqualToString:@"体重"]) {
        return @"体重";
    }
    return @"任何";
}

- (NSInteger)setSectionTitleIndexWithString:(NSString *)string
{
    if ([string isEqualToString:@"餐食"]) {
        
        return 0;
    }
    if ([string isEqualToString:@"General"]) {
        
        return 1;
    }
    if ([string isEqualToString:@"体重"]) {
        
        return 2;
    }
    return 3;
}

#pragma mark - Tableview data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 2222) {
        
        return _remindSectionArray.count;
    }
    return _rowTextArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2222) {
        
        return 45;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 2222){
     
        for (int i = 0; i < _remindSectionArray.count; i++) {
           
            if (section == i) {
               
                NSString *str = [self changeString:_remindSectionArray[i]];
                return [self sectionRowNumberWithstring:str];
            }
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2222) {
        
        RemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remindCell" forIndexPath:indexPath];
        
        if (_remindSectionArray.count == 1) {
            
            switch ([self setSectionTitleIndexWithString:_remindSectionArray[0]])
            {
                case 0:
                    cell.model = _foodSectionArray[indexPath.row];
                    break;
                case 1:
                    cell.model = _generalSectionArray[indexPath.row];
                    break;
                case 2:
                    cell.model = _weightSectionArray[indexPath.row];
                    break;
                default:
                    break;
            }
        }
        
        if (_remindSectionArray.count == 2) {
            
            if (indexPath.section == 0) {
                
                switch ([self setSectionTitleIndexWithString:_remindSectionArray[0]])
                {
                    case 0:
                        cell.model = _foodSectionArray[indexPath.row];
                        break;
                    case 1:
                        cell.model = _generalSectionArray[indexPath.row];
                        break;
                    case 2:
                        cell.model = _weightSectionArray[indexPath.row];
                        break;
                    default:
                        break;
                }
            }
            if (indexPath.section == 1) {
                
                switch ([self setSectionTitleIndexWithString:_remindSectionArray[1]])
                {
                    case 0:
                        cell.model = _foodSectionArray[indexPath.row];
                        break;
                    case 1:
                        cell.model = _generalSectionArray[indexPath.row];
                        break;
                    case 2:
                        cell.model = _weightSectionArray[indexPath.row];
                        break;
                    default:
                        break;
                }
            }
        }
        if (_remindSectionArray.count == 3) {
            
            if (indexPath.section == 0) {
                
                switch ([self setSectionTitleIndexWithString:_remindSectionArray[0]])
                {
                    case 0:
                        cell.model = _foodSectionArray[indexPath.row];
                        break;
                    case 1:
                        cell.model = _generalSectionArray[indexPath.row];
                        break;
                    case 2:
                        cell.model = _weightSectionArray[indexPath.row];
                        break;
                    default:
                        break;
                }
            }
            if (indexPath.section == 1) {
                
                switch ([self setSectionTitleIndexWithString:_remindSectionArray[1]])
                {
                    case 0:
                        cell.model = _foodSectionArray[indexPath.row];
                        break;
                    case 1:
                        cell.model = _generalSectionArray[indexPath.row];
                        break;
                    case 2:
                        cell.model = _weightSectionArray[indexPath.row];
                        break;
                    default:
                        break;
                }
            }
            
            if (indexPath.section == 2) {
                
                switch ([self setSectionTitleIndexWithString:_remindSectionArray[2]])
                {
                    case 0:
                        cell.model = _foodSectionArray[indexPath.row];
                        break;
                    case 1:
                        cell.model = _generalSectionArray[indexPath.row];
                        break;
                    case 2:
                        cell.model = _weightSectionArray[indexPath.row];
                        break;
                    default:
                        break;
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
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
    if (tableView.tag == 2222) {
        
        return _remindSectionArray[section];
    }
    return _sectionArray[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath.section;
    
    if (tableView.tag == 2222) {
        
        
    }else{
       
        [self pkViewHiddenClose];
    }
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

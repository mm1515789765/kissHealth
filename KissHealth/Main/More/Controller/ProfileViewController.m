//
//  ProfileViewController.m
//  KissHealth
//
//  Created by Apple on 16/1/30.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"
#import "UnitVC.h"

@interface ProfileViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_titleArray;
    NSMutableArray *_subTitleArray;
    
    UIView *_sixView;
    UIView *_birthView;
    NSInteger _index;                //记录选择的行
    UIView *_glassView;              //出现pkView的时候弹出的半透明view
}

@end

@implementation ProfileViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    self.tabBarController.tabBar.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:NULL] forCellReuseIdentifier:@"profileCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiUnitChanged:) name:kUnitNotification object:nil];
    
    [self _createBackItem];
    [self _createLabelArray];
    [self _createSubViewArray];
}

- (void)notiUnitChanged:(NSNotification *)notification
{
    NSMutableString *str = [[NSMutableString alloc] init];
   
    NSArray *arr = [NSArray array];
    arr = notification.object;
   
    if (arr) {
        for (NSInteger i = 0; i < arr.count; i++) {
            
            if (i == arr.count - 1) {
                [str appendString:arr[i]];
            }else{
                
            [str appendString:arr[i]];
            [str appendString:@","];
            }
        }
    }
    
    [_subTitleArray replaceObjectAtIndex:_index withObject:str];
    [self.tableView reloadData];
}

- (void)_createSubViewArray
{
    _glassView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
    _glassView.backgroundColor = [UIColor blackColor];
    _glassView.alpha = 0.3;
    _glassView.hidden = YES;

    _sixView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight / 2)];
    _sixView.backgroundColor = [UIColor whiteColor];
    UIPickerView *sixPkView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
    sixPkView.backgroundColor = [UIColor whiteColor];
    sixPkView.delegate = self;
    sixPkView.dataSource = self;
    sixPkView.tag = 1000;
   
    _birthView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight / 2)];
    _birthView.backgroundColor = [UIColor whiteColor];
    UIDatePicker *birthDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight / 2 - 80)];
    birthDatePicker.tag = 1001;
    birthDatePicker.datePickerMode = UIDatePickerModeDate;
    [birthDatePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    birthDatePicker.backgroundColor = [UIColor whiteColor];
    [birthDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_glassView];  //加的地方不对，有待调整
    [self.view addSubview:_birthView];
    [self.view addSubview:_sixView];
    [_birthView addSubview:birthDatePicker];
    [_sixView addSubview:sixPkView];
    [self addHeaderView:_birthView];
    [self addHeaderView:_sixView];

    _birthView.hidden = YES;
    _sixView.hidden = YES;
}

- (void)addHeaderView:(UIView *)view
{
    UIView *pkHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    pkHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background@2x.png"]];
    
    CGFloat MinY = (40 - 30) / 2;
    UIButton *pkHeadLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, MinY, 30, 30)];
    pkHeadLeftBtn.tag = 200;
    [pkHeadLeftBtn addTarget:self action:@selector(pkHeaderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pkHeadLeftBtn setImage:[UIImage imageNamed:@"ic_nav_close@2x"] forState:UIControlStateNormal];
    UIButton *pkHeadRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, MinY, 30, 30)];
    pkHeadRightBtn.tag = 201;
    [pkHeadRightBtn addTarget:self action:@selector(pkHeaderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pkHeadRightBtn setImage:[UIImage imageNamed:@"ic_nav_checkmark@2x"] forState:UIControlStateNormal];
    [pkHeaderView addSubview:pkHeadRightBtn];
    [pkHeaderView addSubview:pkHeadLeftBtn];

    [view addSubview:pkHeaderView];
}

- (NSString *)datePickerValueChanged:(UIDatePicker *)datepicker
{
    NSDate *currentDate = datepicker.date;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    NSString *str = [fmt stringFromDate:currentDate];
    
    return str;
}

- (void)pkHeaderBtnAction:(UIButton *)sender
{
    if (sender.tag == 200) {
        
        [self pkViewHiddenOpen];
   
    }else if (sender.tag == 201){
    
        [self pkViewHiddenOpen];
        
        if (_index == 3) {

        [_subTitleArray replaceObjectAtIndex:_index withObject:[self datePickerValueChanged:[_birthView viewWithTag:1001]]];
        [self.tableView reloadData];
        }
    }
}

- (void)pkViewHiddenOpen
{
    CGRect frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight / 2);
    _glassView.hidden = YES;
    switch (_index) {
        case 2:
        {[UIView animateWithDuration:.3 animations:^{
            _sixView.hidden = YES;
            _sixView.frame = frame;
        }];}
            break;
        case 3:
        {[UIView animateWithDuration:.3 animations:^{
            _birthView.hidden = YES;
            _birthView.frame = frame;
        }];}
            break;
        default:
            break;
    }
}

- (void)pkViewHiddenClose
{
    
    CGRect frame = CGRectMake(0, kScreenHeight / 2, kScreenWidth, kScreenHeight / 2);
    if ((_index >= 2 && _index <= 4) || _index == 6) {
        
        _glassView.hidden = NO;
    }
    switch (_index) {
        case 2:
            {[UIView animateWithDuration:.3 animations:^{
            _sixView.hidden = NO;
            _sixView.frame = frame;
        }];}
            break;
        case 3:
        {[UIView animateWithDuration:.3 animations:^{
            _birthView.hidden = NO;
            _birthView.frame = frame;
        }];}
            break;
        default:
            break;
    }
}

- (void)_createLabelArray
{
    _titleArray = @[@"资料头像",@"身高",@"性别",@"出生日期",@"国家／地区",@"邮政编码",@"时区",@"邮箱地址",@"单位"];
    _subTitleArray = [NSMutableArray array];      //等待前面界面传初始值
    NSArray *arr = @[@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" "];
    [_subTitleArray addObjectsFromArray:arr];

}

- (void)_createBackItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"ic_nav_arrow_left@2x"] forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backButtonAction:(UIButton *)button
{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _titleArray[indexPath.row];
    
    cell.subTitleLabel.text = _subTitleArray[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0  blue:231 / 255.0  alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 30, 150, 15)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"个人详细信息";
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath.row;
    [self pkViewHiddenClose];
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            [self.navigationController pushViewController:[[UnitVC alloc] init] animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma - mark  pickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 1000) {
       
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1000) {
        
        return 2;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1000) {

        if (row == 0) {
            return @"男";
        }
        if (row == 1) {
            return @"女";
        }
    }
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 60;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1000) {
        
    }
}


@end

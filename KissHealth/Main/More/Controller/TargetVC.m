//
//  TarVC.m
//  KissHealth
//
//  Created by Apple on 16/2/16.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "TargetVC.h"
#import "ProfileCell.h"

@interface TargetVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *_titleArray;
    NSArray *_weekArray;
    NSArray *_activityArray;
    NSMutableArray *_subTitleArray;
    NSMutableArray *_minutesPkViewArray;
    NSMutableArray *_exercisePkViewArray;
    
    NSInteger _index;
    NSString *_isSureSring;
    NSIndexPath *_indexPath;
    
    UIView *_backgroundView;
    UIView *_glassView;
    UIView *_exerciseNumView;
    UIView *_minutesView;
    UIView *_activityView;
    UIView *_weekView;
    
    UITableView *_targetTV;
}

@end

@implementation TargetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"目标";
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    _isSureSring = [NSString string];
   
    [self _createTitleArray];
    [self _createView];
    
    [_targetTV registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:NULL] forCellReuseIdentifier:@"profileCell"];
}

- (void)_createView
{
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background@2x.png"]];
    
    CGFloat minX = headerView.center.x - 17;
    CGFloat minY = headerView.center.y + 3.5;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(minX, minY, 34, 7)];
    label.text = @"目标";
    label.textColor = [UIColor whiteColor];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    leftButton.tag = 212;
    leftButton.showsTouchWhenHighlighted = YES;
    [leftButton setImage:[UIImage imageNamed:@"ic_nav_arrow_left@2x"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _targetTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    _targetTV.tag = 213;
    _targetTV.delegate = self;
    _targetTV.dataSource = self;
    
    _weekView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 320)];
    UITableView *weekTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 280) style:UITableViewStylePlain];
    weekTV.tag = 214;
    weekTV.delegate = self;
    weekTV.dataSource = self;
    [weekTV registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:NULL] forCellReuseIdentifier:@"profileCell"];
    
    _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
    UITableView *activityTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 160) style:UITableViewStylePlain];
    activityTV.tag = 215;
    activityTV.delegate = self;
    activityTV.dataSource = self;
    [activityTV registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:NULL] forCellReuseIdentifier:@"profileCell"];
    
    _glassView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _glassView.backgroundColor = [UIColor blackColor];
    _glassView.alpha = 0.3;
    _glassView.hidden = YES;
    
    _exerciseNumView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kPkViewHeight)];
    _exerciseNumView.backgroundColor = [UIColor whiteColor];
    UIPickerView *exercisePkView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kPkViewHeight)];
    exercisePkView.tag = 1100;
    exercisePkView.delegate = self;
    exercisePkView.dataSource = self;
    
    _minutesView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kPkViewHeight)];
    _minutesView.backgroundColor = [UIColor whiteColor];
    UIPickerView *minutesPkView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kPkViewHeight)];
    minutesPkView.tag = 1101;
    minutesPkView.delegate = self;
    minutesPkView.dataSource = self;
    
    [headerView addSubview:label];
    [headerView addSubview:leftButton];
    [_backgroundView addSubview:headerView];
    [self.view addSubview:_backgroundView];
    [self.view addSubview:_targetTV];
    [self.view addSubview:_glassView];
    [self.view addSubview:_weekView];
    [self.view addSubview:_activityView];
    [self.view addSubview:_exerciseNumView];
    [self.view addSubview:_minutesView];
    [_weekView addSubview:weekTV];
    [_activityView addSubview:activityTV];
    [_exerciseNumView addSubview:exercisePkView];
    [_minutesView addSubview:minutesPkView];
    [self addTVHeaderView:_weekView];
    [self addTVHeaderView:_activityView];
    [self addHeaderView:_exerciseNumView];
    [self addHeaderView:_minutesView];
}

- (void)addTVHeaderView:(UIView *)view
{
    UIView *HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    HeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background@2x.png"]];
    
    CGFloat MinY = (40 - 30) / 2;
    UIButton *HeadLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, MinY, 30, 30)];
    HeadLeftBtn.tag = 220;
    [HeadLeftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [HeadLeftBtn setImage:[UIImage imageNamed:@"ic_nav_close@2x"] forState:UIControlStateNormal];
    
    [HeaderView addSubview:HeadLeftBtn];
    
    [view addSubview:HeaderView];
}


- (void)addHeaderView:(UIView *)view
{
    UIView *pkHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    pkHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background@2x.png"]];
    
    CGFloat MinY = (40 - 30) / 2;
    UIButton *pkHeadLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, MinY, 30, 30)];
    pkHeadLeftBtn.tag = 210;
    [pkHeadLeftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pkHeadLeftBtn setImage:[UIImage imageNamed:@"ic_nav_close@2x"] forState:UIControlStateNormal];
    UIButton *pkHeadRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, MinY, 30, 30)];
    pkHeadRightBtn.tag = 211;
    [pkHeadRightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pkHeadRightBtn setImage:[UIImage imageNamed:@"ic_nav_checkmark@2x"] forState:UIControlStateNormal];
    [pkHeaderView addSubview:pkHeadRightBtn];
    [pkHeaderView addSubview:pkHeadLeftBtn];
    
    [view addSubview:pkHeaderView];
}

- (void)btnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 210:
            [self pkViewHiddenOpen];
            break;
        case 211:
            [self pkViewHiddenOpen];
            [_subTitleArray replaceObjectAtIndex:_index withObject:_isSureSring];
            [_targetTV reloadData];
            break;
        case 212:
            self.tabBarController.tabBar.hidden = NO;
            self.navigationController.navigationBar.hidden = NO;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 220:
            [self pkViewHiddenOpen];
            break;
        default:
            break;
    }
}

- (void)pkViewHiddenOpen
{
    CGRect frame = CGRectMake(0, kScreenHeight, kScreenWidth, kPkViewHeight);
    switch (_index) {
        case 2:
        {[UIView animateWithDuration:.3 animations:^{
            _weekView.frame = frame;
        }];}
            break;
        case 3:
        {[UIView animateWithDuration:.3 animations:^{
            _activityView.frame = frame;
        }];}
            break;
        case 4:
        {[UIView animateWithDuration:.3 animations:^{
            _exerciseNumView.frame = frame;
        }];}
            break;
        case 5:
        {[UIView animateWithDuration:.3 animations:^{
            _minutesView.frame = frame;
        }];}
            break;
        default:
            break;
    }
    _glassView.hidden = YES;
}

- (void)tableviewHiddenOpen
{
    CGRect frame = CGRectMake(0, kScreenHeight, kScreenWidth, kPkViewHeight);
    UIAlertController *weekAlert = [UIAlertController alertControllerWithTitle:@"你确定？" message:@"更新您的每周目标将删除所有的自定义目标。是否要继续" preferredStyle:UIAlertControllerStyleAlert];
    
    [weekAlert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }]];
    
    [weekAlert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_subTitleArray replaceObjectAtIndex:2 withObject:_isSureSring];
        [(UITableView *)[_weekView viewWithTag:214] reloadData];
        [_targetTV reloadData];
    }]];
    
    UIAlertController *activityAlert = [UIAlertController alertControllerWithTitle:@"你确定？" message:@"更新您的活动量水平将删除所有的自定义目标。是否要继续" preferredStyle:UIAlertControllerStyleAlert];
    
    [activityAlert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }]];
    
    [activityAlert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_subTitleArray replaceObjectAtIndex:3 withObject:_isSureSring];
        [(UITableView *)[_activityView viewWithTag:215] reloadData];
        [_targetTV reloadData];
    }]];
    
    
    switch (_index) {
        case 2:
        {[UIView animateWithDuration:.3 animations:^{
            _weekView.frame = frame;
            [self presentViewController:weekAlert animated:YES completion:NULL];
        }];}
            break;
            
        case 3:
        {[UIView animateWithDuration:.3 animations:^{
            _activityView.frame = frame;
            [self presentViewController:activityAlert animated:YES completion:NULL];
        }];}
            break;
        default:
            break;
    }
    _glassView.hidden = YES;
}

- (void)pkViewHiddenClose
{
    CGRect frame = CGRectMake(0, kPkViewHeight + 64, kScreenWidth, kPkViewHeight);
    
    switch (_index) {
        case 2:
        {[UIView animateWithDuration:.3 animations:^{
            _weekView.frame = CGRectMake(0, kScreenHeight - 320, kScreenWidth, 320);
        }];}
            break;
        case 3:
        {[UIView animateWithDuration:.3 animations:^{
            _activityView.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200);
        }];}
            break;
        case 4:
        {[UIView animateWithDuration:.3 animations:^{
            _exerciseNumView.frame = frame;
        }];}
            break;
        case 5:
        {[UIView animateWithDuration:.3 animations:^{
            _minutesView.frame = frame;
        }];}
            break;
            
        default:
            break;
    }
    
    _glassView.hidden = NO;
}

- (void)_createTitleArray
{
    _titleArray = @[@"当前体重",@"目标体重",@"每周目标",@"活动量水平",@"锻炼次数/周",@"分钟数/锻炼"];
    _weekArray = @[@"每周减轻0.5磅",@"每周减轻1磅",@"每周减轻1.5磅",@"每周减轻2磅",@"保持我当前的体重",@"每周增重0.5磅",@"每周增重1磅"];
    _activityArray = @[@"久坐",@"活动量较小",@"活动量一般",@"活动量很大"];
    _subTitleArray = [NSMutableArray array];
    NSArray *arr = @[@" ",@" ",@" ",@" ",@" ",@" "];
    [_subTitleArray addObjectsFromArray:arr];
    
    _exercisePkViewArray = [NSMutableArray array];
    for (int i = 0; i < 29; i++) {
        [_exercisePkViewArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _minutesPkViewArray = [NSMutableArray array];
    for (int j = 0; j < 361; j++) {
        [_minutesPkViewArray addObject:[NSString stringWithFormat:@"%d",j]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 213) {
       
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 213) {

    if (section == 0) {
        
        return 4;
    }
    return 2;
        
    }else if (tableView.tag == 214){
        
        return _weekArray.count;
    }else{
        
        return _activityArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (tableView.tag == 213) {
    switch (indexPath.section) {
        case 0:
            cell.titleLabel.text = _titleArray[indexPath.row];
            cell.subTitleLabel.text = _subTitleArray[indexPath.row];
            if (indexPath.row == 0) {
                
                if (!_cWtextField) {
                    _cWtextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5 / 2, kScreenWidth - 90, 35)];
                    _cWtextField.font = [UIFont systemFontOfSize:14];
                    _cWtextField.textColor = [UIColor colorWithRed:23 / 255.0 green:103 / 255.0 blue:186 / 255.0 alpha:1];
                    _cWtextField.placeholder = @"单位(磅)";
                    _cWtextField.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:_cWtextField];
                }
            }
            if (indexPath.row == 1) {
                
                if (!_tWtextField) {
                    _tWtextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5 / 2, kScreenWidth - 90, 35)];
                    _tWtextField.font = [UIFont systemFontOfSize:14];
                    _tWtextField.textColor = [UIColor colorWithRed:23 / 255.0 green:103 / 255.0 blue:186 / 255.0 alpha:1];
                    _tWtextField.placeholder = @"单位(磅)";
                    _tWtextField.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:_tWtextField];
                }
            }
            break;
        case 1:
            cell.titleLabel.text = _titleArray[indexPath.row + 4];
            cell.subTitleLabel.text = _subTitleArray[indexPath.row + 4];
            break;
        default:
            break;
    }}else{
        
        if (_indexPath == indexPath) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = [UIColor colorWithRed:23 / 255.0 green:103 / 255.0 blue:186 / 255.0 alpha:1];
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor blackColor];
        }
        if (tableView.tag == 214){
    
            cell.textLabel.text = _weekArray[indexPath.row];
        }else if (tableView.tag == 215){
        
            cell.textLabel.text = _activityArray[indexPath.row];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 213) {
    if (section == 0) {
        return 60;
    }
    return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return @"当前状态";
    }
    return @"健身目标";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 213) {
       
        if (indexPath.section == 0) {
            
            _index = indexPath.row;
        }else{
            _index = indexPath.row + 4;
        }
        if (_index > 1) {
          
            [self pkViewHiddenClose];
        }
    }else {
       
        [self tableviewHiddenOpen];
        _indexPath = indexPath;
        
        if (tableView.tag == 214) {
            
            _isSureSring =[_weekArray objectAtIndex:indexPath.row];
            
        }else if (tableView.tag == 215){
            
            _isSureSring =[_activityArray objectAtIndex:indexPath.row];
        }
    }
}


#pragma - mark  pickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1100) {
        
        return 29;
    }
    if (pickerView.tag == 1101) {
        
        return 361;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1100) {
        
        return _exercisePkViewArray[row];
    }
    if (pickerView.tag == 1101) {
        
        return _minutesPkViewArray[row];
    }
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 60;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1100) {
        
        _isSureSring = _exercisePkViewArray[row];
    }
    if (pickerView.tag == 1101) {
        
        _isSureSring = _minutesPkViewArray[row];
    }
}
@end

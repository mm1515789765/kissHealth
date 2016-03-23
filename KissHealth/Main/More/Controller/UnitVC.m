//
//  UnitVC.m
//  KissHealth
//
//  Created by Apple on 16/2/3.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "UnitVC.h"

@interface UnitVC ()
{
    NSArray *_titleArray;
    NSArray *_sectionTitleArray;
    NSIndexPath *_selectedIndexPath;
}

@end

@implementation UnitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"单位首选项";
    
    _titleArray = @[@"磅",@"公斤",@"英尺/尺寸",@"厘米",@"英里",@"公里",@"卡路里",@"千焦耳"];
    
    _sectionTitleArray = @[@"体重",@"身高",@"距离",@"能量"];
    [self _createItem];
}

- (void)_createItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"ic_nav_arrow_left@2x"] forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"ic_nav_checkmark@2x"] forState:UIControlStateNormal];
    rightBtn.showsTouchWhenHighlighted = YES;
    [rightBtn addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightButtonAction
{
    NSArray *arr = [self.tableView visibleCells];
    NSMutableArray *arr1 = [NSMutableArray array];
    for (UITableViewCell *cell in arr) {
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {

            [arr1 addObject:cell.textLabel.text];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUnitNotification object:arr1];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonAction
{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
   
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_selectedIndexPath == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = _titleArray[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = _titleArray[indexPath.row + 2];
            break;
        case 2:
            cell.textLabel.text = _titleArray[indexPath.row + 4];
            break;
        case 3:
            cell.textLabel.text = _titleArray[indexPath.row + 6];
            break;
        default:
            break;
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionTitleArray[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

@end

//
//  KHDiaryTableView.m
//  KissHealth
//
//  Created by Macx on 16/2/14.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHDiaryTableView.h"
#import "KHControl.h"
#import "DiaryFootCell.h"

static NSString *identifier = @"KHDiary";
@interface KHDiaryTableView ()
{
    NSArray *_diaryTitleArr;
}

@end

@implementation KHDiaryTableView 


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;

        self.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];

        _diaryTitleArr = @[
                            @"早餐",
                            @"午餐",
                            @"晚餐",
                            @"零食",
                            @"运动",
                           ];
        
    }
    return self;
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   DiaryFootCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[DiaryFootCell alloc] init];
    }
    
    NSString *addString = @"添加食物";
   
    if (indexPath.section == 4) {
        addString = @"添加运动";
    }
    
    cell.addString = addString;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = _diaryTitleArr[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background"]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7.5, 100, 15)];
    
    titleLabel.text = _diaryTitleArr[section];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [self _createFootViewWithSection:section];
    
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 15 + 36;
    }
    
    return 15;
}

#pragma  mark - FootView
- (UIView *)_createFootViewWithSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    

    view.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    return view;
}



@end

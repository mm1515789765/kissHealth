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
#import "KHDiaryModel.h"
#import "KHDiaryDetailModel.h"
#import "FoodModel.h"
#import "ExciseModel.h"
#import "WaterModel.h"


typedef NS_ENUM(NSInteger, cellTitle)
{
    BreakFast,
    Lunch,
    Dinner,
    Snack,
    Excise,
    Water
};

static NSString *footIdentifier = @"footCell";
static NSString *identifier = @"KHDiaryCell";
@interface KHDiaryTableView ()
{
//    NSArray *_diaryTitleArr;
    NSMutableArray *_diaryTitleList;
}

@end

@implementation KHDiaryTableView 


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style diaryModel:(KHDiaryModel *)sharedModel
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _diaryModel = sharedModel;
        
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        

        self.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        
        _diaryTitleList = _diaryModel.itemList;
    }
    return self;
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"%ld", _diaryModel.itemList.count);
    return _diaryModel.itemList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case BreakFast: return _diaryModel.detailModel.breakfastList.count + 1;
            break;
        case Lunch: return _diaryModel.detailModel.lunchList.count + 1;
            break;
        case Dinner: return _diaryModel.detailModel.dinnerList.count + 1;
            break;
        case Snack: return _diaryModel.detailModel.snackList.count + 1;
            break;
        case Excise: return _diaryModel.detailModel.exciseList.count + 1;
            break;
        case Water: return _diaryModel.detailModel.waterList.count;
            break;
            
        default:
            break;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    DiaryFootCell *footCell = [tableView dequeueReusableCellWithIdentifier:footIdentifier];
    
    if (footCell == nil) {
        footCell = [[DiaryFootCell alloc] init];
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    footCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *addString = @"添加食物";
   
    if (indexPath.section == 4) {
        addString = @"添加运动";
    }
    
    footCell.addString = addString;
    footCell.selectionStyle = UITableViewCellSelectionStyleNone;
    footCell.title = _diaryTitleList[indexPath.section];
    
    if (indexPath.section >= 0 && indexPath.section < 4) {
        NSArray *foodArray = [self foodArray:indexPath];
        if (foodArray.count > 0 && indexPath.row < foodArray.count) {
            FoodModel *model = foodArray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@  卡路里：%ld", model.name, model.kalori];
        }
        
        if (indexPath.row == foodArray.count || foodArray.count == 0) {
            return footCell;
        }
        
        return cell;
    }
    if (indexPath.section == 4) {
        NSArray *exciseArray = _diaryModel.detailModel.exciseList;
        if (exciseArray.count > 0 && indexPath.row < exciseArray.count) {
            ExciseModel *model = exciseArray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@  卡路里：%ld  时间：%ld 分钟", model.name, model.finishedKal, model.finishedTime];
        }
        
        if (indexPath.row == exciseArray.count || exciseArray.count == 0) {
            return footCell;
        }
        
        return cell;
    }
    else{
        
        NSArray *waterArray = _diaryModel.detailModel.waterList;
        if (waterArray.count > 0 && indexPath.row < waterArray.count) {
            WaterModel *model = waterArray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@  数量：%ld 杯", model.name, model.CupNumber];
        }
        
        if (indexPath.row == waterArray.count || waterArray.count == 0) {
            footCell.addString = @"添加";
            return footCell;
        }
        
        return cell;
    }
    

    
    
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
    
    titleLabel.text = _diaryTitleList[section];
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
    if (section == _diaryModel.itemList.count - 1) {
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

- (NSArray *)foodArray:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case BreakFast: return _diaryModel.detailModel.breakfastList;
            break;
        case Lunch: return _diaryModel.detailModel.lunchList;
            break;
        case Dinner: return _diaryModel.detailModel.dinnerList;
            break;
        case Snack: return _diaryModel.detailModel.snackList;
            break;
            
        default: return nil;
            break;
    }
}



@end

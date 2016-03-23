//
//  ProfileTableView.m
//  KissHealth
//
//  Created by Apple on 16/2/3.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "ProfileTableView.h"
#import "ProfileCell.h"
#import "UnitVC.h"
#define KtableViewHeight  self.frame.size.height


@implementation ProfileTableView
{
    NSArray *_titleArray;
    UIDatePicker *_birthDatePicker;
    UIView *_pkHeaderView;
    NSMutableArray *_subViewArray;   //选择行的时候跳转或者显示的view数组
    NSInteger _index;                //记录选择的行
    
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        NSArray *arr = @[@"难",@"女",@"哈哈",@"哦",@"哟西",@"sorry、",@"why",@"www",@"hahah"];
        _subTitleArray = [NSMutableArray array];
        [_subTitleArray addObjectsFromArray:arr];//等待前面界面传初始值

        _titleArray = @[@"资料头像",@"身高",@"性别",@"出生日期",@"国家／地区",@"邮政编码",@"时区",@"邮箱地址",@"单位"];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:NULL] forCellReuseIdentifier:@"profileCell"];
        
        [self _createView];
        
    }
    return self;
}


- (void)_createView
{
    _subViewArray = [NSMutableArray array];
    _birthDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, KtableViewHeight / 2 - 50, kScreenWidth, KtableViewHeight / 2)];
    _birthDatePicker.datePickerMode = UIDatePickerModeDate;
    [_birthDatePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    _birthDatePicker.backgroundColor = [UIColor whiteColor];
    [_birthDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _pkHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, KtableViewHeight / 2, kScreenWidth, 50)];
    _pkHeaderView.backgroundColor = [UIColor colorWithRed:0 green:115 / 255.0 blue:183 / 255.0 alpha:1];
    
    CGFloat MinY = (50 - 30) / 2;
    UIButton *pkHeadLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, MinY, 30, 30)];
    pkHeadLeftBtn.tag = 200;
    [pkHeadLeftBtn addTarget:self action:@selector(pkHeaderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pkHeadLeftBtn setImage:[UIImage imageNamed:@"ic_nav_close@2x"] forState:UIControlStateNormal];
    UIButton *pkHeadRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, MinY, 30, 30)];
    pkHeadRightBtn.tag = 201;
    [pkHeadRightBtn addTarget:self action:@selector(pkHeaderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pkHeadRightBtn setImage:[UIImage imageNamed:@"ic_nav_checkmark@2x"] forState:UIControlStateNormal];
    
    _pkHeaderView.hidden = YES;
    _birthDatePicker.hidden = YES;
    [_pkHeaderView addSubview:pkHeadRightBtn];
    [_pkHeaderView addSubview:pkHeadLeftBtn];
    [_subViewArray addObject:_birthDatePicker];
    [self addSubview:_birthDatePicker];
    [self addSubview:_pkHeaderView];
}

- (void)pkHeaderBtnAction:(UIButton *)sender
{
    if (sender.tag == 200) {
        
        [self ViewHiddenOpen];
        
    }else if (sender.tag == 201){
        
        [self ViewHiddenOpen];
        
        switch (_index) {
            case 1:
                
                break;
            case 2:
                
                break;
            case 3:
                [_subTitleArray replaceObjectAtIndex:_index withObject:[self datePickerValueChanged:_birthDatePicker]];
                [self reloadData];

                break;
            case 4:
                
                break;
            case 5:

                
                
                break;

  
            default:
                break;
        }
    }
}

- (NSString *)datePickerValueChanged:(UIDatePicker *)datepicker
{
    NSDate *currentDate = datepicker.date;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    NSString *str = [fmt stringFromDate:currentDate];
    
    return str;
}

- (void)ViewHiddenOpen
{
    _pkHeaderView.hidden = YES;
//    _glassView.hidden = YES;
    for (UIView *view in _subViewArray) {
        
            view.hidden = YES;
    }
}

- (void)ViewHiddenClose
{
    switch (_index) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            _pkHeaderView.hidden = NO;
            _birthDatePicker.hidden = NO;
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
            
            [[self responder].navigationController pushViewController:[[UnitVC alloc] init] animated:YES];
            break;

        default:
            break;
    }
    
}




#pragma - mark UITableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.subTitleLabel.text = _subTitleArray[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
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
    [self ViewHiddenClose];
}

- (UIViewController *)responder
{
    UIResponder *next = self.nextResponder;
    
    while (next != nil) {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return  nil;
}



@end

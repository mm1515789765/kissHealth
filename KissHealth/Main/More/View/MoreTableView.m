//
//  MoreTableView.m
//  KissHealth
//
//  Created by Apple on 16/1/30.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "MoreTableView.h"
#import "MoreCell.h"
#import "profileVC.h"
#import "TargetVC.h"
#import "RemindVC.h"
#import "SettingVC.h"
#import "VersionVC.h"


@implementation MoreTableView
{
    NSArray *_imgArray;
    NSArray *_titleArray;
    UIWebView *webView;
    UIViewController *vc;
    UILabel *syncLabel;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        _imgArray = @[@"ic_menu_editprofile@2x",@"ic_menu_goals@2x",@"ic_menu_reminders@2x",@"ic_menu_ua_logo@2x",@"ic_menu_settings@2x",@"ic_menu_sync@2x",@"ic_menu_help@2x"];
        _titleArray = @[@"个人资料",@"目标",@"提醒",@"商店健身器材",@"设置",@"同步",@"关于版本"];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:@"MoreCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"moreCell"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imgArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
    if (indexPath.row == 5) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleImg.image = [UIImage imageNamed:_imgArray[indexPath.row]];
    cell.titleLabel.text = _titleArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 5)];
    label.text = @"已增重";
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor whiteColor];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 50, 30)];
    label1.text = @"0磅";
    label1.textColor = [UIColor whiteColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 10, 50, 5)];
    label2.text = @"持续时间";
    label2.font = [UIFont systemFontOfSize:11];
    label2.textColor = [UIColor whiteColor];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 70, 20, 50, 30)];
    label3.text = @"0天";
    label3.textAlignment = NSTextAlignmentRight;
    label3.textColor = [UIColor whiteColor];
    
    [headerView addSubview:label];
    [headerView addSubview:label1];
    [headerView addSubview:label2];
    [headerView addSubview:label3];

    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (webView == nil) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        NSURL *url = [NSURL URLWithString:@"http://underarmour.cn"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
        vc = [[UIViewController alloc] init];
        [vc.view addSubview:webView];
    }
    
    switch (indexPath.row) {
        case 0:
            [[self responder].navigationController pushViewController:[[ProfileVC alloc] init] animated:YES];
            break;
        case 1:
            [[self responder].navigationController pushViewController:[[TargetVC alloc] init] animated:YES];
            break;
        case 2:
            [[self responder].navigationController pushViewController:[[RemindVC alloc] init] animated:YES];
            break;
        case 3:
            [[self responder].navigationController pushViewController:vc animated:YES];
            break;
        case 4:
            [[self responder].navigationController pushViewController:[[SettingVC alloc] init] animated:YES];
            break;
        case 5:
        {
            NSArray *arr = [self visibleCells];
            CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            basic.fromValue = @0;
            basic.toValue = @12;
            basic.duration = 5;
            basic.repeatCount = 2;
            [[((MoreCell *)arr[5]).contentView viewWithTag:555].layer addAnimation:basic forKey:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
        }
            break;
        case 6:
            [[self responder].navigationController pushViewController:[[VersionVC alloc] init] animated:YES];
            break;
        default:
            break;
    }
}

- (void)timeAction:(NSTimer *)timer
{
    static NSInteger i  = 0;
    i++;
    
    if (syncLabel == nil) {
        syncLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, 120, 30)];
        
        syncLabel.tag = 556;
        syncLabel.text = @"同步完成";
        syncLabel.font = [UIFont systemFontOfSize:12];
    }

    NSArray *arr = [self visibleCells];
    
    if (i == 1) {
        
        [[((MoreCell *)arr[5]).contentView viewWithTag:556] removeFromSuperview];
    }
    
    if (i == 8) {
        
        [((MoreCell *)arr[5]).contentView addSubview:syncLabel];
        i = 0;
        [timer invalidate];
        [self reloadData];
    }
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

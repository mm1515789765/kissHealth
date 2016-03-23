//
//  VersionVC.m
//  KissHealth
//
//  Created by Apple on 16/2/19.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "VersionVC.h"
#import "MoreCell.h"
#define kLineSpace  5
#define version @"版本1.0"

@interface VersionVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_versionTV;
    NSArray *_imgArray;
    NSArray *_titleArray;
    UIWebView *_webView;
    UIViewController *_vc;
}

@end

@implementation VersionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于版本";
    self.tabBarController.tabBar.hidden = YES;
    
    [self _createBackItem];
    
    _imgArray = @[@"ic_fb@2x",@"ic_invite_tw@2x"];
    _titleArray = @[@"在Facebook上关注我们",@"在twitter上关注我们"];
    
    _versionTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _versionTV.delegate = self;
    _versionTV.dataSource = self;
    _versionTV.bounces = NO;
    _versionTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    CGFloat minX = (kScreenWidth - 170) / 2;
    CGFloat minY = kScreenHeight - 140;
    CGFloat minX2 = (kScreenWidth - 100) / 2;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(minX, minY, 170, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"版权所有 2016,KissHealth";
    label.font = [UIFont systemFontOfSize:14];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(minX2, minY + 21, 100, 20)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"保留所有权利。";
    label1.font = [UIFont systemFontOfSize:14];

    
    [self.view addSubview:_versionTV];
    [self.view addSubview:label];
    [self.view addSubview:label1];
    
    [_versionTV registerNib:[UINib nibWithNibName:@"MoreCell" bundle:NULL] forCellReuseIdentifier:@"moreCell"];
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

#pragma - mark uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 150;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
      
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        CGFloat imgMinX = (kScreenWidth - 250) / 2;
        CGFloat imgMinY = cell.center.y - 100;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgMinX, imgMinY, 700, 110)];
        imgView.image = [UIImage imageNamed:@"ic_logo@2x.png"];
        
        CGFloat labelMinX = (kScreenWidth - 60) / 2;
        CGFloat labelMinY = cell.center.y - 15;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelMinX   , labelMinY, 60, 20)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = version;

        
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        view.center = cell.center;
        [view addSubview:imgView];
        [view addSubview:label];
        [cell.contentView addSubview:view];
        
    }else{
    
        cell.titleImg.image = [UIImage imageNamed:_imgArray[indexPath.row - 1]];
        cell.titleLabel.text = _titleArray[indexPath.row - 1];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_webView) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 49)];
    }
    if (!_vc) {
        
        _vc = [[UIViewController alloc] init];

    }
    
    
    if (indexPath.row == 1) {
    
        NSURL *url = [NSURL URLWithString:@"http://www.facebook.com"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [_webView loadRequest:request];
        [_vc.view addSubview:_webView];
        [self.navigationController pushViewController:_vc animated:YES];

    }else if (indexPath.row == 2){
    
        NSURL *url = [NSURL URLWithString:@"https://twitter.com"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [_webView loadRequest:request];
        [_vc.view addSubview:_webView];
        [self.navigationController pushViewController:_vc animated:YES];
    }
}


@end

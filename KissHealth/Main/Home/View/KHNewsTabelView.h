//
//  KHNewsTabelView.h
//  KissHealth
//
//  Created by Macx on 16/1/31.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsDetailVC;

@interface KHNewsTabelView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (copy, nonatomic) NSArray *models;

@property (strong, nonatomic) NewsDetailVC *newsDetailVC;

@end

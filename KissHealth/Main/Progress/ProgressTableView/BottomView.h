//
//  BottomView.h
//  KissHealth
//
//  Created by Lix on 16/2/16.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataTableView;
@interface BottomView : UIView

//底部的表视图
@property (strong, nonatomic) DataTableView * dataTableView;

//自写方法 创建数据源
- (id)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource;

@end

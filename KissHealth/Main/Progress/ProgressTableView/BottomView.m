//
//  BottomView.m
//  KissHealth
//
//  Created by Lix on 16/2/16.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "BottomView.h"
#import "TitleView.h"
#import "DataTableView.h"

@interface BottomView()
//数据源
@property (strong, nonatomic)NSMutableArray * dataSource;

@end
@implementation BottomView

- (id)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataSource = [NSMutableArray arrayWithArray:dataSource];
        
        [self buildTitleView];
        
        [self buildTableView];
    }
    return self;
}




- (void)buildTitleView
{
    TitleView * titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [self addSubview:titleView];
    
}

- (void)buildTableView
{
    _dataTableView = [[DataTableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40) style:UITableViewStylePlain withDataSource:self.dataSource];
    
    [self addSubview:_dataTableView];
    
}
@end

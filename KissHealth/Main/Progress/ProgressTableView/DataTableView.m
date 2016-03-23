//
//  DataTableView.m
//  KissHealth
//
//  Created by Lix on 16/2/16.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DataTableView.h"
#import "DataTableViewCell.h"
@interface DataTableView()

//TableView 的数据源
@property (strong, nonatomic) NSMutableArray * dataArray;

@end

@implementation DataTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withDataSource:(NSMutableArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerNib:[UINib nibWithNibName:@"DataTableViewCell" bundle:nil] forCellReuseIdentifier:@"DataCell"];
        
        [self reloadData];
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end

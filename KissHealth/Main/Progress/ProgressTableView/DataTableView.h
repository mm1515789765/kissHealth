//
//  DataTableView.h
//  KissHealth
//
//  Created by Lix on 16/2/16.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataTableView : UITableView <UITableViewDataSource , UITableViewDelegate>



- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withDataSource:(NSMutableArray * )dataArray;

@end

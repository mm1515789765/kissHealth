//
//  ProfileTableView.h
//  KissHealth
//
//  Created by Apple on 16/2/3.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)NSMutableArray *subTitleArray;

@end

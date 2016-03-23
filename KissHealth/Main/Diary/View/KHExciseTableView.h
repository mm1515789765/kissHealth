//
//  KHExciseTableView.h
//  KissHealth
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExciseModel;
@class FoodViewController;
@interface KHExciseTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) ExciseModel *checkExcise;

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title;
- (FoodViewController *)viewController;

@end

//
//  KHFoodTableView.h
//  KissHealth
//
//  Created by Macx on 16/2/19.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodViewController;
@class FoodModel;
@interface KHFoodTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, copy) NSString *title;

@property(nonatomic, strong) FoodModel *checkFood;

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title;
- (FoodViewController *)viewController;


@end

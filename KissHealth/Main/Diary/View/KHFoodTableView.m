//
//  KHFoodTableView.m
//  KissHealth
//
//  Created by Macx on 16/2/19.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHFoodTableView.h"
#import "FoodModel.h"
#import "FoodViewController.h"

static NSString *identifier = @"KHFoodCell";
@interface KHFoodTableView ()
{
    NSArray *_foodNameList;
    NSArray *_foodList;
}

@end

@implementation KHFoodTableView

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        
        self.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        
           _foodNameList = @[
                         @"米饭",
                         @"面",
                         @"肉类",
                         @"蔬菜",
                         @"雪碧",
                         @"可乐",
                         @"薯片",
                         @"苹果",
                         @"香蕉",
                         @"坚果",
                         @"巧克力",
                         @"牛奶",
                         ];
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSUInteger i = _foodNameList.count; i > 0; i--) {
            FoodModel *food = [[FoodModel alloc] init];
            food.name = _foodNameList[i - 1];
            food.kalori = i * 10;
            
            [list addObject:food];
        }
        _foodList = [NSArray arrayWithArray:list];
    }
    return self;
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _foodList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [_foodList[indexPath.row] name];
    
    return  cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.viewController.navigationItem.rightBarButtonItem.enabled = YES;
    _checkFood = _foodList[indexPath.row];
    
}

- (FoodViewController *)viewController
{
    UIResponder *responder = self;
    
    do {
        responder = responder.nextResponder;
        
        if ([responder isKindOfClass:[FoodViewController class]]) {
            break;
        }
        
    } while (YES);
    
    return (FoodViewController *)responder;
}

@end

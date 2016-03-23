//
//  FoodViewController.h
//  KissHealth
//
//  Created by Macx on 16/2/15.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodModel;
@class ExciseModel;
@interface FoodViewController : UIViewController

@property(nonatomic, strong) FoodModel *foodEat;
@property(nonatomic, strong) ExciseModel *exciseDone;

@end

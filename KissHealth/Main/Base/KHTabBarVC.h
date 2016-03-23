//
//  KHTabBarVC.h
//  KissHealth
//
//  Created by Macx on 16/1/27.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface KHTabBarVC : UITabBarController

@property(nonatomic, strong) BaseNavigationController *diaryNavi;

- (void)selectVC:(UIButton *)sender;

@end

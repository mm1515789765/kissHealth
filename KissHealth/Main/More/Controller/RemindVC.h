//
//  RemindVC.h
//  KissHealth
//
//  Created by Apple on 16/2/3.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindVC : UIViewController

@property (nonatomic,assign)NSInteger selectPkViewIndex;
@property (nonatomic,copy)NSString *isSureString;

@property (nonatomic,copy)NSMutableArray *foodSectionArray;
@property (nonatomic,copy)NSMutableArray *weightSectionArray;
@property (nonatomic,copy)NSMutableArray *generalSectionArray;

@end

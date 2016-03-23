//
//  KHDiaryDetailModel.m
//  KissHealth
//
//  Created by Macx on 16/2/18.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHDiaryDetailModel.h"
#import "FoodModel.h"
#import "exciseModel.h"
#import "waterModel.h"
#import "KHDiaryModel.h"


@implementation KHDiaryDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.breakfastList = [[NSMutableArray alloc] init];
        self.lunchList = [[NSMutableArray alloc] init];
        self.dinnerList = [[NSMutableArray alloc] init];
        self.snackList = [[NSMutableArray alloc] init];
        self.exciseList = [[NSMutableArray alloc] init];
        self.waterList = [[NSMutableArray alloc] init];
        
        
        
    }
    return self;
}




@end

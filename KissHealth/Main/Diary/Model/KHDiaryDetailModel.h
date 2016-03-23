//
//  KHDiaryDetailModel.h
//  KissHealth
//
//  Created by Macx on 16/2/18.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FoodModel;
@class exciseModel;
@class waterModel;

@interface KHDiaryDetailModel : NSObject

@property(nonatomic, strong) NSMutableArray *breakfastList;
@property(nonatomic, strong) NSMutableArray *lunchList;
@property(nonatomic, strong) NSMutableArray *dinnerList;
@property(nonatomic, strong) NSMutableArray *snackList;
@property(nonatomic, strong) NSMutableArray *exciseList;
@property(nonatomic, strong) NSMutableArray *waterList;

//@property(nonatomic, ) 

@end

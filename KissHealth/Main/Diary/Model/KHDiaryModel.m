//
//  KHDiaryModel.m
//  KissHealth
//
//  Created by Macx on 16/2/15.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHDiaryModel.h"
#import "KHDiaryDetailModel.h"
#import "FoodModel.h"
#import "ExciseModel.h"
#import "WaterModel.h"

@implementation KHDiaryModel

+ (instancetype)sharedDiaryModel
{
    static KHDiaryModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[super allocWithZone:nil] init];
        
    });
    
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedDiaryModel];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _targetKal = 0;
        _foodKal = 0;
        _exciseKal = 0;
        _remainedKal = 0;
        
        self.detailModel = [[KHDiaryDetailModel alloc] init];
        
        _itemList = [NSMutableArray arrayWithObjects:@"早餐", @"午餐", @"晚餐", @"零食", @"运动", nil];
        
        _diaryArr = [NSMutableArray arrayWithArray:@[
                                                     [NSNumber numberWithInteger:_targetKal],
                                                     [NSNumber numberWithInteger:_foodKal],
                                                     [NSNumber numberWithInteger:_exciseKal],
                                                     [NSNumber numberWithInteger:_remainedKal]
                                                     ]];
        
    }
    return self;
}

- (void)setTargetKal:(NSInteger)targetKal
{
    if (_targetKal != targetKal) {
        _targetKal = targetKal;
        
        _diaryArr[0] = [NSNumber numberWithInteger:_targetKal];
    
        [self calculateRemainedKal];
    }
}

- (void)setFoodKal:(NSInteger)foodKal
{
    if (_foodKal != foodKal) {
        _foodKal = foodKal;
        
        _diaryArr[1] = [NSNumber numberWithInteger:_foodKal];
        
        [self calculateRemainedKal];
    }
}

- (void)setExciseKal:(NSInteger)exciseKal
{
    if (_exciseKal != exciseKal) {
        _exciseKal = exciseKal;
        
        _diaryArr[2] = [NSNumber numberWithInteger:_exciseKal];
        
        [self calculateRemainedKal];
    }
}

- (void)setRemainedKal:(NSInteger)remainedKal
{
    if (_remainedKal != remainedKal) {
        _remainedKal = remainedKal;
        
        _diaryArr[3] = [NSNumber numberWithInteger:_remainedKal];
        
        [self calculateRemainedKal];
    }
}

- (void)setDetailModel:(KHDiaryDetailModel *)detailModel
{
    if (detailModel != nil) {
        _detailModel = detailModel;
        
        _foodKal = 0;
        _exciseKal = 0;
        
        for (int i = 0; i < detailModel.breakfastList.count; i++) {
            
            FoodModel *food = detailModel.breakfastList[i];
            self.foodKal = self.foodKal + food.kalori;
        }
        
        for (int i = 0; i < detailModel.lunchList.count; i++) {
            
            FoodModel *food = detailModel.lunchList[i];
            self.foodKal = self.foodKal + food.kalori;
        }
        
        for (int i = 0; i < detailModel.dinnerList.count; i++) {
            
            FoodModel *food = detailModel.dinnerList[i];
            self.foodKal = self.foodKal + food.kalori;
        }
        
        for (int i = 0; i < detailModel.snackList.count; i++) {
            
            FoodModel *food = detailModel.snackList[i];
            self.foodKal = self.foodKal + food.kalori;
        }
        
        for (int i = 0; i < detailModel.exciseList.count; i++) {
            
            ExciseModel *excise = detailModel.exciseList[i];
            self.exciseKal = self.exciseKal + excise.finishedKal;
        }
        
//        if (detailModel.waterList.count > 0) {
//            [_itemList addObject:@"水"];
//        }
        
    }
}

- (void)calculateRemainedKal
{
    self.remainedKal = _targetKal + _foodKal - _exciseKal;
}

- (void)reloadData
{
    [self setDetailModel:_detailModel];
}


@end

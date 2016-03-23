//
//  KHDiaryModel.m
//  KissHealth
//
//  Created by Macx on 16/2/15.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHDiaryModel.h"

@implementation KHDiaryModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _targetKal = 0;
        _foodKal = 0;
        _exciseKal = 0;
        _remainedKal = 0;
        
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
    
    }
}

- (void)setFoodKal:(NSInteger)foodKal
{
    if (_foodKal != foodKal) {
        _foodKal = foodKal;
        
        _diaryArr[1] = [NSNumber numberWithInteger:_foodKal];
        
    }
}

- (void)setExciseKal:(NSInteger)exciseKal
{
    if (_exciseKal != exciseKal) {
        _exciseKal = exciseKal;
        
        _diaryArr[2] = [NSNumber numberWithInteger:_exciseKal];
        
    }
}

- (void)setRemainedKal:(NSInteger)remainedKal
{
    if (_remainedKal != remainedKal) {
        _remainedKal = remainedKal;
        
        _diaryArr[3] = [NSNumber numberWithInteger:_remainedKal];
        
    }
}


@end

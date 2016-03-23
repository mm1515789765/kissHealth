//
//  KHDiaryModel.h
//  KissHealth
//
//  Created by Macx on 16/2/15.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <Foundation/Foundation.h>


@class KHDiaryDetailModel;
@interface KHDiaryModel : NSObject

@property(nonatomic, assign) NSInteger targetKal;
@property(nonatomic, assign) NSInteger foodKal;
@property(nonatomic, assign) NSInteger exciseKal;
@property(nonatomic, assign) NSInteger remainedKal;

@property(nonatomic, strong) KHDiaryDetailModel *detailModel;
@property(nonatomic, strong) NSMutableArray *itemList;

@property(nonatomic, strong) NSMutableArray *diaryArr;


+ (instancetype)sharedDiaryModel;

- (void)reloadData;

@end

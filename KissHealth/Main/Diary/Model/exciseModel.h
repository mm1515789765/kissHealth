//
//  ExciseModel.h
//  KissHealth
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExciseModel : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) double kalori;
@property(nonatomic, assign) NSInteger finishedKal;
@property(nonatomic, assign) NSInteger finishedTime;

@end

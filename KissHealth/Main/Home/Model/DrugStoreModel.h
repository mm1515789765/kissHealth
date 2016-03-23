//
//  DrugStoreModel.h
//  KissHealth
//
//  Created by Macx on 16/2/10.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugStoreModel : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *tel;
@property(nonatomic, copy) NSString *x;        //经度
@property(nonatomic, copy) NSString *y;        //纬度



@end

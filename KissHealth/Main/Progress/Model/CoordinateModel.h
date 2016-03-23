//
//  CoordinateModel.h
//  KissHealth
//
//  Created by Lix on 16/2/12.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinateModel : NSObject

//x坐标值
@property (copy , nonatomic)NSString * coordinateXValue;
//y坐标值
@property (copy , nonatomic)NSString * coordinateYValue;


/**
 *
 *
 *  @param xValue x轴坐标值
 *  @param yValue y轴坐标值
 *
 *  @return
 */
- (id)initWithXValue:(NSString *)xValue withYValue:(NSString *)yValue;


@end

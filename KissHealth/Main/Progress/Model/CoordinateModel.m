//
//  CoordinateModel.m
//  KissHealth
//
//  Created by Lix on 16/2/12.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "CoordinateModel.h"

@implementation CoordinateModel

- (id)initWithXValue:(NSString *)xValue withYValue:(NSString *)yValue
{
    self = [super init];
    if (self) {
        self.coordinateXValue = xValue;
        self.coordinateYValue = yValue;
    }
    return self;
}

@end

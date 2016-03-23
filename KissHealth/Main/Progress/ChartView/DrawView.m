//
//  DrawView.m
//  KissHealth
//
//  Created by Lix on 16/2/14.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DrawView.h"
#import "CoordinateModel.h"
#import "LineChartView.h"

#define kSpace_Between_X_Point 50       //图表 X轴之间的数据的间距
#define kMAX_POINT_NUM 6  //同屏出现的最多的坐标数

@interface DrawView()
//数据源
@property (strong , nonatomic) NSMutableArray * dataSource;

@end

@implementation DrawView




-(id)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource withAnimation:(BOOL)isAnimation
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
        self.dataSource = [NSMutableArray arrayWithArray:dataSource];
//        self.dataSource = dataSource;
        self.isAnimation = isAnimation;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self buildView];
    }
    return self;
}

//搭建折线图界面
- (void)buildView
{
    [self sizeForDataSource];
    
    LineChartView * lineChartView = [[LineChartView alloc] initWithDataSource:self.dataSource
                                                        withLineAndPointColor:[UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000] withAnimation:YES];
    if (self.dataSource.count <= 6) {
        lineChartView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }else if (self.dataSource.count > 6){
                lineChartView.frame = CGRectMake(0, 0, self.frame.size.width + (self.dataSource.count - kMAX_POINT_NUM) * (kSpace_Between_X_Point +2 ), self.frame.size.height);
    }
    
    
    [self addSubview:lineChartView];
    
}
/**
 *  根据数据源的数量来设置尺寸
 */
- (void)sizeForDataSource
{
    NSInteger arrayCount = [self.dataSource count];
    
    if (arrayCount > kMAX_POINT_NUM) {
        self.contentSize = CGSizeMake(self.frame.size.width + (arrayCount - kMAX_POINT_NUM) * kSpace_Between_X_Point, self.frame.size.height);
    }else{
        self.contentSize = CGSizeMake(self.frame.size.width - (kMAX_POINT_NUM - arrayCount) * kSpace_Between_X_Point, self.frame.size.height);
    }
}

@end

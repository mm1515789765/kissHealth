//
//  ChartView.m
//  KissHealth
//
//  Created by Lix on 16/2/13.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "ChartView.h"
#import "CoordinateModel.h"
#import "DrawView.h"
#import "DataView.h"
#import "TitleView.h"
@interface ChartView()

@property (strong, nonatomic)NSMutableArray * dataSource;

@end

@implementation ChartView

-(id)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataSource = [NSMutableArray arrayWithArray:dataSource];

        [self buildView];
    }
    return self;
}


/**
 *  构建数据源
 */
//- (void)buildDataSource
//{
//    self.dataSource = [NSMutableArray arrayWithCapacity:0];
//    
//    CoordinateModel * item = [[CoordinateModel alloc] initWithXValue:@"2/1" withYValue:@"70"];
//    [self.dataSource addObject:item];
//    
//    CoordinateModel * item1 = [[CoordinateModel alloc] initWithXValue:@"2/2" withYValue:@"75"];
//    [self.dataSource addObject:item1];
//    
//    CoordinateModel * item2 = [[CoordinateModel alloc] initWithXValue:@"2/3" withYValue:@"80"];
//    [self.dataSource addObject:item2];
//    
//    CoordinateModel * item3 = [[CoordinateModel alloc] initWithXValue:@"2/4" withYValue:@"70"];
//    [self.dataSource addObject:item3];
//    
//    CoordinateModel * item4 = [[CoordinateModel alloc] initWithXValue:@"2/5" withYValue:@"75"];
//    [self.dataSource addObject:item4];
//    
//    CoordinateModel * item5 = [[CoordinateModel alloc] initWithXValue:@"2/6" withYValue:@"80"];
//    [self.dataSource addObject:item5];
//    
////    CoordinateModel * item6 = [[CoordinateModel alloc] initWithXValue:@"2/7" withYValue:@"65"];
////    [self.dataSource addObject:item6];
////    
//    CoordinateModel * item7 = [[CoordinateModel alloc] initWithXValue:@"2/14" withYValue:@"20"];
//    [self.dataSource addObject:item7];
//    
////    CoordinateModel * item8 = [[CoordinateModel alloc] initWithXValue:@"2/14" withYValue:@"70"];
////    [self.dataSource addObject:item8];
//}

- (void)buildView
{
    
    DataView * dataView = [[DataView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60) withDataSource:self.dataSource];
    
    [self addSubview:dataView];
    
    
    DrawView * drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, self.frame.size.height - 60) withDataSource:self.dataSource withAnimation:YES];
    
    [self addSubview:drawView];
    
}




@end

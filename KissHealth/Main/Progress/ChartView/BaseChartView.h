//
//  BaseChartView.h
//  KissHealth
//
//  Created by Lix on 16/2/12.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEdge_Left 35                   //图表左边距离屏幕的间隔
#define kEdge_Top 30                    //图表顶部的间隔
#define kSpace_Between_X_Point 50       //图表 X轴之间的数据的间距
#define kY_SECTION 4                    //图表纵坐标轴的区间数



@interface BaseChartView : UIView

//数据源
@property (strong, nonatomic)NSMutableArray *dataSource;

//纵坐标上标记点的间距
@property (assign, nonatomic)CGFloat dashedSpace;

//纵坐标最大值
@property (assign, nonatomic) int maxYValue;

//纵坐标的数值间隔 （显示出来的坐标值的间隔）
@property (assign, nonatomic) int yNumberSpace;


/**
 *  自定义方法
 *
 *  @param dataSource 获取数据源
 *
 *  @return
 */
- (id)initWithDataSource:(NSMutableArray *)dataSource;

@end

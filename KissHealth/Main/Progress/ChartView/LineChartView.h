//
//  LineChartView.h
//  KissHealth
//
//  Created by Lix on 16/2/13.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "BaseChartView.h"

@interface LineChartView : BaseChartView

/**
 *  自定义方法
 *
 *  @param dataSource  数据源
 *  @param color       折线图点和折线的颜色
 *  @param isAnimation 是否动态绘制
 *
 *  @return 
 */
- (id)initWithDataSource:(NSMutableArray *)dataSource
   withLineAndPointColor:(UIColor *)color
           withAnimation:(BOOL)isAnimation;

@end

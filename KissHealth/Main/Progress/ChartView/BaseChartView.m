//
//  BaseChartView.m
//  KissHealth
//
//  Created by Lix on 16/2/12.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "BaseChartView.h"
#import "CoordinateModel.h"

#define kMAX_POINT_NUM 6  //同屏出现的最多的坐标数

@implementation BaseChartView

/**
 *  自定义方法
 *
 *  @param dataSource 获取数据源
 *
 *  @return
 */
- (id)initWithDataSource:(NSMutableArray *)dataSource
{
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    //绘制坐标系
    [self drawCoordinate];
}

/**
*  绘制坐标系
*/
- (void)drawCoordinate
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
    
    CGContextSetLineWidth(context, 0.5);
    
    //1、绘制x轴和y轴
    /**
     *  #define kEdge_Left 35                   //图表左边距离屏幕的间隔
     #define kEdge_Top 30                    //图表顶部的间隔
     #define kSpace_Between_X_Point 50       //图表 X轴之间的数据的间距
     #define kY_SECTION 4                    //图表纵坐标轴的区间数

     */

    /**
     *  绘制4条线 形成坐标轴
     */
//    CGPoint points[] = {CGPointMake(kEdge_Left, kEdge_Top),
//        CGPointMake(self.frame.size.width - kEdge_Left, kEdge_Top),
//        CGPointMake(self.frame.size.width - kEdge_Left, self.frame.size.height - kEdge_Top),
//        CGPointMake(kEdge_Left, self.frame.size.height - kEdge_Top)
//    };
//    
//    CGContextAddLines(context, points, 4);
//    CGContextClosePath(context);
//    CGContextStrokePath(context);
    
    if ([self dataSource].count <= 6) {

    CGPoint points[] = {CGPointMake(kEdge_Left, kEdge_Top),
        CGPointMake(self.frame.size.width , kEdge_Top),
        CGPointMake(self.frame.size.width, self.frame.size.height - kEdge_Top),
        CGPointMake(kEdge_Left, self.frame.size.height - kEdge_Top)
    };
    
    CGContextAddLines(context, points, 4);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    //2、绘制纵坐标上的分隔线
    self.dashedSpace = (CGFloat) (self.frame.size.height - 2*kEdge_Top)/kY_SECTION;
//    NSLog(@"%f~~~~",self.dashedSpace);
    
    for (int i = 1; i < kY_SECTION ; i++) {
        CGContextMoveToPoint(context, kEdge_Left, kEdge_Top + i * self.dashedSpace);
        CGContextAddLineToPoint(context, self.frame.size.width, kEdge_Top + self.dashedSpace * i );
    }
    CGContextStrokePath(context);
    }
    //当数据中的点超过同屏幕6个的时候  适配屏幕
    else if ([self dataSource].count > 6 ){
        
        CGPoint points[] = {CGPointMake(kEdge_Left, kEdge_Top),
            CGPointMake(self.frame.size.width - 20 , kEdge_Top),
            CGPointMake(self.frame.size.width - 20, self.frame.size.height - kEdge_Top),
            CGPointMake(kEdge_Left, self.frame.size.height - kEdge_Top)
        };
        
        CGContextAddLines(context, points, 4);
        CGContextClosePath(context);
        CGContextStrokePath(context);
        
        //2、绘制纵坐标上的分隔线
        self.dashedSpace = (CGFloat) (self.frame.size.height - 2*kEdge_Top)/kY_SECTION;
//        NSLog(@"%f~~~~",self.dashedSpace);
        
        for (int i = 1; i < kY_SECTION ; i++) {
            CGContextMoveToPoint(context, kEdge_Left, kEdge_Top + i * self.dashedSpace);
            CGContextAddLineToPoint(context, self.frame.size.width - 20 ,kEdge_Top + self.dashedSpace * i );
        }
        CGContextStrokePath(context);

    }
    

    //3、设置纵坐标值
    self.maxYValue = [self compareForMaxValue];
//    NSLog(@"%d!!!!!!",self.maxYValue);
    self.yNumberSpace = self.maxYValue / kY_SECTION ;
//    NSLog(@"!!!!!!!!%d",self.yNumberSpace);
    for (int i = 0; i < kY_SECTION + 1; i++) {
        
        CGPoint centerPoint = CGPointMake(kEdge_Left - 20 , kEdge_Top + self.dashedSpace * i);
        CGRect bounds = CGRectMake(0, 0, kEdge_Left - 15, 20);
        
        NSString * labelText = [NSString stringWithFormat:@"%d",self.yNumberSpace * (kY_SECTION - i)];
        
        UILabel * yNumber = [self createLabelWithCenter:centerPoint
                                             withBounds:bounds
                                               withText:labelText
                                      withtextAlignment:NSTextAlignmentRight];
        [self addSubview:yNumber];
        
        
   //还有UILabel的工厂方法没写
        
        
        //4、设置横坐标值
        for (int i = 0; i < [self.dataSource count]; i++) {
            CGPoint centerPoint = CGPointMake(kEdge_Left + kSpace_Between_X_Point * i , self.frame.size.height - kEdge_Top / 2);
            CGRect bounds = CGRectMake(0, 0, kSpace_Between_X_Point, 15);
            
            CoordinateModel * coordinateModel = [self.dataSource objectAtIndex:i];
         
            UILabel * xNumber = [self createLabelWithCenter:centerPoint
                                                 withBounds:bounds
                                    withText:coordinateModel.coordinateXValue
                                          withtextAlignment:NSTextAlignmentCenter];
            [self addSubview:xNumber];
            
        }
    }
}


//设置最大的纵坐标值
- (int)compareForMaxValue
{
    __block int maxYValue = 0;
    
    [self.dataSource enumerateObjectsUsingBlock:^(CoordinateModel * obj, NSUInteger idx, BOOL * stop) {
        if ([obj.coordinateYValue intValue] > maxYValue) {
            maxYValue = [obj.coordinateYValue intValue];
            
//            NSLog(@"%d",maxYValue);
        }
    }];
    
    
    
    //获取最大纵坐标值的整数
//    if (maxYValue % kY_SECTION != 0) {
//        maxYValue =maxYValue + (kY_SECTION - maxYValue%kY_SECTION);
//    }
//    
    return maxYValue;
}



//UILabel的排版方式
/**
 *
 *
 *  @param centerPoint   label的中心
 *  @param bounds        label的位置
 *  @param lableText     label的内容
 *  @param textAlignment label的内容排版方式
 *
 *  @return
 */
- (UILabel *) createLabelWithCenter:(CGPoint)centerPoint
                         withBounds:(CGRect)bounds
                           withText:(NSString *)labelText
                 withtextAlignment:(NSTextAlignment)textAlignment
{
    UILabel * label = [[UILabel alloc] init];
    
    label.center = centerPoint;
    label.bounds = bounds;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = textAlignment;
    label.text = labelText;
    
    return label;
}

@end

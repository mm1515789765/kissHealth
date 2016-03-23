//
//  LineChartView.m
//  KissHealth
//
//  Created by Lix on 16/2/13.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "LineChartView.h"
#import "CoordinateModel.h"

#define ANIMATION_DURATION 2
#define LINE_WIDTH 1

@interface LineChartView()

//折线和标点的颜色
@property (strong, nonatomic) UIColor *lineAndPointColor;

//是否动态绘制
@property (assign, nonatomic) BOOL isAnimation;

@end

@implementation LineChartView

- (id)initWithDataSource:(NSMutableArray *)dataSource withLineAndPointColor:(UIColor *)color withAnimation:(BOOL)isAnimation
{
    self = [super initWithDataSource:dataSource];
    if (self) {
        self.lineAndPointColor = color;
        self.isAnimation = isAnimation;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //创建图文上下文信息
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineAndPointColor.CGColor);
    CGContextSetFillColorWithColor(context, self.lineAndPointColor.CGColor);
    CGContextSetLineWidth(context, LINE_WIDTH);
    
    //绘制坐标点
    NSMutableArray * coordinateArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray * initCoordinateArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < [self.dataSource count]; i++) {
        
        CoordinateModel * coordinateModel = [self.dataSource objectAtIndex:i];
        
        //self.dashedSpace / self.yNumberSpace 计算Y轴上点与点之间的距离
        
        CGPoint itemCoordinate = CGPointMake(kEdge_Left + kSpace_Between_X_Point * i, self.frame.size.height - (kEdge_Top + [coordinateModel.coordinateYValue integerValue]*(self.dashedSpace / self.yNumberSpace)));
//        NSLog(@"coordinate y  = %f",self.frame.size.height - (kEdge_Top + [coordinateModel.coordinateYValue integerValue]*(self.dashedSpace / self.yNumberSpace)));
       
        
        //记录坐标点
        [coordinateArray addObject:NSStringFromCGPoint(itemCoordinate)];
        CGContextAddArc(context, itemCoordinate.x, itemCoordinate.y, 4, 0,2*M_PI, 1);
        CGContextFillPath(context);
        
        //记录初始化坐标点  为了以后形成动画
        itemCoordinate.y = self.frame.size.height - kEdge_Top;
        [initCoordinateArray addObject:NSStringFromCGPoint(itemCoordinate)];
    
    }
    
    CGContextStrokePath(context);
    
    //绘制折线
    CGContextSetLineDash(context, 0, 0, 0);
    
    //绘图路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (int i = 0 ; i < coordinateArray.count - 1; i++) {
        //一段折线的开始点
        NSString * startPointStr = [coordinateArray objectAtIndex:i];
        CGPoint startPoint = CGPointFromString(startPointStr);
        
        //一段折线的结束点
        NSString * endPointStr = [coordinateArray objectAtIndex:i+1];
        CGPoint endPoint = CGPointFromString(endPointStr);
        
        //绘制图形方法
        [self drawLineWithPath:path
                withStartPoint:startPoint
                  withEndPoint:endPoint];
        
    }
    CGContextStrokePath(context);
    CGPathRelease(path);
    
}




/**
 *  绘制折线
 *
 *  @param path       保存绘图信息的路径
 *  @param startPoint 开始的点
 *  @param endPoint   结束的点
 */
- (void)drawLineWithPath:(CGMutablePathRef)path
          withStartPoint:(CGPoint)startPoint
            withEndPoint:(CGPoint)endPoint
{
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = LINE_WIDTH;
    lineLayer.lineCap = kCALineCapButt;
    lineLayer.strokeColor = self.lineAndPointColor.CGColor;
    lineLayer.fillColor = nil;
    
    CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
    lineLayer.path = path;
    
    if (self.isAnimation) {
        CABasicAnimation * pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = ANIMATION_DURATION;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        pathAnimation.fillMode = kCAFillModeForwards;
        [lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
    
    [self.layer addSublayer:lineLayer];

}

@end

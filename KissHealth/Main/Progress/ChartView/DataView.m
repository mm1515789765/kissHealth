//
//  DataView.m
//  KissHealth
//
//  Created by Lix on 16/2/14.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DataView.h"
#import "CoordinateModel.h"
#define kSpaceHeight 10    //与上下之间的间隔大小
#define kSpaceEdge  20    //与左右之间的间隔大小

@interface DataView()

//数据源
@property (strong, nonatomic)NSMutableArray * dataSource;
@property (assign, nonatomic)float changeValue;   //体重变化的值
@property (assign, nonatomic)float percentValue;  //体重变化的百分比
@end

@implementation DataView

/**
 *  自定义方法
 *
 *  @param frame      frame
 *  @param dataSource 数据源信息
 *
 *  @return 
 */
-(id)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = [NSMutableArray arrayWithArray:dataSource];
        [self buildLeftLable];
        [self buildCenterLabel];
        [self buildRightLable];
        
    }
    return self;
    
}

- (void)buildLeftLable
{
//    float Space = (self.frame.size.width - 2 * kSpaceEdge) / 3 ;
//    

    //最初的体重数据Lable
    CGPoint dataPoint = CGPointMake(kSpaceEdge + 10, kSpaceHeight + 10);
    CGRect dataRect = CGRectMake(kSpaceEdge, kSpaceHeight, 40, 20);
    CoordinateModel * item = [self.dataSource objectAtIndex:0];
    
    float data = [item.coordinateYValue floatValue];
    NSString *dataStr = [NSString stringWithFormat:@"%.1f",data];
    UILabel * dataLabel = [self createLabelWithCenter:dataPoint
                                           withBounds:dataRect
                                             withText:dataStr
                                    withtextAlignment:NSTextAlignmentCenter withTextFont:18];
    [self addSubview:dataLabel];
    
    //左边的公斤
    CGPoint unitPoint = CGPointMake(kSpaceEdge + 50, kSpaceHeight + 10);
    CGRect unitRect = CGRectMake(kSpaceEdge + 50, kSpaceHeight, 40, 20);
    NSString * unitStr = @"公斤";
    UILabel * unitLabel = [self createLabelWithCenter:unitPoint
                                           withBounds:unitRect
                                             withText:unitStr
                                    withtextAlignment:NSTextAlignmentCenter withTextFont:20];
    [self addSubview:unitLabel];
    
    //最下边的开始
    CGPoint startPoint = CGPointMake(kSpaceEdge + 10, kSpaceHeight + 25);
    CGRect startRect = CGRectMake(kSpaceEdge, kSpaceHeight + 20 , 30, 10);
    NSString * startStr = @"开始";
    UILabel * startLabel = [self createLabelWithCenter:startPoint
                                            withBounds:startRect
                                              withText:startStr
                                     withtextAlignment:NSTextAlignmentCenter withTextFont:10];
    
    [self addSubview:startLabel];
    
}

- (void)buildCenterLabel
{
    //View的一半宽
    float half = self.frame.size.width/2;
    
    //最新体重数据Label
    CGPoint dataPoint = CGPointMake(half - 20, kSpaceHeight + 10);
    CGRect dataRect = CGRectMake(half - 40, kSpaceHeight, 40, 20);
    CoordinateModel *item = [self.dataSource lastObject];
    float data = [item.coordinateYValue floatValue];
    NSString *dataStr = [NSString stringWithFormat:@"%.1f",data];
    UILabel * dataLabel= [self createLabelWithCenter:dataPoint
                                           withBounds:dataRect
                                             withText: dataStr
                                   withtextAlignment:NSTextAlignmentCenter
                                              withTextFont:18];
    
    [self addSubview:dataLabel];
    
    //单位Label
    CGPoint unitPoint = CGPointMake(half + 20, kSpaceHeight + 10);
    CGRect unitRect = CGRectMake(half, kSpaceHeight, 40, 20);
    NSString * unitStr = @"公斤";
    UILabel * unitLabel = [self createLabelWithCenter:unitPoint
                                           withBounds:unitRect
                                             withText:unitStr
                                    withtextAlignment:NSTextAlignmentCenter withTextFont:20];
    [self addSubview:unitLabel];
    
    //当前
    CGPoint nowPoint = CGPointMake(half - 20, kSpaceHeight + 25);
    CGRect nowRect = CGRectMake(half - 40, kSpaceHeight + 20, 30, 10);
    NSString * nowStr = @"当前";
    UILabel * nowLabel = [self createLabelWithCenter:nowPoint
                                          withBounds:nowRect
                                            withText:nowStr
                                   withtextAlignment:NSTextAlignmentCenter withTextFont:10];
    [self addSubview:nowLabel];
    
}

/**
 *  ic_progress_arrowdown@2x.png  下降
    ic_progress_arrowup@2x.png    上升
 */
- (void)buildRightLable
{
    float widthEdge = self.frame.size.width - kSpaceEdge ;
    
    //创建更改后的数据Label
    CGPoint dataPoint = CGPointMake(widthEdge - 60, kSpaceHeight + 10);
    CGRect dataRect = CGRectMake(widthEdge - 80, kSpaceHeight, 40, 20);
    CoordinateModel * startItem = [self.dataSource objectAtIndex:0];
    CoordinateModel * lastItem = [self.dataSource lastObject];
    
    float startValue = [startItem.coordinateYValue floatValue];
    float lastValue = [lastItem.coordinateYValue floatValue];
    
    //判断体重是上升还是下降 增加上升或下降的对应的图片
    if (startValue > lastValue) {
        _changeValue = startValue - lastValue;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(widthEdge - 90, kSpaceHeight, 10, 20)];
        imageView.image = [UIImage imageNamed:@"ic_progress_arrowdown@2x.png"];
        [self addSubview:imageView];
        
    }else{
        _changeValue = lastValue - startValue;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(widthEdge - 90, kSpaceHeight, 10, 20)];
        imageView.image = [UIImage imageNamed:@"ic_progress_arrowup@2x.png"];
        [self addSubview:imageView];
    }
    
    NSString * changeStr = [NSString stringWithFormat:@"%.1f",_changeValue];
    UILabel *dataLabel = [self createLabelWithCenter:dataPoint
                                          withBounds:dataRect
                                            withText:changeStr
                                   withtextAlignment:NSTextAlignmentCenter withTextFont:18];
    [self addSubview:dataLabel];
    
    //创建单位Label
    CGPoint unitPoint = CGPointMake(widthEdge - 20, kSpaceHeight + 10);
    CGRect unitRect = CGRectMake(widthEdge - 40, kSpaceHeight, 40, 20);
    NSString * unitStr = @"公斤";
    UILabel * unitLabel = [self createLabelWithCenter:unitPoint
                                           withBounds:unitRect withText:unitStr withtextAlignment:NSTextAlignmentCenter
                                         withTextFont:20];
    [self addSubview:unitLabel];
    
    
    //创建底部的更改百分比Label
    CGPoint changePoint = CGPointMake(widthEdge - 40, kSpaceHeight + 25);
    CGRect changeRect = CGRectMake(widthEdge - 80, kSpaceHeight + 20, 80, 10);
    
    NSString * changeString = @"没有变化";
    
    //计算体重变化的百分比
    if (startValue > lastValue) {
        _percentValue = (startValue - lastValue) / startValue * 100;
        changeString = [NSString stringWithFormat:@"更改(-%.1f%%)",_percentValue];
    }else if (lastValue > startValue){
        _percentValue = ( lastValue - startValue) / startValue * 100;
        changeString =[NSString stringWithFormat:@"更改(+%.1f%%)",_percentValue];
    }else{
        _percentValue = 0.0;
        changeString =[NSString stringWithFormat:@"更改(+%.1f%%)",_percentValue];
    }
    
    UILabel * changeLabel = [self createLabelWithCenter:changePoint
                                             withBounds:changeRect
                                               withText:changeString withtextAlignment:  NSTextAlignmentCenter withTextFont:10];
    
    [self addSubview:changeLabel];
}



/**
 *  UILabel的排版方式
 *
 *  @param centerPoint   label的中心位置
 *  @param bounds        label的位置
 *  @param lableText     label的内容
 *  @param textAlignment label的内容排版方式
 *  @param font          字体大小
 *
 *  @return
 */
- (UILabel *) createLabelWithCenter:(CGPoint)centerPoint
                         withBounds:(CGRect)bounds
                           withText:(NSString *)labelText
                  withtextAlignment:(NSTextAlignment)textAlignment
                       withTextFont:(NSInteger)font;
{
    UILabel * label = [[UILabel alloc] init];
    
    label.center = centerPoint;
    label.bounds = bounds;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = textAlignment;
    label.text = labelText;
    
    return label;
}


@end

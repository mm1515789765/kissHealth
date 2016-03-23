//
//  RuleView.m
//  KissHealth
//
//  Created by Lix on 16/2/20.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "RuleView.h"
#import "TXHRrettyRuler.h"
#import "CoordinateModel.h"
#import "BottomView.h"
#import "ChartView.h"

#define kButtonHeight 40

@interface RuleView()<TXHRrettyRulerDelegate>
{
    UILabel * _valueLable;
    NSString * yValue;
}
//数据源
@property (strong, nonatomic)NSMutableArray * dataSource;

@end

@implementation RuleView

-(instancetype)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = [NSMutableArray arrayWithArray:dataSource];
        [self _createTitleView];
        [self _createRuleView];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}




- (void)_createTitleView
{
    //创建顶部蓝色标签栏的背景视图
    UIImageView * titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    titleImgView.image = [UIImage imageNamed:@"nav_bar_background@2x.png"];
    
    [self addSubview:titleImgView];
    
    
    //添加 @“今天的体重” 的Label
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 50, 10, 100, 20)];
    titleLabel.text = @"今天的体重";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    
    //添加左右两个按钮
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20,10,25,25);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"ic_nav_close@2x.png"] forState:UIControlStateNormal];
    cancelButton.tag = 301;
    [cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    UIButton * agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.frame = CGRectMake(self.frame.size.width - 45, 10, 25, 25);
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"ic_nav_checkmark@2x.png"] forState:UIControlStateNormal];
    agreeButton.tag = 302;
    [agreeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:agreeButton];
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 301) {
        
        [self removeFromSuperview];
        
    }else{
        if ([self.delegate respondsToSelector:@selector(passValue:)]) {
            [self.delegate passValue:yValue];
        }

        [self removeFromSuperview];
                
    }
}


- (void) _createRuleView
{
    // 1.创建一个显示的标签
    _valueLable = [[UILabel alloc] init];
    _valueLable.font = [UIFont systemFontOfSize:20.f];
    _valueLable.text = @"今天的体重 70 公斤";
    _valueLable.textColor = [UIColor blackColor];
    _valueLable.frame = CGRectMake(self.frame.size.width / 2 - 100, 60, 200, 40);
    _valueLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_valueLable];
    
    TXHRrettyRuler *ruler = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(20, 120, self.frame.size.width - 20 * 2, 140)];
    ruler.rulerDeletate = self;
    [ruler showRulerScrollViewWithCount:2000 average:[NSNumber numberWithFloat:0.1] currentValue:70.0f smallMode:YES];
    [self addSubview:ruler];
}

- (void)txhRrettyRuler:(TXHRulerScrollView *)rulerScrollView {
    _valueLable.text = [NSString stringWithFormat:@"今天的体重: %.1f",rulerScrollView.rulerValue];
    
    yValue = [NSString stringWithFormat:@"%.1f",rulerScrollView.rulerValue];
}

//获取系统时间
- (NSString *)requestDateData
{
    // 获取系统时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString * dateData = [dateFormatter stringFromDate:currentDate];
    
    return dateData;
}


@end

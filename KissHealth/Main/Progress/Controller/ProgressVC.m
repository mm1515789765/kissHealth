//
//  ProgressVC.m
//  KissHealth
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "ProgressVC.h"
#import "RecordView.h"
#import "TimeButtonView.h"
#import "ChartView.h"
#import "BottomView.h"
#import "CoordinateModel.h"

#define kButtonHeight 40
@interface ProgressVC ()
{
    RecordView  * _recordView;
    TimeButtonView * _timeButtonView;
    RuleView * _ruleView;
    BottomView * bottomView;
    ChartView * chartView;
}
//构建数据源
@property (strong, nonatomic)NSMutableArray * dataSource;

@end

@implementation ProgressVC

- (void)viewDidLoad {
    [super viewDidLoad];

   //构建假设的数据源
    [self buildDataSource];
    
    [self _createButton];
    
    //创建上方两个button点击后的pickview
    _recordView = [[RecordView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
//    NSLog(@"pickview");
    _timeButtonView = [[TimeButtonView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
//    NSLog(@"_timeButtonView");
    
    //创建上方的两个button
    [self.view addSubview:_recordView];
    [self.view addSubview:_timeButtonView];
    
    //创建图表视图
    [self _createChartView];
    
    //创建底部的分享视图
    [self _createBottomView];
    
    //添加导航栏右上角按钮
    [self _createAddDataButton];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

/**
 *  构建数据源
 */
- (void)buildDataSource
{
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    
    CoordinateModel * item = [[CoordinateModel alloc] initWithXValue:@"02/01" withYValue:@"70"];
    [self.dataSource addObject:item];
    
    CoordinateModel * item1 = [[CoordinateModel alloc] initWithXValue:@"02/02" withYValue:@"75"];
    [self.dataSource addObject:item1];
    
    CoordinateModel * item2 = [[CoordinateModel alloc] initWithXValue:@"02/03" withYValue:@"80"];
    [self.dataSource addObject:item2];
    
    CoordinateModel * item3 = [[CoordinateModel alloc] initWithXValue:@"02/04" withYValue:@"70"];
    [self.dataSource addObject:item3];
    
    CoordinateModel * item4 = [[CoordinateModel alloc] initWithXValue:@"02/05" withYValue:@"75"];
    [self.dataSource addObject:item4];
    
    CoordinateModel * item5 = [[CoordinateModel alloc] initWithXValue:@"02/06" withYValue:@"80"];
    [self.dataSource addObject:item5];
    
        CoordinateModel * item6 = [[CoordinateModel alloc] initWithXValue:@"02/07" withYValue:@"65"];
        [self.dataSource addObject:item6];
    
    CoordinateModel * item7 = [[CoordinateModel alloc] initWithXValue:@"02/14" withYValue:@"20"];
    [self.dataSource addObject:item7];
    
    //    CoordinateModel * item8 = [[CoordinateModel alloc] initWithXValue:@"2/14" withYValue:@"70"];
    //    [self.dataSource addObject:item8];
    
}


//创建顶部button
- (void)_createButton
{
    //左边选择记录的button
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.frame = CGRectMake(0, 64, kScreenWidth / 2, kButtonHeight);
    
    [_recordButton setTitle:@"体重" forState:UIControlStateNormal];
    [_recordButton setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [_recordButton setImage:[UIImage imageNamed:@"ic_menu_progress@2x.png"] forState:UIControlStateNormal];
    
    //设置button 中 image和title间距
    _recordButton.titleEdgeInsets = UIEdgeInsetsMake(0, _recordButton.frame.size.width / 2 - _recordButton.titleLabel.frame.size.width - 20, 0, 0);
    _recordButton.imageEdgeInsets = UIEdgeInsetsMake(0, -_recordButton.frame.size.width /2 - _recordButton.imageView.frame.size.width + 20, 0, 0);
    
    [_recordButton addTarget:self action:@selector(recordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordButton];
    
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.frame = CGRectMake(kScreenWidth / 2, 64, kScreenWidth / 2, kButtonHeight);
    [_timeButton setTitle:@"1 周" forState:UIControlStateNormal];
    [_timeButton setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [_timeButton setImage:[UIImage imageNamed:@"ic_progress_cal@2x.png"] forState:UIControlStateNormal];
    _timeButton.titleEdgeInsets = UIEdgeInsetsMake(0, _timeButton.frame.size.width / 2 - _timeButton.titleLabel.frame.size.width - 20, 0, 0);
    _timeButton.imageEdgeInsets = UIEdgeInsetsMake(0, - _timeButton.frame.size.width / 2 - _timeButton.imageView.frame.size.width + 20, 0, 0);
    [_timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recordButtonAction:(UIButton *)sender
{
    [self ViewAnimation:_recordView willHidden:NO];
    [self changeTitle];
    
}

- (void)timeButtonAction:(UIButton *)sender
{
    [self TimeButtonViewAnimation:_timeButtonView willHidden:NO];
    
    [self changeTitle];
}

//在pickerview选择的过程中 改变顶部两个按钮的title
- (void)changeTitle
{
    
    __weak typeof(self) weakSelf = self;
    _recordView.titleBlock = ^(NSString * text)
    {
        
//        NSLog(@"%@",text);
        [weakSelf.recordButton setTitle:text forState:UIControlStateNormal];
    };
    
    _timeButtonView.titleBlock = ^(NSString * text)
    {
//        NSLog(@"%@",text);
        [weakSelf.timeButton setTitle:text forState:UIControlStateNormal];
    };
    
}
//点击顶部两个按钮 弹出的PickView动画
- (void)ViewAnimation:(UIView *)view willHidden:(BOOL)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            _recordView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        }else{
            [_recordView setHidden:hidden];
            [_recordView removeFromSuperview];
            _recordView = [[RecordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            [self.view addSubview:_recordView];
        }
    } completion:^(BOOL finished) {
        [_recordView setHidden:hidden];
    }];
}

- (void)TimeButtonViewAnimation:(UIView *)view willHidden:(BOOL)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            _timeButtonView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        }else{
            [_timeButtonView setHidden:hidden];
            [_timeButtonView removeFromSuperview];
            _timeButtonView = [[TimeButtonView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            [self.view addSubview:_timeButtonView];
        }
    } completion:^(BOOL finished) {
        [_timeButtonView setHidden:hidden];
    }];
}



//创建中间的图表视图
- (void)_createChartView
{
//    ChartView * chartView = [[ChartView alloc]initWithFrame:CGRectMake(5, kButtonHeight + 64, kScreenWidth - 10, 260)];

    chartView = [[ChartView alloc] initWithFrame:CGRectMake(5, kButtonHeight + 64, kScreenWidth - 10, 260) withDataSource:self.dataSource];
    
    chartView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:chartView];
}
//创建底部的表视图

- (void)_createBottomView
{
    
    bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, kButtonHeight + 64 + 260 , kScreenWidth, kScreenHeight - kButtonHeight - 64 - 260 ) withDataSource:self.dataSource];
    
    [self.view addSubview:bottomView];
}

//添加右上角添加数据按钮  ic_nav_add@2x.png

- (void)_createAddDataButton
{
    UIBarButtonItem * addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_add_active"] style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    
    self.navigationItem.rightBarButtonItem = addItem ;
}

- (void)addAction
{
    _ruleView = [[RuleView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 300, kScreenWidth, 300)withDataSource:self.dataSource];
    //设置代理对象
    _ruleView.delegate = self;
    
    [self.view addSubview:_ruleView];
    
}

- (void)passValue:(NSString *)value
{
    
    // 获取系统时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd"];
    
    NSString * dateData = [dateFormatter stringFromDate:currentDate];
    
//    NSLog(@"%@",dateData);
    
    
    CoordinateModel * item = [[CoordinateModel alloc] initWithXValue:dateData withYValue:value];
    [self.dataSource addObject:item];
    
//    NSLog(@"%@",self.dataSource);
    
//    CoordinateModel * item1 = [[CoordinateModel alloc] initWithXValue:@" " withYValue:@" "];
//    [self.dataSource addObject:item1];
    
    [bottomView removeFromSuperview];
    
    [chartView removeFromSuperview];
    
    [self _createBottomView];
    [self _createChartView];
    
    
    
}
@end

//
//  KHTabBarVC.m
//  KissHealth
//
//  Created by Macx on 16/1/27.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHTabBarVC.h"
#import "BaseNavigationController.h"
#import "KHPlusControl.h"
#import "DiaryStateVC.h"
#import "DiaryPlusView.h"


#define kButtonTitleFont 13
#define kSpacing 5   //image 和 title的间距
#define kTopSpacing 3 //image 和tabBar的间距


@interface KHTabBarVC ()
{
    BOOL _selectedFlag;
    UIControl *_maskView;
    UIImageView *_plusImgView;
    
    KHPlusControl *_stateImgView;
    KHPlusControl *_waterImgView;
    KHPlusControl *_foodImgView;
    KHPlusControl *_exciseImgView;
    KHPlusControl *_weightImgView;
    
}

@end

@implementation KHTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"nav_tabbar_background"]];
    [self _creatViewControllers];
}

- (void)_creatViewControllers
{
    NSArray *storyboardNames = @[@"Home",@"Diary",@"Progress",@"More"];
    NSMutableArray *controllers = [NSMutableArray array];
    for (int i = 0; i < storyboardNames.count; i++)
    {
        BaseNavigationController *navi = [[UIStoryboard storyboardWithName:storyboardNames[i] bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        
        if (i == 1) {
            self.diaryNavi = navi;
        }
        
        [controllers addObject:navi];
    }
    //留给何桂灿烂的第三个VC自己修改,这里是为了防止崩溃，按顺序添加的
    UIViewController *keepVC = [[UIViewController alloc] init];
    [controllers insertObject:keepVC atIndex:2];
    
    self.viewControllers = controllers;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self _removeSystemTabBarButtons];
    [self _creatMyButtons];
    
}

- (void)_removeSystemTabBarButtons
{
    Class cls = NSClassFromString(@"UITabBarButton");
    for (UIView *view in self.tabBar.subviews)
    {
        if ([view isKindOfClass:cls])
        {
            [view removeFromSuperview];
        }
    }
}


- (void)_creatMyButtons
{
    NSArray *imgNames = @[
                          @"ic_tabbar_home_normal.png",
                          @"ic_tabbar_diary_normal.png",
                          @"ic_tabbar_progress_normal.png",
                          @"ic_tabbar_more_normal.png",
                          ];
    NSArray *activeImgNames = @[
                                @"ic_tabbar_home_active.png",
                                @"ic_tabbar_diary_active.png",
                                @"ic_tabbar_progress_active.png",
                                @"ic_tabbar_more_active.png",
                                ];
    NSArray *titleNames = @[@"首页",
                            @"日记",
                            @"进度",
                            @"更多"
                            ];
    
    
    CGFloat buttonWidth = kScreenWidth / 5;
    CGFloat buttonHeight = self.tabBar.frame.size.height;
    
    for (int i = 0; i < 4; i ++)
    {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:activeImgNames[i]] forState:UIControlStateSelected];
        [self configButtonEdgeInsets:button Image:[UIImage imageNamed:imgNames[i]] Title:titleNames[i]];
        //启动程序保证首页button图片正确
        if (i == 0)
        {
            button.selected = YES;
        }
        if (i < 2)
        {
            button.frame=CGRectMake(buttonWidth * i, 0, buttonWidth, buttonHeight);
            button.tag = 1000 + i;
        }
        else
        {
           button.frame=CGRectMake(buttonWidth*(i+1),0,buttonWidth,buttonHeight);
            button.tag = 1000 + i + 1;
        }
        [button addTarget:self action:@selector(selectVC:) forControlEvents:UIControlEventTouchUpInside];
        
       
        [self.tabBar addSubview:button];
    }
    
    int x = (kScreenWidth - 55) / 2;
    
    UIControl *chromePlusButton = [[UIControl alloc] initWithFrame:CGRectMake(x, 0, 55, 49)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -6, 55, 55)];
    imageView.image = [UIImage imageNamed:@"ic_tabbar_chrome_plus_normal"];
    
    [chromePlusButton addTarget:self action:@selector(chromeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectedFlag = YES;
    
    [chromePlusButton addSubview:imageView];
    [self.tabBar addSubview:chromePlusButton];
    
}

- (void)selectVC:(UIButton *)sender
{
    for (UIView *view in self.tabBar.subviews)
    {
        if ([view isMemberOfClass:[UIButton class]])
        {
            [(UIButton *)view setSelected:NO];
        }
    }
    sender.selected = YES;
    self.selectedIndex = sender.tag - 1000;
}

//对button进行设置，图片在上，文字在下
- (UIButton *)configButtonEdgeInsets:(UIButton *)button Image:(UIImage *)image Title:(NSString *)title
{
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFont];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    
    CGFloat labelWidth = [title
                          sizeWithAttributes:@{
                                               NSFontAttributeName:[UIFont systemFontOfSize:kButtonTitleFont],
                                               }].width;
    CGFloat labelHeight = [title
                           sizeWithAttributes:@{
                                                NSFontAttributeName:[UIFont systemFontOfSize:kButtonTitleFont],
                                                }].height;
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    //image中心移动的x距离
    CGFloat imageOfsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;
    //image中心移动的y距离
    CGFloat imageOfsetY = imageHeight / 2 + kSpacing / 2 - kTopSpacing;
    //label中心移动的x距离
    CGFloat labelOfsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;
    //label中心移动的y距离
    CGFloat labelOfsetY = labelHeight / 2 + kSpacing / 2 + kTopSpacing;
    
    button.imageEdgeInsets = UIEdgeInsetsMake(-imageOfsetY, imageOfsetX, imageOfsetY, -imageOfsetX);
    button.titleEdgeInsets = UIEdgeInsetsMake(labelOfsetY, -labelOfsetX, -labelOfsetY, labelOfsetX);

    
    return button;
}

- (void)chromeButtonAction:(UIControl *)button
{
    
    if (_selectedFlag == YES) {
        if (_maskView == nil) {
            _maskView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        }
        
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        [_maskView addTarget:self action:@selector(chromeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _maskView.userInteractionEnabled = NO;
        button.userInteractionEnabled = NO;
        
        int x = (kScreenWidth - 50) / 2;
        int y = kScreenHeight - 55;
        
        if (_plusImgView == nil) {
            _plusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 50, 50)];
            _plusImgView.image = [UIImage imageNamed:@"ic_tabbar_plus_normal"];
            
            CGRect frame = button.frame;
            frame.origin.x = frame.origin.x + 5;
            frame.origin.y = kScreenHeight - 55;
            frame.size.width = 50;
            frame.size.height = 60;
            
            
            _stateImgView = [[KHPlusControl alloc] initWithFrame:frame image:@"ic_tabbar_more_update_normal" title:@"状态" color:[UIColor colorWithRed:114 / 255.0 green:1.000 blue:61 / 255.0 alpha:1.000]];
            
            _waterImgView = [[KHPlusControl alloc] initWithFrame:frame image:@"ic_tabbar_more_water_normal" title:@"水" color:[UIColor colorWithRed:100 / 255.0 green:195 / 255.0 blue:1 alpha:1.000]];
            
            _foodImgView = [[KHPlusControl alloc] initWithFrame:frame image:@"ic_tabbar_more_food_normal" title:@"食物" color:[UIColor colorWithRed:226 / 255.0 green:98 / 255.0 blue:6 / 255.0 alpha:1.000]];
            
            _exciseImgView = [[KHPlusControl alloc] initWithFrame:frame image:@"ic_tabbar_more_exercise_normal" title:@"运动" color:[UIColor colorWithRed:1.000 green:232 / 255.0 blue:61 / 255.0 alpha:1.000]];
            
            _weightImgView = [[KHPlusControl alloc] initWithFrame:frame image:@"ic_tabbar_more_weight_normal" title:@"体重" color:[UIColor colorWithRed:161 / 255.0 green:114 / 255.0 blue:1.000 alpha:1.000]];
            
            _stateImgView.tag = 2010;
            _waterImgView.tag = 2011;
            _foodImgView.tag = 2012;
            _exciseImgView.tag = 2013;
            _weightImgView.tag = 2014;
            
            
            [_stateImgView addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_waterImgView addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_foodImgView addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_exciseImgView addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_weightImgView addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_maskView addSubview:_stateImgView];
            [_maskView addSubview:_waterImgView];
            [_maskView addSubview:_foodImgView];
            [_maskView addSubview:_exciseImgView];
            [_maskView addSubview:_weightImgView];
            
            [_maskView addSubview:_plusImgView];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _plusImgView.transform = CGAffineTransformMakeRotation(-M_PI_4);
            
            _stateImgView.transform = CGAffineTransformMakeTranslation(-120, -70);
            _waterImgView.transform = CGAffineTransformMakeTranslation(-70, -120);
            _foodImgView.transform = CGAffineTransformMakeTranslation(0, -140);
            _exciseImgView.transform = CGAffineTransformMakeTranslation(70, -120);
            _weightImgView.transform = CGAffineTransformMakeTranslation(120, -70);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 animations:^{
                _stateImgView.transform = CGAffineTransformMakeTranslation(-120 * 0.97, -70 * 0.97);
                _waterImgView.transform = CGAffineTransformMakeTranslation(-70 * 0.97, -120 * 0.97);
                _foodImgView.transform = CGAffineTransformMakeTranslation(0 * 0.97, -140 * 0.97);
                _exciseImgView.transform = CGAffineTransformMakeTranslation(70 * 0.97, -120 * 0.97);
                _weightImgView.transform = CGAffineTransformMakeTranslation(120 * 0.97, -70 * 0.97);
            }];

            _maskView.userInteractionEnabled = YES;
            button.userInteractionEnabled = YES;
            
            _selectedFlag = !_selectedFlag;
        }];
        
        [self.view addSubview:_maskView];
    }
    else{
        _maskView.userInteractionEnabled = NO;
        button.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _plusImgView.transform = CGAffineTransformIdentity;
            
            _stateImgView.transform = CGAffineTransformIdentity;
            _waterImgView.transform = CGAffineTransformIdentity;
            _foodImgView.transform = CGAffineTransformIdentity;
            _exciseImgView.transform = CGAffineTransformIdentity;
            _weightImgView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            _maskView.hidden = YES;
            
            _plusImgView = nil;
            _stateImgView = nil;
            _waterImgView = nil;
            _foodImgView = nil;
            _exciseImgView = nil;
            _weightImgView = nil;
            
            _maskView = nil;
            
            _maskView.userInteractionEnabled = YES;
            button.userInteractionEnabled = YES;
            
            _selectedFlag = !_selectedFlag;
        }];
    }
}

- (void)plusButtonAction:(KHPlusControl *)button
{
    
    
    if (button.tag == 2010) {
        
        DiaryStateVC *diaryStateVC = [[DiaryStateVC alloc] init];
        BaseNavigationController *diaryStateNavi = [[BaseNavigationController alloc] initWithRootViewController:diaryStateVC];
        
        [self presentViewController:diaryStateNavi animated:YES completion:NULL];
        
        [self chromeButtonAction:nil];
    }
    
    if (button.tag >= 2011 && button.tag <= 2013) {
        
        DiaryPlusView *plusPickerView = [[DiaryPlusView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titleName:button.title];
        
        [self.view addSubview:plusPickerView];
        
        [self chromeButtonAction:nil];
    }
    
    if (button.tag == 2014) {
        
        [self chromeButtonAction:nil];
    }
}

@end

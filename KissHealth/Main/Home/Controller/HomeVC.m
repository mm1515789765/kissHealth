//
//  HomeVC.m
//  KissHealth
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "HomeVC.h"
#import "KHNews.h"
#import "NewListModel.h"
#import "KHNewsTabelView.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"
#import "DrugStoreVC.h"
#import "KHControl.h"
#import "BarCodeVC.h"
#import "PictureVC.h"

#define kNewsCount @"11"
#define kUser @"wl"

@interface HomeVC ()
{
    NSMutableArray *modelArr;
    DrugStoreVC *dsVC;
    UIView *toolView;
    UIView *cancelView;
    UIActivityIndicatorView *grayActivity;
}

@property (nonatomic, strong)KHNewsTabelView *tableView;
@property (nonatomic, strong)KHNews *news;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏的半透明属性
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
   
    
    [self _creatTableView];

    [self _creatDrugStoreButton];
    [self _creatMoreButton];
   
    self.news = [KHNews sharedKHNews];
    
    [self.news requestWithURL:@"info/list"
                  params:@{
                           @"rows":kNewsCount,
                
                           }.mutableCopy
             finishBlock:^(NSDictionary *jsonDic, NSHTTPURLResponse *response, NSError *error) {
                 
                 [self _loadData:jsonDic];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     //                     [self.activity stopAnimating];
                     [grayActivity stopAnimating];
                 });
             } failBlock:^(NSHTTPURLResponse *response, NSError *error) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self showRemind:@"数据加载失败"];
//                     [self.activity stopAnimating];
                     [grayActivity stopAnimating];
                 });
             }];
    
    grayActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    grayActivity.center = self.view.center;
    [self.view addSubview:grayActivity];
    [grayActivity startAnimating];
    
}

- (void)_creatMoreButton
{
    UIBarButtonItem *bcButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_add_active"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToolAction)];
    self.navigationItem.leftBarButtonItem = bcButton;
    
}

- (void)addToolControls
{
    KHControl *barCodeControl = [[KHControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 1.0/3, kScreenHeight * 1.0/10) image:@"btn_recipes_barcode_pressed" title:@"扫一扫"];
    [barCodeControl addTarget:self action:@selector(barCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:barCodeControl];
    
    KHControl *pictureControl = [[KHControl alloc] initWithFrame:CGRectMake(0, kScreenHeight * 1.0/10, kScreenWidth * 1.0/3, kScreenHeight * 1.0/10) image:@"btn_cameraroll_normal.png" title:@"图片"];
    
    [pictureControl addTarget:self action:@selector(pictureAction) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:pictureControl];
    
}

#pragma mark - bar code


- (void)rightToolAction
{
    cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    cancelView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
    [[UIApplication sharedApplication].keyWindow addSubview:cancelView];
    
    [cancelView addGestureRecognizer:tap];
    //tool View
    toolView = [[UIView alloc] initWithFrame:CGRectMake(10, 64, kScreenWidth * 1.0/3, kScreenHeight * 1.0/5)];
    toolView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:toolView];
    [self addToolControls];
    

}


- (void)barCodeAction
{
    BarCodeVC *barCodeVC = [[BarCodeVC alloc] init];
    
    [self.navigationController pushViewController:barCodeVC animated:YES];
    
    [self cancelAction];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)cancelAction
{
    [toolView removeFromSuperview];
    [cancelView removeFromSuperview];
}



#pragma mark - require local Images

- (void)pictureAction
{
    PictureVC *pictureVC = [[PictureVC alloc] init];
    pictureVC.imgNames = [self allImageNames];
    [self.navigationController pushViewController:pictureVC animated:YES];
    [self cancelAction];
    
}

- (NSString *)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    return cachesDir;
    
}

//获取文件下.jpg文件
- (NSArray *)allImageNames
{
    NSFileManager *fm = [NSFileManager defaultManager];

    NSArray *fileNames = [fm subpathsOfDirectoryAtPath:[self cachePath] error:nil];
    NSMutableArray *mutableArr = [NSMutableArray array];
    
    for (NSString *str in fileNames)
    {
        if ([str rangeOfString:@".jpg"].length == 0)
        {
            continue;
        }
        [mutableArr addObject:str];
        
    }
    return mutableArr;
}

#pragma mark - Drug Store
- (void)_creatDrugStoreButton
{
    
    UIBarButtonItem *dsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_restaurant_logging_white"] style:UIBarButtonItemStylePlain target:self action:@selector(drugStore)];
    self.navigationItem.rightBarButtonItem = dsButton;
}

- (void)drugStore
{
    dsVC = [[DrugStoreVC alloc] init];
    [self.navigationController pushViewController:dsVC animated:YES];
}


#pragma mark - config table View
- (void)_creatTableView
{
    modelArr = [NSMutableArray array];
    self.tableView = [[KHNewsTabelView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerData];
        
    }];
    [self.view addSubview:_tableView];
    
}

- (void)headerData
{
    
    NSInteger firstID = [[[modelArr firstObject] newsID] integerValue];
    NSString *useID = [NSString stringWithFormat:@"%ld",(long)firstID];
    
    [self.news requestWithURL:@"info/news"
                       params:@{
                                @"rows":kNewsCount,
                                @"id":useID
                                
                                }.mutableCopy
                  finishBlock:^(NSDictionary *jsonDic, NSHTTPURLResponse *response, NSError *error) {
                      
                      if (jsonDic == nil)
                      {
                          return ;
                      }
                      [self loadNewData:jsonDic];
                      
                  } failBlock:^(NSHTTPURLResponse *response, NSError *error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self showRemind:@"数据加载失败"];
                      });
                  }];
}

//下拉刷新
- (void)loadNewData:(NSDictionary *)dic
{
    NSArray *newNewsArr = [dic objectForKey:@"tngou"];
    if ([newNewsArr isKindOfClass:[NSNull class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView.mj_header endRefreshing];
            [self showRemind:@"暂时没有更新~请稍后再试"];
            
        });
        return;
    }
    if ( newNewsArr.count == 0 )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView.mj_header endRefreshing];
            [self showRemind:@"暂时没有更新~请稍后再试"];
            
        });
        return;
    }
    
    NSMutableArray *newModelArr = [NSMutableArray array];
    for (NSDictionary *dic in [newNewsArr reverseObjectEnumerator])
    {
        [newModelArr addObject:[self creatModel:dic]];
    }

    [newModelArr addObjectsFromArray:modelArr];
    modelArr = newModelArr;
    
    //在主线程中刷新ui
    dispatch_async(dispatch_get_main_queue(), ^{
        _tableView.models = modelArr;
        [_tableView.mj_header endRefreshing];
        
    });
    
}

- (void)footerData
{
    NSInteger newsID = [[[modelArr lastObject] newsID] integerValue];
    NSString *useID = [NSString stringWithFormat:@"%ld",newsID - [kNewsCount integerValue]];
    [self.news requestWithURL:@"info/news"
                  params:@{
                           @"rows":kNewsCount,
                           @"id":useID
                           
                           }.mutableCopy
             finishBlock:^(NSDictionary *jsonDic, NSHTTPURLResponse *response, NSError *error) {
                 
                 if (jsonDic == nil)
                 {
                     return ;
                 }
                 [self loadOldData:jsonDic];
                 
             } failBlock:^(NSHTTPURLResponse *response, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showRemind:@"数据加载失败"];
                });
             }];
}

//上拉刷新
- (void)loadOldData:(NSDictionary *)jsonDic
{
    NSArray *OldNewsArr = [jsonDic objectForKey:@"tngou"];
    if (OldNewsArr.count == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [_tableView.mj_footer endRefreshing];
            
        });
        return;
    }
    NSMutableArray *oldModelArr = [NSMutableArray array];
    //倒序遍历
    for (NSDictionary *dic in [OldNewsArr reverseObjectEnumerator])
    {
        [oldModelArr addObject:[self creatModel:dic]];
    }
    //数据重复处理
    if([[modelArr lastObject] newsID] == [[oldModelArr firstObject] newsID])
    {
       [oldModelArr removeObjectAtIndex:0];
    }
    [modelArr addObjectsFromArray:oldModelArr];
    
    //在主线程中刷新ui
    dispatch_async(dispatch_get_main_queue(), ^{
        _tableView.models = modelArr;
        [_tableView.mj_footer endRefreshing];
        
    });
    
}


//加载数据
- (void)_loadData:(NSDictionary *)jsonDic
{
    if (jsonDic == nil)
    {
        return;
    }
    NSArray *newListArr = [jsonDic objectForKey:@"tngou"];
    for (NSDictionary *dic in newListArr)
    {
        
        [modelArr addObject:[self creatModel:dic]];
    }
    
    //在主线程中刷新ui
    dispatch_async(dispatch_get_main_queue(), ^{
        _tableView.models = modelArr;
        [grayActivity stopAnimating];

    });
    
    
}

- (NewListModel *)creatModel:(NSDictionary *)dic
{
    NewListModel *model = [[NewListModel alloc] init];
    model.newsDescription = [dic objectForKey:@"description"];
    model.newsID = [dic objectForKey:@"id"];
    model.imgURL = [dic objectForKey:@"img"];
    model.title = [dic objectForKey:@"title"];
    
    return model;
}

- (void)showRemind:(NSString *)remindStr
{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    UILabel *newCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    newCountLabel.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    newCountLabel.textColor = [UIColor whiteColor];
    newCountLabel.textAlignment = NSTextAlignmentCenter;
    newCountLabel.text = remindStr;
    [self.view addSubview:newCountLabel];
    
    [UIView animateKeyframesWithDuration:1 delay:1.5 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        newCountLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [newCountLabel removeFromSuperview];
    }];
}

//- (void)_creatActivityView
//{
//    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
////    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activity];
////    self.navigationItem.rightBarButtonItem = barButtonItem;
//    _activity.center = self.view.center;
//    [_activity startAnimating];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tableView.newsDetailVC = nil;
    dsVC = nil;
    
}

//- (BOOL)judgeIsRead:(NSString *)newsID
//{
//    NSMutableDictionary *userDic = [self readPlist];
//    
//   
//    return YES;
//}
//
////建立沙盒存储
//- (NSMutableDictionary *)readPlist
//{
//     NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/read.plist"];
//    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//    if (userDic)
//    {
//        return userDic;
//    }
//    userDic = [NSMutableDictionary dictionary];
//    
//    [userDic setObject:kUser forKey:@"userInfo"];
//   
//    [userDic writeToFile:path atomically:YES];
//    
//    
//    return userDic;
//}



@end

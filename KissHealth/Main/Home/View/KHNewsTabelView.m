//
//  KHNewsTabelView.m
//  KissHealth
//
//  Created by Macx on 16/1/31.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHNewsTabelView.h"
#import "NewsListCell.h"
#import "NewListModel.h"
#import "KHNews.h"
#import "NewDetailModel.h"
#import "NewsDetailVC.h"


@interface KHNewsTabelView()
{
    NSCache *imageCache;
    NSCache *downImgCache;
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) KHNews *khNews;

@end

@implementation KHNewsTabelView

static NSString *const reuseIdentifier = @"reuseCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        [self registerNib:[UINib nibWithNibName:@"NewsListCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorInset = UIEdgeInsetsMake(0, 1.0/20*kScreenWidth, 0, 1.0/20*kScreenWidth);
        _models = [NSMutableArray array];
        //创建图片和下载任务的缓存池
        imageCache = [[NSCache alloc] init];
        downImgCache = [[NSCache alloc] init];
        imageCache.countLimit = 10;
        downImgCache.countLimit = 10;
    }
    return self;
}
//传入数据模型数组
- (void)setModels:(NSArray *)models
{
        _models = models;
        [self reloadData];
}
//懒加载
- (NSOperationQueue *)queue
{
    if (_queue == nil)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (KHNews *)khNews
{
    if (_khNews == nil)
    {
        _khNews = [KHNews sharedKHNews];
    }
    return _khNews;
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}
#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsListCell *newsCell = (NewsListCell *)cell;
    newsCell.model = _models[indexPath.row];
    [self creatPictures:newsCell];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewListModel *model = _models[indexPath.row];
    
    return model.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _newsDetailVC = [[NewsDetailVC alloc] init];
    [[self viewController].navigationController pushViewController:_newsDetailVC animated:YES];
    NSInteger newsID = [[self.models[indexPath.row] newsID] integerValue];
    NSString *useID = [NSString stringWithFormat:@"%ld",(long)newsID];
   
    [self.khNews requestWithURL:@"info/show"
                         params:@{
                                  @"id":useID
                                  }.mutableCopy
     
        finishBlock:^(NSDictionary *jsonDic, NSHTTPURLResponse *response, NSError *error) {
                
                        if (jsonDic == nil)
                        {
                            return ;
                        }
                      NewDetailModel *model =  [self creatModel:jsonDic];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          _newsDetailVC.model = model;
                      });
                        
                    }
                      failBlock:^(NSHTTPURLResponse *response, NSError *error) {
                        NSLog(@"加载数据失败");
                    }];
}



#pragma -mark pictures
- (void)creatPictures:(NewsListCell *)cell
{
    //从缓存池里面取图片
    NSString *urlStr = cell.model.imgURL;
    if ([imageCache objectForKey:urlStr])
    {
        
        cell.imgView.image = [imageCache objectForKey:urlStr];
        return;
        
    }
    //从沙盒里取图片
    UIImage *directoryImg = [UIImage imageWithContentsOfFile:[self cachePathWithUrl:urlStr]];
    if (directoryImg)
    {
        //设置图片缓存到内存中
        [imageCache setObject:directoryImg forKey:urlStr];
        cell.imgView.image = directoryImg;
        return;
    }
    
    //消除复用的影响
    cell.imgView.image = nil;
    //判断是否有下载任务
    if ([downImgCache objectForKey:urlStr] )
    {
        return;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //异步下载图片
   NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
       
       NSData *imgData = [NSData dataWithContentsOfURL:url];
       UIImage *image = [UIImage imageWithData:imgData];
       if (image)
       {
           [imgData writeToFile:[self cachePathWithUrl:urlStr] atomically:YES];
           [imageCache setObject:image forKey:cell.model.imgURL];
       }
       
        //更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    
            cell.imgView.image = [imageCache objectForKey:cell.model.imgURL];
            
        }];
        
    }];

    [self.queue addOperation:blockOperation];
    
}

//建立沙盒存储
- (NSString *)cachePathWithUrl:(NSString *)urlStr
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
//    cachePath = [cachePath stringByAppendingString:@"/a"];
    
    return [cachePath stringByAppendingPathComponent:[urlStr lastPathComponent]];
}


- (NewDetailModel *)creatModel:(NSDictionary *)dic
{
    NewDetailModel *model = [[NewDetailModel alloc] init];
    model.newsID = [dic objectForKey:@"id"];
    model.title = [dic objectForKey:@"title"];
    model.message = [dic objectForKey:@"message"];
    model.rcount = [[dic objectForKey:@"rcount"] integerValue];
    model.fcount = [[dic objectForKey:@"fcount"] integerValue];
    model.time = [dic objectForKey:@"time"] ;
    
    return model;
}

//通过响应者链找到viewController
- (UIViewController *)viewController
{
    UIResponder *responder = self.nextResponder;
    do {
        if([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
        
    }while (responder != nil);
    
    return nil;
}


@end

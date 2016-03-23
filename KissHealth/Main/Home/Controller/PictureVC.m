//
//  PictureVC.m
//  KissHealth
//
//  Created by Macx on 16/2/20.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "PictureVC.h"
#import "KHFlowLayout.h"

@interface PictureVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray  *heightArr;

@end

@implementation PictureVC

static NSString *const reuseIdentifier = @"reuseCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _creatCollectionView];
}


- (void)_creatCollectionView
{
    KHFlowLayout *layout = [[KHFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.collectionView];
    
}


#pragma mark - collectionView data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:
                                reuseIdentifier forIndexPath:indexPath];
   
    return  cell;

}

#pragma mark - collection delegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor redColor]];

    if (self.imgNames.count >= indexPath.row && self.imgNames.count > 0)
    {
        NSString *imgName = self.imgNames[indexPath.row];
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@",[self cachePath],imgName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgPath]];
        
        [cell setBackgroundView:imageView];
    }
}


#pragma mark - other

- (NSMutableArray *)heightArr
{
    if (_heightArr == nil)
    {
        _heightArr = [NSMutableArray array];
    }
    return _heightArr;
}

- (NSString *)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
   
    
    return cachesDir;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

@end

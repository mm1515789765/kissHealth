//
//  WLCollectionView.m
//  WLEmotionViewDemo
//
//  Created by Macx on 16/1/15.
//  Copyright © 2016年 wl. All rights reserved.
//

#import "WLEmotionView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kReuseID @"reuseCell"

@interface WLEmotionView()<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
{
    NSInteger _row;
    NSInteger _column;
    UIImage *_deleteImage;
    
    DeleteBlock _deleteBl;
    ClickBlock _clickBl;
}

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@end

@implementation WLEmotionView

- (void)clickEmotion:(ClickBlock)clickBl
{
    _clickBl = clickBl;
}
    

- (void)deleteImage:(UIImage *)image deleteAction:(DeleteBlock)deleteBl
{
    _deleteImage = image;
    _deleteBl = deleteBl;
    [self reloadData];
    
}

- (void)configRow:(NSInteger)row configColumn:(NSInteger)column
{
    if (row <= 0 | column <= 0)
    {
        return;
    }
    _row = row;
    _column = column;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame collectionViewLayout:self.layout];
    if (self) {
        [self baseConfig];
    }
    return self;
}

- (void)baseConfig
{
    self.delegate = self;
    self.dataSource = self;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.backgroundColor = [UIColor lightGrayColor];
    // 设置每一列间隔
    self.layout.minimumInteritemSpacing = 0;
    // 设置每一行间隔
    self.layout.minimumLineSpacing = 0;
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kReuseID];
    _emotionsArr = [NSArray array];
    _returnArr = [NSArray array];
    _row = 4;
    _column = 7;
    
}


//传入数据时刷新collectionView
- (void)setEmotionsArr:(NSArray *)emotionsArr
{
    _emotionsArr = emotionsArr;
    [self reloadData];
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil)
    {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
       
    }
    return _layout;
}


#pragma mark - collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger product = _row * _column;
    NSInteger page = self.emotionsArr.count / product + 1;
    if (!_deleteImage)
    {
        
        return page * product;
    }
    page = (page + self.emotionsArr.count) / product + 1;
    
    return page * product;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseID forIndexPath:indexPath];
    
    UIImage *image = [self imageForIndexPath:indexPath];
    
    UIImageView *faceImageView = [cell.contentView viewWithTag:2000];
    if (!faceImageView)
    {
        faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        faceImageView.tag = 2000;
        [cell.contentView addSubview:faceImageView];
        faceImageView.center = cell.contentView.center;
    }
    
    faceImageView.image = image;

    
    return cell;
}

- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath
{
    //没有删除按钮时
    if (!_deleteImage)
    {
        //防止数组越界
        if (indexPath.row >= self.emotionsArr.count)
        {
            return nil;
        }
      return self.emotionsArr[indexPath.row];
    }
    //有删除按钮
    NSInteger product = _row*_column;
    
    if (indexPath.row%product == product -1)
    {
        return _deleteImage;
    }
    else
    {
        NSInteger deleteNum = indexPath.row/product;
        if (indexPath.row - deleteNum >= self.emotionsArr.count)
        {
            return nil;
        }
        return self.emotionsArr[indexPath.row - deleteNum];
    }
    
    
}

#pragma mark - collectionView delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width/_column, self.frame.size.height /_row);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
   
    if (!_deleteImage)
    {
        [self haveNotDeleteImage:indexPath];
        
    }
    else
    {
        [self haveDeleteImage:indexPath];
    }
}

- (void)haveNotDeleteImage:(NSIndexPath *)indexPath
{
    if ((indexPath.row >= _returnArr.count) | !_clickBl)
    {
        return;
    }
    _clickBl(_returnArr[indexPath.row]);
}

- (void)haveDeleteImage:(NSIndexPath *)indexPath
{
    NSInteger product = _row * _column;
    NSInteger deleteNum = indexPath.row/product;
    if (!_clickBl)
    {
        return;
    }
    if (indexPath.row%product == product -1 && _deleteBl)
    {
        _deleteBl();
    }
    else if (indexPath.row - deleteNum < self.emotionsArr.count)
    {
        _clickBl(_returnArr[indexPath.row - deleteNum]);
    }
    
}

@end

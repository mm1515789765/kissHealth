//
//  KHFlowLayout.m
//  KissHealth
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHFlowLayout.h"

//每一行之间的间距
static const CGFloat kRowSpace = 10;
//每一列之间的间距
static const CGFloat kColumnSpace = 10;
//每一列之间的间距 top, left, bottom, right
static const UIEdgeInsets kInsets = {10, 10, 10, 10};
//默认的列数
static const int kColumnCounts = 3;

@interface KHFlowLayout()

//每一列的最大Y值
@property (nonatomic, strong) NSMutableArray *columnMaxYs;
//存放所有cell的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation KHFlowLayout

#pragma mark - 懒加载
- (NSMutableArray *)columnMaxYs
{
    if (!_columnMaxYs) {
        _columnMaxYs = [[NSMutableArray alloc] init];
    }
    return _columnMaxYs;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

- (CGSize)collectionViewContentSize
{
    // 找出最长那一列的最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    for (NSUInteger i = 1; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最大值
        if (destMaxY < columnMaxY) {
            destMaxY = columnMaxY;
        }
    }
    return CGSizeMake(0, destMaxY + kInsets.bottom);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    // 重置每一列的最大Y值
    [self.columnMaxYs removeAllObjects];
    for (NSUInteger i = 0; i<kColumnCounts; i++)
    {
        [self.columnMaxYs addObject:@(kInsets.top)];
    }
    
    // 计算所有cell的布局属性
    [self.attrsArray removeAllObjects];
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i < count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

//cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /** 计算indexPath位置cell的布局属性 */
    
    // 水平方向上的总间距
    CGFloat xMargin = kInsets.left + kInsets.right + (kColumnCounts - 1) * kColumnSpace;
    // cell的宽度
    CGFloat cellWidth = (kScreenWidth - xMargin) / kColumnCounts;
    // cell的高度，随机数
    CGFloat cellHeight = 50 + arc4random_uniform(150);
    
    // 找出最短那一列的 列号 和 最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    NSUInteger destColumn = 0;
    for (NSUInteger i = 1; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最小值
        if (destMaxY > columnMaxY) {
            destMaxY = columnMaxY;
            destColumn = i;
        }
    }
    
    // cell的x值
    CGFloat x = kInsets.left + destColumn * (cellWidth + kColumnSpace);
    // cell的y值
    CGFloat y = destMaxY + kRowSpace;
    // cell的frame
    attrs.frame = CGRectMake(x, y, cellWidth, cellHeight);
    
    // 更新数组中的最大Y值
    self.columnMaxYs[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}


@end

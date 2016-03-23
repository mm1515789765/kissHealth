//
//  WLCollectionView.h
//  WLEmotionViewDemo
//
//  Created by Macx on 16/1/15.
//  Copyright © 2016年 wl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DeleteBlock)();
typedef void (^ClickBlock)(id userNeed);

@interface WLEmotionView: UICollectionView

//表情图片数组
@property (copy, nonatomic)NSArray *emotionsArr;

//点击表情对应返回数据的数组
@property (copy, nonatomic)NSArray *returnArr;


//配置行列,默认4行7列
- (void)configRow:(NSInteger)row configColumn:(NSInteger)column;

//设置删除按钮
- (void)deleteImage:(UIImage *)image deleteAction:(DeleteBlock)deleteBl;

//点击表情回调block，返回点击表情对应的数据
- (void)clickEmotion:(ClickBlock)clickBl;


@end

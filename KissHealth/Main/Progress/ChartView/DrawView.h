//
//  DrawView.h
//  KissHealth
//
//  Created by Lix on 16/2/14.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIScrollView

//是否动态绘制
@property (assign, nonatomic) BOOL isAnimation;


/**
 *  自定义方法
 *
 *  @param frame       frame
 *  @param dataSource  数据源
 *  @param isAnimation 是否动态绘制
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
     withDataSource:(NSMutableArray *)dataSource
      withAnimation:(BOOL)isAnimation;



@end

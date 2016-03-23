//
//  DataView.h
//  KissHealth
//
//  Created by Lix on 16/2/14.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataView : UIView

/**
 *  自定义方法
 *  显示折线图上方的数据信息
 *  @param frame      frame
 *  @param dataSource 数据源信息
 *
     列表总高度50
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
     withDataSource:(NSMutableArray *)dataSource;


@end

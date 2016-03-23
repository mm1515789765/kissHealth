//
//  RemindView.h
//  KissHealth
//
//  Created by Apple on 16/2/22.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindView : UIView

@property (nonatomic,assign)NSInteger selectPkViewIndex;
@property (nonatomic,copy)NSString *isSureString;

- (instancetype)initWithFrame:(CGRect)frame isAdd:(BOOL )isAdd;


@end

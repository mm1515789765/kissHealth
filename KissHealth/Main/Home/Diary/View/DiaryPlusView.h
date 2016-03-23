//
//  DiaryPlusVIew.h
//  KissHealth
//
//  Created by Macx on 16/2/17.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHTabBarVC.h"

@interface DiaryPlusView : UIView

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) UIPickerView *plusPickerView;

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title;

@end

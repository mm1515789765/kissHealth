//
//  KHPlusControl.h
//  KissHealth
//
//  Created by Macx on 16/2/16.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHPlusControl : UIControl

@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *label;

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)name title:(NSString *)title color:(UIColor *)color;


@end

//
//  KHPlusControl.m
//  KissHealth
//
//  Created by Macx on 16/2/16.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHPlusControl.h"

@implementation KHPlusControl

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)name title:(NSString *)title color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 45, 10)];
        
        self.title = title;
        
        self.imageView.image = [UIImage imageNamed:name];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.label.text = title;
        self.label.font = [UIFont systemFontOfSize:13];
//        self.label.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:name]];
        self.label.textColor = color;
        self.label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}


@end

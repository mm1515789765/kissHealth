//
//  KHCellControl.m
//  KissHealth
//
//  Created by Macx on 16/2/19.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHCellControl.h"

@implementation KHCellControl

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)name title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (frame.size.height - 10) / 2, 10, 10)];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width - frame.size.height - 5, frame.size.height)];
        
        self.imageView.image = [UIImage imageNamed:name];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.label.text = title;
        self.label.font = [UIFont systemFontOfSize:13];
        self.label.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background"]];
        
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        
        self.label.text = title;
    }
}

@end

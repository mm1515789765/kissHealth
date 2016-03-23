//
//  RuleView.h
//  KissHealth
//
//  Created by Lix on 16/2/20.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RuleViewDelegate <NSObject>

//回传Scrollview的值
- (void)passValue:(NSString *)value;

@end


@interface RuleView : UIView

-(instancetype)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource;

@property (nonatomic, weak)id<RuleViewDelegate>delegate;

@end

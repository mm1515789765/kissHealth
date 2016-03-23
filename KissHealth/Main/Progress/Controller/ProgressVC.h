//
//  ProgressVC.h
//  KissHealth
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuleView.h"

@interface ProgressVC : UIViewController <RuleViewDelegate>

@property (nonatomic, copy) UIButton * recordButton;
@property (nonatomic, copy) UIButton * timeButton;

@end
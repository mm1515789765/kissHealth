//
//  DiaryFootCell.h
//  KissHealth
//
//  Created by Macx on 16/2/15.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryVC.h"

@interface DiaryFootCell : UITableViewCell

@property(nonatomic, copy) NSString *addString;
@property(nonatomic,copy) NSString *title;

- (DiaryVC *)viewController;

@end

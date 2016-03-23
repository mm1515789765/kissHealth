//
//  RemindCell.h
//  KissHealth
//
//  Created by Apple on 16/2/22.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreModel;
@interface RemindCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (nonatomic,strong)MoreModel *model;

@end

//
//  AnnDetailView.h
//  KissHealth
//
//  Created by Macx on 16/2/12.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrugStoreModel;

@interface AnnDetailView : UIView

@property (nonatomic , strong)DrugStoreModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *naviButton;

@end

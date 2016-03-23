//
//  RemindCell.m
//  KissHealth
//
//  Created by Apple on 16/2/22.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "RemindCell.h"
#import "MoreModel.h"

@implementation RemindCell

- (void)awakeFromNib {
    
}

- (void)setModel:(MoreModel *)model
{
    if (_model != model) {
        _model = model;
    }
    self.title.text = self.model.title;
    self.subTitle.text = self.model.subTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

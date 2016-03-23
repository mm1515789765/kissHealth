//
//  DataTableViewCell.m
//  KissHealth
//
//  Created by Lix on 16/2/17.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DataTableViewCell.h"

@implementation DataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(CoordinateModel *)model
{
    if (_model != model) {
        _model = model;
        
        
    WeightData.text = self.model.coordinateYValue;
        
    DateDateLabel.text = self.model.coordinateXValue;
        
//        btn_camera_roll@2x.png
    [_cameraButton setImage:[UIImage imageNamed:@"btn_camera_roll@2x.png"] forState:UIControlStateNormal];
        
        _cameraButton.frame = CGRectMake(self.frame.size.width - 70, 10, 50, 50);
    
    }
}



@end

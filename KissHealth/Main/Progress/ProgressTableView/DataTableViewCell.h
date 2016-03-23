//
//  DataTableViewCell.h
//  KissHealth
//
//  Created by Lix on 16/2/17.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoordinateModel.h"

@interface DataTableViewCell : UITableViewCell

{
    
    __weak IBOutlet UILabel *WeightData;
    
    __weak IBOutlet UILabel *DateDateLabel;
    __weak IBOutlet UIButton *_cameraButton;
}

@property (strong, nonatomic) CoordinateModel * model ;


@end

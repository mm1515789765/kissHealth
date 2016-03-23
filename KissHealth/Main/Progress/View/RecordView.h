//
//  RecordView.h
//  KissHealth
//
//  Created by Lix on 16/2/3.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TitleBlock) (NSString *);

@interface RecordView : UIView <UIPickerViewDataSource , UIPickerViewDelegate>
{
    NSArray * _nameArray;
    UIPickerView * _pickerView;
}

@property(nonatomic , copy) TitleBlock  titleBlock;

@end

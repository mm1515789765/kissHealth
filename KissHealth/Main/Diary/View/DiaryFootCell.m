//
//  DiaryFootCell.m
//  KissHealth
//
//  Created by Macx on 16/2/15.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DiaryFootCell.h"
#import "KHCellControl.h"
#import "FoodViewController.h"

@implementation DiaryFootCell
{
    KHCellControl *_addButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _addButton = [[KHCellControl alloc] initWithFrame:CGRectMake( 10, (self.frame.size.height - 30) / 2, 100, 30) image:@"btn_diary_add_normal" title:self.addString];
        KHCellControl *moreButton = [[KHCellControl alloc] initWithFrame:CGRectMake( kScreenWidth - 55, (self.frame.size.height - 20) / 2, 55, 20) image:@"btn_diary_more_normal" title:@"更多"];
        
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.contentView addSubview:_addButton];
        [self.contentView addSubview:moreButton];
        
    }
    return self;
}

- (void)setAddString:(NSString *)addString
{
    if (_addString != addString) {
        _addString = addString;
        
        _addButton.title = addString;
        
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ButtonAction
- (void)addButtonAction:(KHCellControl *)button
{
    FoodViewController *foodVC = [[FoodViewController alloc] init];
    foodVC.title = self.title;
    
    [self.viewController.navigationController pushViewController:foodVC animated:YES];
    
    
    
}

- (void)moreButtonAction:(KHCellControl *)button
{    
    UIAlertController *moreAlertCtrl = [UIAlertController alertControllerWithTitle:@"食物" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [moreAlertCtrl addAction:[UIAlertAction actionWithTitle:@"关闭“智能复制”" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       
    }]];
    
    [moreAlertCtrl addAction:[UIAlertAction actionWithTitle:@"快速添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    
    [moreAlertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    
    
    [self.viewController presentViewController:moreAlertCtrl animated:YES completion:NULL];
}

- (DiaryVC *)viewController
{
    UIResponder *responder = self;
    
    do {
        responder = responder.nextResponder;
        
        if ([responder isKindOfClass:[DiaryVC class]]) {
            break;
        }
        
    } while (YES);
    
    return (DiaryVC *)responder;
}

@end

//
//  KHDiaryTableView.h
//  KissHealth
//
//  Created by Macx on 16/2/14.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KHDiaryModel;
@interface KHDiaryTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) KHDiaryModel *diaryModel;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style diaryModel:(KHDiaryModel *)sharedModel;



@end

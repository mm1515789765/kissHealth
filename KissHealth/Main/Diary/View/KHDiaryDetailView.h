//
//  KHDiaryDetailView.h
//  KissHealth
//
//  Created by Macx on 16/2/15.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KHDiaryModel;
@class DiaryVC;
@interface KHDiaryDetailView : UIView

@property(nonatomic, strong) KHDiaryModel *diaryModel;

- (instancetype)initWithFrame:(CGRect)frame diaryModel:(KHDiaryModel *)sharedModel;

- (void)reloadTableViewData;
- (DiaryVC *)viewController;

@end

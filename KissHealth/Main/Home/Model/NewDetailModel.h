//
//  NewDetailModel.h
//  KissHealth
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewDetailModel : NSObject


@property (copy, nonatomic) NSString *newsID;          //新闻ID
@property (copy, nonatomic) NSString *imgURL;          //图片URL
@property (copy, nonatomic) NSString *title;           //新闻标题
@property (copy, nonatomic) NSString *message;         //新闻内容
@property (assign, nonatomic) NSInteger rcount;        //评论数
@property (assign, nonatomic) NSInteger fcount;         //收藏数
@property (assign, nonatomic) NSString *time;           //创建时间




@end

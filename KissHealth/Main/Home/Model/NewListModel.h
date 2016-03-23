//
//  NewListModel.h
//  KissHealth
//
//  Created by Macx on 16/1/31.
//  Copyright © 2016年 LWHTteam. All rights reserved.
/*
 id	long	ID编码
 keywords	string	关键词
 title	string	标题
 description	string	简介
 img	string	图片
 infoclass	int	分类ID
 count	int	访问数
 rcount	int	评论数
 fcount	int	收藏数
 time	long	发布时间
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NewListModel : NSObject

@property (copy, nonatomic) NSString *newsDescription; //新闻简介
@property (copy, nonatomic) NSString *newsID;          //新闻ID
@property (copy, nonatomic) NSString *imgURL;          //图片URL
@property (copy, nonatomic) NSString *title;           //新闻标题
@property (assign, nonatomic) NSInteger rcount;        //评论数
@property (assign, nonatomic) NSInteger fcount;         //收藏数
@property (assign, nonatomic) NSInteger time;           //创建时间
@property (assign, nonatomic) BOOL isRead;             //用来判断是否已经被阅读


@property (assign, nonatomic) CGRect newsDesFrame;
@property (assign, nonatomic) CGRect imageFrame;
@property (assign, nonatomic) CGRect titleFrame;
@property (assign, nonatomic) CGFloat cellHeight;

@end

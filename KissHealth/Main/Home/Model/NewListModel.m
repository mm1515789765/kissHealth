//
//  NewListModel.m
//  KissHealth
//
//  Created by Macx on 16/1/31.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "NewListModel.h"
#define kPhoneFont 13
#define kPadFont 18
#define kLeftSpacing 1.0/32*kScreenWidth
#define kTitleLabelMaxY 45


@implementation NewListModel

- (void)setNewsDescription:(NSString *)newsDescription
{
    
    _newsDescription = newsDescription;
    [self layoutDesLabel:newsDescription];
}

- (void)setImgURL:(NSString *)imgURL
{
    //处理API接口的url
    //@"http://tnfs.tngou.net/image"
    if (imgURL.length == 0)
    {
        return;
    }
    
    NSString *firstHalf = @"http://tnfs.tngou.net/image";
    imgURL = [firstHalf stringByAppendingString:imgURL];
//    NSLog(@"%@",imgURL);
    _imgURL = imgURL;
  
}


- (void)layoutDesLabel:(NSString *)newsDescription
{
     if(isPad)
     {
         [self padFrame:newsDescription];
         return;
     }
    //根据内容计算label高度
    NSDictionary *dic = @{
            NSFontAttributeName:[UIFont systemFontOfSize:kPhoneFont],
            NSParagraphStyleAttributeName:[NSParagraphStyle defaultParagraphStyle],
            };
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 1;
    CGRect rect = [newsDescription boundingRectWithSize:CGSizeMake(kScreenWidth * (19.0/32), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:context];
    //计算视图的frame
    if (rect.size.height > 0.22 * kScreenHeight)
    {
        self.newsDesFrame = CGRectZero;
        self.imageFrame = CGRectMake(kLeftSpacing, kTitleLabelMaxY, kScreenWidth-2*kLeftSpacing, 0.25 * kScreenHeight);
    }
    else
    {
        CGFloat imgHeight = rect.size.height > kScreenWidth * (10.0/32)? rect.size.height : kScreenWidth * (10.0/32);
        self.imageFrame = CGRectMake(kLeftSpacing, 45, kScreenWidth * (10.0/32), imgHeight);
        CGFloat labelX = CGRectGetMaxX(_imageFrame);
        self.newsDesFrame = CGRectMake(labelX + kLeftSpacing, kTitleLabelMaxY, rect.size.width, rect.size.height);
        
    }
    self.titleFrame = CGRectMake(kLeftSpacing, 10, kScreenWidth- 2*kLeftSpacing, 30);
    
    self.cellHeight = kTitleLabelMaxY+_imageFrame.size.height + 10;
    
    
}

- (void)padFrame:(NSString *)newsDescription
{
    //根据内容计算label高度
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:kPadFont],
                          NSParagraphStyleAttributeName:[NSParagraphStyle defaultParagraphStyle],
                          };
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 1;
    CGRect rect = [newsDescription boundingRectWithSize:CGSizeMake(kScreenWidth * (19.0/32), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:context];
    //计算视图的frame
    CGFloat imgHeight = rect.size.height < rect.size.height? rect.size.height : kScreenWidth * (10.0/32);
    self.imageFrame = CGRectMake(kLeftSpacing, 10, kScreenWidth * (10.0/32), imgHeight);
    CGFloat labelX = CGRectGetMaxX(_imageFrame);
    self.newsDesFrame = CGRectMake(labelX + kLeftSpacing, kTitleLabelMaxY, rect.size.width, rect.size.height);
    self.titleFrame = CGRectMake(labelX + kLeftSpacing, 10, kScreenWidth-2*kLeftSpacing-_imageFrame.size.width, 30);
    
    self.cellHeight = _imageFrame.size.height + 20;
}



@end

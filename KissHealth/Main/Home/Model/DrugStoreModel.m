//
//  DrugStoreModel.m
//  KissHealth
//
//  Created by Macx on 16/2/10.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DrugStoreModel.h"

@implementation DrugStoreModel

- (void)setImg:(NSString *)img
{   //处理API接口的url
    //@"http://tnfs.tngou.net/image"
    if (img.length == 0)
    {
        return;
    }
    NSString *firstHalf = @"http://tnfs.tngou.net/image";
    img = [firstHalf stringByAppendingString:img];
    //    NSLog(@"%@",imgURL);
    _img = img;
    
}

@end

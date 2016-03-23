//
//  KHNews.h
//  KissHealth
//
//  Created by Macx on 16/1/31.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kAPIAddress @"http://apis.baidu.com/tngou/"
#define kAPIxKey @"c20bae6511ea1e213352460bbbb3b306"

typedef void(^RequestFinishBlock)(NSDictionary *jsonDic,NSHTTPURLResponse *response, NSError *error);
typedef void(^RequestFailBlock)(NSHTTPURLResponse *response, NSError *error);

@interface KHNews : NSObject


+ (instancetype)sharedKHNews;

- (KHNews *)requestWithURL:(NSString *)url
                              params:(NSMutableDictionary *)params
                            finishBlock:(RequestFinishBlock)block
                            failBlock:(RequestFailBlock)failBlock;

@end

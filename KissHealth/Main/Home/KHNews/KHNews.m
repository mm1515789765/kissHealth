//
//  KHNews.m
//  KissHealth
//
//  Created by Macx on 16/1/31.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

//请求示例http://a.apix.cn/yi18/news/search?page=1&limit=20&keyword=养生
//http://a.apix.cn/yi18/news/newsclass?


#import "KHNews.h"

@interface KHNews()

@property (strong, nonatomic)NSURLSession *session;

@end


@implementation KHNews

+ (instancetype)sharedKHNews
{
    static KHNews *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:nil] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedKHNews];
}

- (NSURLSession *)session
{
    if (_session == nil)
    {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}

- (KHNews *)requestWithURL:(NSString *)url
                    params:(NSMutableDictionary *)params
               finishBlock:(RequestFinishBlock)block
                 failBlock:(RequestFailBlock)failBlock
{
    
    NSDictionary *headers = @{ @"accept": @"application/json",
                               @"content-type": @"application/json",
                               @"apikey": kAPIxKey };
    
    NSURL *completeURL = [self configSession:url params:params];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = completeURL;
    request.HTTPMethod = @"GET";
    [request setAllHTTPHeaderFields:headers];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error && failBlock)
        {
            failBlock((NSHTTPURLResponse *)response,error);
            return;
        }
        if (!error && block)
        {
            NSError *jsonError = nil;
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            block(jsonDic,(NSHTTPURLResponse *)response,error);
        }
        
    }];
    [dataTask resume];
    
    return self;
}

//对url进行处理
- (NSURL *)configSession:(NSString *)url params:(NSMutableDictionary *)params
{
    NSArray *keys = [params allKeys];
    NSString *append = [NSString string];
    for (NSString *key in keys)
    {
        NSString *value = [params objectForKey:key];
        NSString *UTF8Str = [value stringByAddingPercentEncodingWithAllowedCharacters:
                             [NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@&",key,UTF8Str];
        append  = [append stringByAppendingString:keyValue];
        
    }
    //去掉最后拼接的&符号
    if (keys.count > 0) {
        append = [append substringWithRange:NSMakeRange(0, append.length - 1)];
    }
    
    
    NSString *completeUrlStr = [kAPIAddress stringByAppendingFormat:@"%@?%@",url,append];
//    NSLog(@"%@",completeUrlStr);
    
    return [NSURL URLWithString:completeUrlStr];
    
}

@end

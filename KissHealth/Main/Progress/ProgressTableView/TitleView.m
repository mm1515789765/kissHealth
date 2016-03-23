//
//  TitleView.m
//  KissHealth
//
//  Created by Lix on 16/2/16.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "TitleView.h"
#import <ShareSDK/ShareSDK.h>
@implementation TitleView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createTitleView];
    }
    return self;
}

- (void)_createTitleView
{
    //创建顶部蓝色标签栏的背景视图
    UIImageView * titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    titleImgView.image = [UIImage imageNamed:@"nav_bar_background@2x.png"];
    
    [self addSubview:titleImgView];
    
    //添加 @“记录” 的Label
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
    titleLabel.text = @"记录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    
    //创建分享button  btn_share@2x.png
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(self.frame.size.width - 120, 10, 100, 20);
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage * shareImg = [UIImage imageNamed:@"btn_share@2x.png"];
    [shareButton setImage:shareImg forState:UIControlStateNormal];
    
    //将button的样式改为左边文字 右边图片
    [shareButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - shareImg.size.width, 0, shareImg.size.width)];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, shareButton.titleLabel.bounds.size.width + 10, 0, -shareButton.bounds.size.width)];
    
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:shareButton];
}

- (void)share:(UIButton *)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

@end

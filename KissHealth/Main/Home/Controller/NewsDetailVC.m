//
//  NewsDetailVC.m
//  KissHealth
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "NewsDetailVC.h"
#import "NewDetailModel.h"
#import "WLViewController.h"

#define kImgWidth kScreenWidth-1.0/32*kScreenWidth*2
#define kImgHeight kScreenHeight * (1.0 / 4)
#define kEmptyRegex @"<br/>"

@interface NewsDetailVC ()<UIWebViewDelegate>

@property (strong, nonatomic)UIWebView *webView;
@property (strong, nonatomic)UIActivityIndicatorView *activity;
@property (strong, nonatomic)UIView *bottomView;

@end

@implementation NewsDetailVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新闻详情";
   
    [self creatNaviButton];
    [self creatWebView];
    [self creatActivityView];
    [self creatBottomView];
}


- (void)setModel:(NewDetailModel *)model
{
    if (model.message.length == 0)
    {
        
        return;
    }
    model = [self regexStr:model];
    
    [self.webView loadHTMLString:model.message baseURL:nil];
    _model = model;
}


#pragma mark - handle Data
//对数据进行处理
- (NewDetailModel *)regexStr:(NewDetailModel *)model
{
    model.message = [self textRegex:model.message];
    model.message = [self imgRegex:model.message];
    model = [self addTitleInfo:model];
    
    return model;
}
//添加标题时间等
- (NewDetailModel *)addTitleInfo:(NewDetailModel *)model
{
    NSString *dateStr = nil;
    if (model.time != nil)
    {
        double timestampval =  [model.time doubleValue] /1000;
        NSTimeInterval timestamp = (NSTimeInterval)timestampval;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        dateStr = [formatter stringFromDate:date];
    }
    else
    {
        dateStr = @"未知时间";
    }
    
    
    NSString *titleStr = [NSString stringWithFormat:@"<h3>%@</h3><p style = \"font-size:12\">时间:%@</br>收藏数:%ld</p>",model.title,dateStr,(long)model.fcount];
    model.message = [titleStr stringByAppendingString:model.message];
    
    return model;
}

//空行处理
- (NSString *)textRegex:(NSString *)message
{

    NSRegularExpression *emptyRegex = [NSRegularExpression regularExpressionWithPattern:kEmptyRegex options:NSRegularExpressionCaseInsensitive error:nil];
    if (!emptyRegex)
    {
        return message;
    }
    NSArray *emptyArr = [emptyRegex matchesInString:message options:NSMatchingReportCompletion range:NSMakeRange(0, message.length)];
    if (emptyArr.count == 0)
    {
        return message;
    }
   
    NSMutableString *newMessage = [NSMutableString stringWithString:message];
  
    for (int i = 0; i < emptyArr.count; i++)
    {
        NSTextCheckingResult *result = emptyArr[i];
         NSRange deleteRange = NSMakeRange(result.range.location - i * kEmptyRegex.length, result.range.length);
        if (deleteRange.location + deleteRange.length > newMessage.length)
        {
            continue;
        }
        [newMessage deleteCharactersInRange:deleteRange];
        
    }
    message = [newMessage stringByAppendingString:@"<br/><br/>"];
    return message;
}


//图片处理
- (NSString *)imgRegex:(NSString *)message
{
    //本身带width,height处理
    NSRegularExpression *widthRegex = [NSRegularExpression regularExpressionWithPattern:@"width=\"\\d{3,}\"" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRegularExpression *heightRegex = [NSRegularExpression regularExpressionWithPattern:@"height=\"\\d{3,}\"" options:NSRegularExpressionCaseInsensitive error:nil];
    
//    NSTextCheckingResult *widthResult = [widthRegex firstMatchInString:message options:NSMatchingReportCompletion range:NSMakeRange(0, message.length)];
//    NSTextCheckingResult *heightResult = [heightRegex firstMatchInString:message options:NSMatchingReportCompletion range:NSMakeRange(0, message.length)];
    
    NSArray *allWidth = [widthRegex matchesInString:message options:NSMatchingReportCompletion range:NSMakeRange(0, message.length)];
    NSArray *allHeight = [heightRegex matchesInString:message options:NSMatchingReportCompletion range:NSMakeRange(0, message.length)];
    
    for (NSTextCheckingResult *widthResult in allWidth)
    {
        if (widthResult.range.length != 0 )
        {
            NSString *width = [NSString stringWithFormat:@"width=\"%.0f\"",kImgWidth];
            
            message = [message stringByReplacingCharactersInRange:widthResult.range withString:width];
//          message =  [message substringWithRange:widthResult.range];
        }
        
    }
    for (NSTextCheckingResult *heightResult in allHeight)
    {
        if (heightResult.range.length != 0)
        {
            NSString *height = [NSString stringWithFormat:@"height=\"%.0f\"",kImgHeight];
             message = [message stringByReplacingCharactersInRange:heightResult.range withString:height];
            
        }
    }
//    if (allHeight.count && allWidth.count)
//    {
//       
//        return message;
//    }
    
    
//    if (widthResult.range.length != 0 && heightResult.range.length != 0)
//    {
//        NSString *width = [NSString stringWithFormat:@"width=\"%.0f\"",kImgWidth];
//        NSString *height = [NSString stringWithFormat:@"height=\"%.0f\"",kImgHeight];
//        message = [message stringByReplacingCharactersInRange:widthResult.range withString:width];
//        message = [message stringByReplacingCharactersInRange:heightResult.range withString:height];
//        return message;
//    }
    
  
    //不带height，width图片处理
    NSRegularExpression *regexImg = [NSRegularExpression regularExpressionWithPattern:@".jpg\"/>|.png\"/>" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSTextCheckingResult *imgResult = [regexImg firstMatchInString:message options:NSMatchingReportCompletion range:NSMakeRange(0, message.length)];
    
    NSArray *imgArr = [regexImg matchesInString:message options:NSMatchingReportCompletion range:NSMakeRange(0, message.length)];

    NSMutableString *newMessage = [NSMutableString stringWithString:message];
 
    for(int i = 0; i < imgArr.count; i++)
    {
        NSTextCheckingResult *result = imgArr[i];
        if (result.range.length == 0)
        {
            return message;
        }
        NSString *imgSizeStr = [NSString stringWithFormat:@"width=\"%.0f\" heitht=\"%.0f\"",kImgWidth,kImgHeight];
        
        [newMessage insertString:imgSizeStr atIndex:result.range.location + 5 + i * (imgSizeStr.length + 5)];
        
    }
    
//    if (result.range.length == 0)
//    {
//        return message;
//    }
//    NSMutableString *newMessage = [NSMutableString stringWithString:message];
//    NSString *imgSizeStr = [NSString stringWithFormat:@"width=\"%.0f\" heitht=\"%.0f\"",kImgWidth,kImgHeight];
//    
//    [newMessage insertString:imgSizeStr atIndex:imgResult.range.location + 5];
    
    return newMessage;
    
}

#pragma mark - creatAboutViews
- (void)creatWebView
{
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _webView.delegate = self;
    
    [self.webView addGestureRecognizer:leftSwip];
    [self.view addSubview:self.webView];
}

- (void)creatActivityView
{
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activity];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [_activity startAnimating];
}

- (void)creatNaviButton
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_webview_back_normal.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)creatBottomView
{
    CGFloat btSize = 49;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49 - 64, kScreenWidth, 49)];
    _bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_tabbar_background"]];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 4  - btSize /2, 0, btSize, btSize)];
    [shareButton setImage:[UIImage imageNamed:@"ic_message_reply"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];

    UIButton *commentButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 4 * 2 - btSize /2, 0, btSize, btSize)];
    [commentButton setImage:[UIImage imageNamed:@"ic_comment"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hiddenButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 4 * 3 - btSize /2, 0, btSize, btSize)];
    [hiddenButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [hiddenButton addTarget:self action:@selector(moveBottomView:) forControlEvents:UIControlEventTouchUpInside];
    hiddenButton.tag = 1003;
    
    [_bottomView addSubview:commentButton];
    [_bottomView addSubview:shareButton];
    [_bottomView addSubview:hiddenButton];
    
    [self.view addSubview:_bottomView];
}

- (void)commentAction
{
    WLViewController *commentVC = [[WLViewController alloc] init];
    [self.navigationController pushViewController:commentVC animated:YES];
    
}

- (void)shareAction
{
    NSURL *weixingURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?"];
    if ([[UIApplication sharedApplication] canOpenURL:weixingURL])
    {
        [[UIApplication sharedApplication] openURL:weixingURL];
    }
}

- (void)moveBottomView:(UIButton *)sender
{
    if (sender.tag == 1003)
    {
        [UIView animateWithDuration:0.5 animations:^{
            _bottomView.frame = CGRectMake(0, kScreenHeight-64, kScreenWidth, 49);
            
        }];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_add_active"] style:UIBarButtonItemStylePlain target:self action:@selector(moveBottomView:)];
        self.navigationItem.rightBarButtonItem = rightButton;
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        _bottomView.frame = CGRectMake(0, kScreenHeight-64 - 49, kScreenWidth, 49);
        weakSelf.navigationItem.rightBarButtonItem = nil;
        
    }];
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_activity stopAnimating];
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activity stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

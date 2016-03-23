//
//  WLViewController.m
//  WLEmotionViewDemo
//
//  Created by Macx on 16/1/15.
//  Copyright © 2016年 wl. All rights reserved.
//

#import "WLViewController.h"
#import "WLEmotionView.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface WLViewController ()<UITextViewDelegate>
{
    CGFloat keyBoardHeight;
}

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) WLEmotionView *colView;
   


@end

@implementation WLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self congfigView];
    self.title = @"评论";
    self.tabBarController.tabBar.hidden = YES;
}

//基础界面
- (void)congfigView
{
    _textView = [[UITextView alloc]
                 initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_textView];
    _textView.delegate = self;
    
    //创建键盘工具条
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    toolBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_tabbar_background"]];
    UIBarButtonItem *emotionItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_emoji_inactive"] style:UIBarButtonItemStylePlain target:self action:@selector(changeInputView)];
    
    toolBar.items = @[emotionItem];
    _textView.inputAccessoryView = toolBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    
}

- (void)popKeyboard:(NSNotification *)notification
{
   CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    keyBoardHeight = rect.size.height;
}


- (void)changeInputView
{
    [_textView resignFirstResponder];
    
    [self.view addSubview:self.colView];
   
}

- (WLEmotionView *)colView
{
    if (_colView == nil)
    {
        _colView = [[WLEmotionView alloc] initWithFrame:CGRectMake(0, kScreenHeight - keyBoardHeight -24, kScreenWidth, keyBoardHeight - 40)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
        NSArray *plistArr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *imagesArr = [NSMutableArray array];
        for (NSDictionary *dic in plistArr)
        {
            NSString *str = [dic objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:str];

            [imagesArr addObject:image];
        }
        _colView.emotionsArr = imagesArr;
        _colView.returnArr = imagesArr;
        
        [self styleOne];
        
       
        
    }
    return _colView;
}


- (void)styleOne
{
    UIImage *deleteImage = [UIImage imageNamed:@"ic_close"];
    [_colView configRow:3 configColumn:3];
    [_colView deleteImage:deleteImage deleteAction:^{
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
        if (attStr.length < 1)
        {
            return;
        }
        [attStr deleteCharactersInRange:NSMakeRange(attStr.length -1, 1)];
        _textView.attributedText = attStr;
    }];
    [_colView clickEmotion:^(id userNeed) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
        
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = userNeed;
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:attach];
        [attStr insertAttributedString:textAttachmentString atIndex:_textView.selectedRange.location];
        self.textView.attributedText = attStr;
        
    }];
}

#pragma mark - Text View Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.colView removeFromSuperview];
    self.colView = nil;
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.colView removeFromSuperview];
    self.textView.text = nil;
}


@end

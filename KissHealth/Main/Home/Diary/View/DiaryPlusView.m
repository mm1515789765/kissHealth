//
//  DiaryPlusVIew.m
//  KissHealth
//
//  Created by Macx on 16/2/17.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DiaryPlusView.h"

@implementation DiaryPlusView
{
    UIControl *_maskView;
    UIView *_backView;
}

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.title = title;
        
        [self _createMaskView];
        [self _createPickerView];
    }
    return self;
}

- (void)_createMaskView
{
    if (_maskView == nil) {
        _maskView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [_maskView addTarget:self action:@selector(maskViewAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_maskView];
}

- (void)_createPickerView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 300)];
    }
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background"]];
    [_backView addSubview:topView];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 7.5, 25, 25)];
    [closeButton setImage:[UIImage imageNamed:@"ic_nav_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(maskViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeButton];
    
    if ([self.title isEqualToString:@"水"]) {
        
        UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 35, 7.5, 25, 25)];
        [checkButton setImage:[UIImage imageNamed:@"ic_nav_checkmark_active"] forState:UIControlStateNormal];
        [checkButton addTarget:self action:@selector(maskViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:checkButton];
        
        _backView.backgroundColor = [UIColor whiteColor];
        _plusPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 200)];
        
        [_backView addSubview:_plusPickerView];
        [_maskView addSubview:_backView];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _backView.transform = CGAffineTransformMakeTranslation(0, -220);
            
        } completion:NULL];
    }
    
    if ([self.title isEqualToString:@"食物"]) {

        _backView.backgroundColor = [UIColor whiteColor];
        _plusPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 200)];
        
        [_backView addSubview:_plusPickerView];
        [_maskView addSubview:_backView];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _backView.transform = CGAffineTransformMakeTranslation(0, -230);
            
        } completion:NULL];
    }
    
    if ([self.title isEqualToString:@"运动"]) {
        
        _backView.backgroundColor = [UIColor whiteColor];
        _plusPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 200)];
        
        [_backView addSubview:_plusPickerView];
        [_maskView addSubview:_backView];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _backView.transform = CGAffineTransformMakeTranslation(0, -140);
            
        } completion:NULL];
    }
    
}

- (void)maskViewAction:(UIControl *)maskView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _backView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        _maskView.hidden = YES;
        _maskView = nil;
        _plusPickerView = nil;
        _backView = nil;
        
        [self removeFromSuperview];
    }];

}


@end

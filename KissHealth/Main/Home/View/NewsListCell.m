//
//  NewsListCell.m
//  KissHealth
//
//  Created by Macx on 16/1/31.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "NewsListCell.h"
#import "NewListModel.h"
@interface NewsListCell()
{
    BOOL haveDownLoadTask;
    NSBlockOperation *blockOperation;
    
}
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation NewsListCell

//懒加载
- (NSOperationQueue *)queue
{
    if (_queue == nil)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self fixedConfig];
}

- (void)setModel:(NewListModel *)model
{
    if (_model != model)
    {
        _model = model;
    }
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.detailLabel.frame = self.model.newsDesFrame;
    self.titleLabel.frame = self.model.titleFrame;
    self.imgView.frame = self.model.imageFrame;
    self.titleLabel.text = self.model.title;
    self.detailLabel.text = self.model.newsDescription;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.imgView.backgroundColor = [UIColor lightGrayColor];
}



- (void)fixedConfig
{
    self.detailLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (isPad)
    {
        _titleLabel.font = [UIFont systemFontOfSize:19];
        _detailLabel.font = [UIFont systemFontOfSize:18];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

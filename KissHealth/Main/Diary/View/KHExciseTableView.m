//
//  KHExciseTableView.m
//  KissHealth
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "KHExciseTableView.h"
#import "ExciseModel.h"
#import "FoodViewController.h"

static NSString *identifier = @"exciseCell";
@implementation KHExciseTableView
{
    NSArray *_exciseList;
}

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        
        NSString *exciseListPath = [[NSBundle mainBundle] pathForResource:@"ExciseList" ofType:@"plist"];
        
        NSArray *exciseArray = [NSArray arrayWithContentsOfFile:exciseListPath];
        
        NSMutableArray *exciseMutable = [[NSMutableArray alloc] init];
        for (int i = 0; i < exciseArray.count; i++) {
            
            NSDictionary *dic = exciseArray[i];
            ExciseModel *model = [[ExciseModel alloc] init];
            model.name = dic[@"name"];
            model.kalori = [dic[@"kalori"] doubleValue];
            
            [exciseMutable addObject:model];
        }
        
        _exciseList = [NSArray arrayWithArray:exciseMutable];
    
        self.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];

    }
    return self;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _exciseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [_exciseList[indexPath.row] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.viewController.navigationItem.rightBarButtonItem.enabled = YES;
    _checkExcise = _exciseList[indexPath.row];
    
}

- (FoodViewController *)viewController
{
    UIResponder *responder = self;
    
    do {
        responder = responder.nextResponder;
        
        if ([responder isKindOfClass:[FoodViewController class]]) {
            break;
        }
        
    } while (YES);
    
    return (FoodViewController *)responder;
}




@end

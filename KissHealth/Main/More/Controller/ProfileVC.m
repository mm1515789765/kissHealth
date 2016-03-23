//
//  ProfileVC.m
//  KissHealth
//
//  Created by Apple on 16/2/19.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "ProfileVC.h"
#import "ProfileCell.h"
#import "UnitVC.h"

@interface ProfileVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSArray *_titleArray;
    NSArray *_pickerArray;
    NSMutableArray *_subTitleArray;
    
    UIView *_backgroundView;
    UIView *_sixView;
    UIView *_birthView;
    NSInteger _index;
    UIView *_glassView;
    
    UITableView *_profileTV;
}

@end

@implementation ProfileVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    [self _createLabelArray];
    [self _createSubViewAndArray];
    
    [_profileTV registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:NULL] forCellReuseIdentifier:@"profileCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiUnitChanged:) name:kUnitNotification object:nil];
}

- (void)notiUnitChanged:(NSNotification *)notification
{
    NSMutableString *str = [[NSMutableString alloc] init];
    
    NSArray *arr = [NSArray array];
    arr = notification.object;
    
    if (arr) {
        for (NSInteger i = 0; i < arr.count; i++) {
            
            if (i == arr.count - 1) {
                [str appendString:arr[i]];
            }else{
                
                [str appendString:arr[i]];
                [str appendString:@","];
            }
        }
    }
    
    [_subTitleArray replaceObjectAtIndex:_index withObject:str];
    [_profileTV reloadData];
}

- (void)_createSubViewAndArray
{
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background@2x.png"]];
    
    CGFloat minX = headerView.center.x - 34;
    CGFloat minY = headerView.center.y + 3.5;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(minX, minY, 68, 7)];
    label.text = @"个人资料";
    label.textColor = [UIColor whiteColor];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    leftButton.tag = 202;
    leftButton.showsTouchWhenHighlighted = YES;
    [leftButton setImage:[UIImage imageNamed:@"ic_nav_arrow_left@2x"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _profileTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    _profileTV.delegate = self;
    _profileTV.dataSource = self;

    _glassView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _glassView.backgroundColor = [UIColor blackColor];
    _glassView.alpha = 0.3;
    _glassView.hidden = YES;
    
    _sixView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kPkViewHeight)];
    _sixView.backgroundColor = [UIColor whiteColor];
    UIPickerView *sixPkView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kPkViewHeight - 40)];
    sixPkView.backgroundColor = [UIColor whiteColor];
    sixPkView.delegate = self;
    sixPkView.dataSource = self;
    sixPkView.tag = 1000;
    
    _birthView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kPkViewHeight)];
    _birthView.backgroundColor = [UIColor whiteColor];
    UIDatePicker *birthDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kPkViewHeight - 40)];
    birthDatePicker.tag = 1001;
    birthDatePicker.datePickerMode = UIDatePickerModeDate;
    [birthDatePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    birthDatePicker.backgroundColor = [UIColor whiteColor];
    [birthDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [headerView addSubview:label];
    [headerView addSubview:leftButton];
    [_backgroundView addSubview:headerView];
    [_birthView addSubview:birthDatePicker];
    [_sixView addSubview:sixPkView];
    
    [self.view addSubview:_backgroundView];
    [self.view addSubview:_profileTV];
    [self.view addSubview:_glassView];
    [self.view addSubview:_birthView];
    [self.view addSubview:_sixView];
    
    [self addHeaderView:_birthView];
    [self addHeaderView:_sixView];
}

- (void)addHeaderView:(UIView *)view
{
    UIView *pkHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    pkHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_background@2x.png"]];
    
    CGFloat MinY = (40 - 30) / 2;
    UIButton *pkHeadLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, MinY, 30, 30)];
    pkHeadLeftBtn.tag = 200;
    [pkHeadLeftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pkHeadLeftBtn setImage:[UIImage imageNamed:@"ic_nav_close@2x"] forState:UIControlStateNormal];
    UIButton *pkHeadRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, MinY, 30, 30)];
    pkHeadRightBtn.tag = 201;
    [pkHeadRightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pkHeadRightBtn setImage:[UIImage imageNamed:@"ic_nav_checkmark@2x"] forState:UIControlStateNormal];
    [pkHeaderView addSubview:pkHeadRightBtn];
    [pkHeaderView addSubview:pkHeadLeftBtn];
    
    [view addSubview:pkHeaderView];
}

- (NSString *)datePickerValueChanged:(UIDatePicker *)datepicker
{
    NSDate *currentDate = datepicker.date;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    NSString *str = [fmt stringFromDate:currentDate];
    
    return str;
}

- (void)btnAction:(UIButton *)sender
{
    if (sender.tag == 200) {
        
        [self pkViewHiddenOpen];
        
    }else if (sender.tag == 201){
        
        [self pkViewHiddenOpen];
        [_profileTV reloadData];
        
        if (_index == 2) {
            
            [_subTitleArray replaceObjectAtIndex:_index withObject:[self datePickerValueChanged:[_birthView viewWithTag:1001]]];
        }
    }else if (sender.tag == 202){
    
        self.tabBarController.tabBar.hidden = NO;
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)pkViewHiddenOpen
{
    CGRect frame = CGRectMake(0, kScreenHeight, kScreenWidth, kPkViewHeight);
    _glassView.hidden = YES;
    switch (_index) {
        case 1:
        {[UIView animateWithDuration:.3 animations:^{
            _sixView.frame = frame;
        }];}
            break;
        case 2:
        {[UIView animateWithDuration:.3 animations:^{
            _birthView.frame = frame;
        }];}
            break;
        default:
            break;
    }
}

- (void)pkViewHiddenClose
{
    CGRect frame = CGRectMake(0, kPkViewHeight + 64, kScreenWidth,  kPkViewHeight);
    if (_index == 1 || _index == 2) {
       
        _glassView.hidden = NO;
        
        switch (_index) {
            case 1:
            {[UIView animateWithDuration:.3 animations:^{
                _sixView.frame = frame;
            }];}
                break;
            case 2:
            {[UIView animateWithDuration:.3 animations:^{
                _birthView.frame = frame;
            }];}
                break;
            default:
                break;
        }
    }
}

- (void)_createLabelArray
{
    _titleArray = @[@"资料头像",@"性别",@"出生日期",@"单位"];
    _pickerArray = @[@"男",@"女"];
    _subTitleArray = [NSMutableArray array];
    NSArray *arr = @[@" ",@" ",@" ",@" "];
    [_subTitleArray addObjectsFromArray:arr];
}

- (void)presentAlertView
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:    UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有可用的摄像头" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alter dismissViewControllerAnimated:YES completion:NULL];
            }];
            [alter addAction:action];
            [self presentViewController:alter animated:YES completion:NULL];
            
            return;
        }
        
        UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
        
        pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        pickVC.delegate = self;
        
        [self presentViewController:pickVC animated:YES completion:NULL];

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"选择现有照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
        
        pickVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        pickVC.allowsEditing = YES;
        
        pickVC.delegate = self;
        
        [self presentViewController:pickVC animated:YES completion:NULL];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _titleArray[indexPath.row];
    
    cell.subTitleLabel.text = _subTitleArray[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"个人详细信息";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath.row;
    [self pkViewHiddenClose];
   
    if (indexPath.row == 0) {
        
        [self presentAlertView];
        [_profileTV reloadData];
    }
    if (indexPath.row == 3) {
        [self.navigationController pushViewController:[[UnitVC alloc] init] animated:YES];
    }
}

#pragma - mark  pickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 60;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *str = _pickerArray[row];
    [_subTitleArray replaceObjectAtIndex:1 withObject:str];
}

#pragma - mark UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSArray *arr = [_profileTV visibleCells];
    CGFloat minY = (((ProfileCell *)arr[0]).frame.size.height - 35) / 2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 50, minY, 35, 35)];
    [((ProfileCell *)arr[0]).contentView addSubview:imageView];

    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage *image = info[UIImagePickerControllerEditedImage];
        
        imageView.image = image;
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
}

@end

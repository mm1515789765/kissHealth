//
//  DrugStoreVC.m
//  KissHealth
//
//  Created by Macx on 16/2/9.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "DrugStoreVC.h"
#import "DrugStoreModel.h"
#import "KHNews.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "KHAnnotationView.h"
#import "KHAnnotation.h"
#import "AnnDetailView.h"

#define kReuseCell @"reuseCell"
#define kButtonSize 50
#define kButtonSpace 10

@interface DrugStoreVC ()<CLLocationManagerDelegate,MKMapViewDelegate>
{
    NSMutableArray *modelsArr;
    
}

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) DrugStoreModel *model;

@end

@implementation DrugStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNaviButton];
    [self creatMapView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"附近药店";
    modelsArr = [NSMutableArray array];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        [self.manager startUpdatingLocation];
    }
    
}

- (void)creatMapView
{
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _mapView.delegate = self;
    //跟踪用户位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    UIButton *rePositionBtn = [[UIButton alloc] initWithFrame:CGRectMake(kButtonSpace, kScreenHeight - kButtonSize - kButtonSpace - 64, kButtonSize, kButtonSize)];
    [rePositionBtn setImage:[UIImage imageNamed:@"ic_location_current"] forState:UIControlStateNormal];
    [rePositionBtn addTarget:self action:@selector(rePostion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mapView];
    [self.view addSubview:rePositionBtn];
    
}

//回到定位点
- (void)rePostion
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.location.coordinate, span);
    [_mapView setRegion:region animated:YES];
}

- (CLLocationManager *)manager
{
    if (_manager == nil)
    {
        _manager = [[CLLocationManager alloc] init];
        //如果没有授权则请求用户授权
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            [_manager requestWhenInUseAuthorization];
        }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
            //设置代理
            _manager.delegate=self;
            //设置定位精度
            _manager.desiredAccuracy=kCLLocationAccuracyBest;
            //定位频率,每隔多少米定位一次
            CLLocationDistance distance=100.0;//百米定位一次
            _manager.distanceFilter=distance;
            //启动跟踪定位
            [_manager startUpdatingLocation];
        }
    }
    return _manager;
}

- (void)creatNaviButton
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_webview_back_normal.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.location = [locations lastObject];
    NSLog(@"location =%f,%f",self.location.coordinate.latitude,self.location.coordinate.longitude);

    //获取位置就停止调用
    [_manager stopUpdatingLocation];
}

- (void)setLocation:(CLLocation *)location
{
    //防止多次网络请求
    BOOL changeLatitude = (location.coordinate.latitude - _location.coordinate.latitude) > 0.01? YES : NO;
    BOOL changeLongitude =  (location.coordinate.longitude - _location.coordinate.longitude) > 0.01? YES : NO;
    if (changeLongitude | changeLatitude)
    {
        _location = location;
        [self requestDrugStoreInfo:location];
    }
}

//根据位置获取周边药店信息
- (void)requestDrugStoreInfo:(CLLocation *)location
{
    KHNews *khNews = [KHNews sharedKHNews];
    NSString *x = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSString *y = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    
    [khNews requestWithURL:@"store/location" params:@{
                                                      @"x":x ,
                                                      @"y":y
                                                      }.mutableCopy
               finishBlock:^(NSDictionary *jsonDic, NSHTTPURLResponse *response, NSError *error) {
                   NSDictionary *infoDic = [jsonDic objectForKey:@"tngou"];
                   if (infoDic)
                   {
                        [self creatModelArr:infoDic];
                   }
               } failBlock:^(NSHTTPURLResponse *response, NSError *error) {
                   
               }];
}

- (void)creatModelArr:(NSDictionary *)infoDic
{
    for (NSDictionary *dic in infoDic)
    {
        DrugStoreModel *model = [[DrugStoreModel alloc] init];
        model.address = dic[@"address"];
        model.name = dic[@"name"];
        model.tel = dic[@"tel"];
        model.img = dic[@"img"];
        model.x = dic[@"x"];
        model.y = dic[@"y"];
        [modelsArr addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self creatAnnotation];
    });
}
//建立大头针模型
- (void)creatAnnotation
{
    for (DrugStoreModel *model in modelsArr)
    {
        KHAnnotation *ann = [[KHAnnotation alloc] init];
        CGFloat latitide = [model.y floatValue];
        CGFloat longitude = [model.x floatValue];
        ann.coordinate = CLLocationCoordinate2DMake(latitide, longitude);
        ann.title = model.name;
        ann.model = model;
        
        [self.mapView addAnnotation:ann];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - mapView delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    _location = userLocation.location;
    
    //反地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = userLocation.location;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error)
        {
            return;
        }
        CLPlacemark *placemark = [placemarks firstObject];
        if (placemark.location)
        {
            userLocation.title = placemark.locality;
        }
        else
        {
            userLocation.title = placemark.administrativeArea;
        }
        userLocation.subtitle = placemark.name;
        
    }];
}


- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString *reuseAnn = @"reuseAnn";
    KHAnnotationView *annView = (KHAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseAnn];
    if (annView == nil)
    {
        annView = [[KHAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:reuseAnn];
        annView.canShowCallout = YES;
    }
    annView.annotation = annotation;
    annView.model = ((KHAnnotation *)annotation).model;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:annView.model.img]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIImage *img = [UIImage imageWithData:data];
            
            annView.detailCalloutAccessoryView = [self creatDetailView:annView.model img:img];
            
        }];
    }];
    
    return annView;
}

//建立大头针详情视图
- (UIView *)creatDetailView:(DrugStoreModel *)model img:(UIImage *)img
{
    AnnDetailView *annDetailView = [[[NSBundle mainBundle] loadNibNamed:@"AnnDetailView" owner:self options:nil] lastObject];
    annDetailView.model = model;
    self.model = annDetailView.model;
    annDetailView.imgView.image = img;
    annDetailView.addressLabel.text = [NSString stringWithFormat:@"地址:%@",model.address];
    annDetailView.addressLabel.numberOfLines = 0;
    
    [annDetailView.naviButton addTarget:self action:@selector(navi) forControlEvents:UIControlEventTouchUpInside];
    if (model.tel.length == 0)
    {
        annDetailView.telLabel.text = @"未获取到电话号码";
    }
    else
    {
        annDetailView.telLabel.text = [NSString stringWithFormat:@"电话:%@",model.tel];
    }
    return annDetailView;
}

//导航
- (void)navi
{
    if (self.model.address.length == 0)
    {
        return;
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:_model.address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error)
        {
            return;
        }
        //取出地标
        CLPlacemark *placemark = [placemarks firstObject];
        MKPlacemark *mkPlacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
        MKMapItem *addItem = [[MKMapItem alloc] initWithPlacemark:mkPlacemark];
        //起点
        MKMapItem *sourceItem = [MKMapItem mapItemForCurrentLocation];
        //开始导航
        NSArray *items = @[sourceItem,addItem];
        NSDictionary *option = @{
                                 MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking,
                                 
                                 };
        [MKMapItem openMapsWithItems:items launchOptions:option];
        
    }];
}

@end

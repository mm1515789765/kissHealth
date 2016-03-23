//
//  KHAnnotationView.h
//  KissHealth
//
//  Created by Macx on 16/2/11.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import <MapKit/MapKit.h>
@class DrugStoreModel;

@interface KHAnnotationView : MKPinAnnotationView<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@property (nonatomic, strong, nullable) DrugStoreModel *model;



@end

//
//  KCAnnotation.h
//  QinWuTong
//
//  Created by ltl on 2019/1/8.
//  Copyright © 2019 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface KCAnnotation : NSObject<MKAnnotation>
//用于在地图上显示定位大头针的类
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

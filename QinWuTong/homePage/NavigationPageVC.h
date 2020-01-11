//
//  NavigationPageVC.h
//  QinWuTong
//
//  Created by ltl on 2018/12/10.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NavigationPageVC : UIViewController
-(void)setLocation:(CLLocation *)location;
@end

NS_ASSUME_NONNULL_END

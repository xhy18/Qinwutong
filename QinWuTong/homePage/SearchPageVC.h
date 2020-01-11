//
//  SearchPageVC.h
//  QinWuTong
//
//  Created by ltl on 2019/1/13.
//  Copyright © 2019 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface SearchPageVC : UIViewController
-(void)setLocation:(CLLocation *)location;
@end

NS_ASSUME_NONNULL_END

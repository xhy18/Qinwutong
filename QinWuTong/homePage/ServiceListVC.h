//
//  ServiceListVC.h
//  QinWuTong
//
//  Created by ltl on 2018/11/30.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface ServiceListVC : UIViewController
-(void)setTitle:(NSString *)title setLocation:(CLLocation *)location;//主页面传入一级目录
-(void)setTitles:(NSString *)first second:(NSString *)second third:(NSString *)third setLocation:(CLLocation *)location;//导航页面传入三级目录
-(void)setTitle:(NSString *)title setArr:(NSMutableArray *)arr;//搜索页面直接传入已获取的数组
@end

NS_ASSUME_NONNULL_END

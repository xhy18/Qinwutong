//
//  ServerPositionVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/7.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "ServerPositionVC.h"
#import "ScanCodeViewController.h"
#import "OrderObj.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KCAnnotation.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface ServerPositionVC ()

@property (nonatomic, retain)MKMapView *mapView;
@property (nonatomic, retain)CLLocationManager *locaManager;
@property (nonatomic, retain)CLGeocoder *geocoder;

//NSString *currentCity;//当前城市
@property (nonatomic, retain)NSString *strlatitude;//经度
@property (nonatomic, retain)NSString *strlongitude;//纬度


@property (nonatomic, retain)OrderObj *order;
@property (nonatomic, retain)NSString *orderId;
@property (nonatomic, retain)NSString *serverId;
@end

@implementation ServerPositionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"当前位置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
//    [self addRightBtn];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"扫码" style:UIBarButtonItemStylePlain target:self action:@selector(toScan)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    //初始化位置管理
    self.locaManager = [[CLLocationManager alloc] init];
    //如果设备在iOS8及以上，得先弹框让用户授权，才能获得定位权限
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [self.locaManager requestWhenInUseAuthorization];
    }
    //设置代理
    self.locaManager.delegate = self;
    //开始定位
    [self.locaManager startUpdatingLocation];
    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(34, 114);
    MKCoordinateSpan span=MKCoordinateSpanMake(10, 10);
    MKCoordinateRegion region=MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region];
    //初始化地图视图
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //设置地图样式为基本样式（这里有三种样式）
    self.mapView.mapType = MKMapTypeStandard;
    //是否显示当前位置
    self.mapView.showsUserLocation = YES;
    //显示比例尺
    self.mapView.showsScale = YES;
    //设置代理
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
//    [self addAnnotation];
//    MKAnnotation *mks =
//    CYXAnnotation *annotation = [[CYXAnnotation alloc] init];
//     annotation.coordinate = self.mapView.centerCoordinate;
//    [self mapView:self.mapView didUpdateUserLocation:<#(MKUserLocation *)#>]
}
-(void)setOrderId:(OrderObj *)obj{
    _order = obj;
    _orderId = obj.orderId;
    _serverId = obj.servicerId;
    [self addAnnotation:_serverId];
}
-(NSDate*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return datenow;
}
-(NSDate*)str2Date:(NSString *)str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //    NSString *dateString = @"2011-05-03 23:11:40";
    NSDate *date = [formatter dateFromString:str];
    return date;
}
- (void)addAnnotation:(NSString *)serverId{
    if(!serverId || [serverId isKindOfClass:[NSNull class]]){
        [MyUtils alertMsg:@"未获取到服务人员id，无法定位服务人员" method:@"addAnnotation" vc:self];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@/qwt/server/Server/showServer",baseUrl];
        NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:serverId,@"serverId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 1){
                //success body
                NSArray *rowsArr = dict[@"data"];
                if([rowsArr count]==0){
                    [MyUtils alertMsg:@"data数组为空，请重试" method:@"getSkillByServicerId" vc:self];
                    return;
                }
                dict = [rowsArr objectAtIndex:0];
                double lat = [[dict objectForKey:@"lat"] doubleValue];
                double lon = [[dict objectForKey:@"lon"] doubleValue];
                NSString *name = [dict objectForKey:@"realname"];
                
//                CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(lon,lat);//暂时，，数据库里经纬度放反了。。。。。
                CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(lat,lon);
                KCAnnotation *annotation1=[[KCAnnotation alloc]init];
                annotation1.title = name;
//                annotation1.subtitle = @"Kenshin Cui's Studios";
                annotation1.coordinate=location1;
                [_mapView addAnnotation:annotation1];
                
//
//                MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);//表示地图展示范围为0.2度经度和纬度
//                MKCoordinateRegion region = MKCoordinateRegionMake(location1.coordinate, span);
//                [_mapView setRegion:region animated:YES];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取服务人员详细信息失败：error:%@",error] method:@"getSkillByServicerId" vc:self];
            }
        } FailureBlock:^(id error) {
            [MyUtils alertMsg:@"请求错误" method:@"getSkillByServicerId" vc:self];
        }];
    });
}

- (void)toScan {
    ScanCodeViewController *vc = [[ScanCodeViewController alloc]init];
    [vc setOrderId:_orderId setServerId:_serverId];
    [self.navigationController pushViewController:vc animated:NO];
}
//-(void)getCoor{
//    //判断定位功能是否打开
//    if ([CLLocationManager locationServicesEnabled]) {
//        _locaManager = [[CLLocationManager alloc]init];
//        _locaManager.delegate = self;
//        [_locaManager requestAlwaysAuthorization];
//        //        currentCity = [NSString new];
//        [_locaManager requestWhenInUseAuthorization];
//
//        //设置寻址精度
//        _locaManager.desiredAccuracy = kCLLocationAccuracyBest;
//        _locaManager.distanceFilter = 5.0;
//        [_locaManager startUpdatingLocation];
//    }
//}
#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [_locaManager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    NSDate *date1 = [self getCurrentTimes];
    NSDate *date2 = [self str2Date:_order.dateExpected];
    NSTimeInterval time = [date1 timeIntervalSinceDate:date2];
    if(time > 1800){
        [MyUtils alertMsg:@"距离预订服务时间超过30分钟，未开启服务人员实时定位功能" method:@"setOrderId" vc:self];
        [_locaManager stopUpdatingLocation];
        return;
    }
    else if(time < -1800){
        [MyUtils alertMsg:@"已超过预订服务时间30分钟，已关闭服务人员实时定位功能" method:@"setOrderId" vc:self];
        [_locaManager stopUpdatingLocation];
        return;
    }
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            
            /*看需求定义一个全局变量来接收赋值*/
//            NSLog(@"----%@",placeMark.country);//当前国家
//            //            NSLog(@"%@",currentCity);//当前的城市
//            NSLog(@"%@",placeMark.subLocality);//当前的位置
//            NSLog(@"%@",placeMark.thoroughfare);//当前街道
//            NSLog(@"%@",placeMark.name);//具体地址
            
        }
    }];
    
}
#pragma mark -- mapViewDelegate

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    NSLog(@"加载完毕");
}
- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
    NSLog(@"将要获取用户位置");
}
#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSString *str = [placemark.addressDictionary valueForKey:@"Name"];
        NSLog(@"详细信息:%@",str);
    }];
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //点击大头针，出现信息
    userLocation.title = @"我的位置";
//    userLocation.subtitle = @"dingjianjaja";
    //让地图视图转移到用户当前位置
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    //设置精度，以及显示用户所在地
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);//表示地图展示范围为0.2度经度和纬度
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    [mapView setRegion:region animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_locaManager stopUpdatingLocation];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

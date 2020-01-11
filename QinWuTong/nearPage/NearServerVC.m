//
//  NearServerVC.m
//  QinWuTong
//
//  Created by ltl on 2018/11/19.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "NearServerVC.h"
#import "ServiceListCell.h"
#import "ServicerInfoVC.h"
#import "ServicerObj.h"
#import "CDZStarsControl.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface NearServerVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *serviceList;
}


//@property (nonatomic, retain)MKMapView *mapView;
@property (nonatomic, retain)CLLocationManager *locaManager;
@property (nonatomic, retain)CLGeocoder *geocoder;

@property (nonatomic) NSMutableArray *servicers;
@end

@implementation NearServerVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIColor *themeColor =[UIColor colorWithRed:216/255.0 green:30/255.0 blue:6/255.0 alpha:1.0];//主色调D81E06
    self.navigationItem.title = @"附近服务";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
//    CGFloat topOffset = statusBarFrame.size.height+navigationHeight;
    CGFloat topOffset = 0;
    
    //-------------------以下代码及Collection的相关重写方法均复制自NearServerVC，页面布局也一致
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    serviceList = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    serviceList.frame = CGRectMake(0, topOffset, SCREEN_WIDTH,SCREEN_HEIGHT-topOffset);
    //    serviceList.backgroundColor = [UIColor grayColor];
    [self.view addSubview:serviceList];
    serviceList.backgroundColor = grayBgColor;
    [serviceList registerClass:[ServiceListCell class] forCellWithReuseIdentifier:@"serviceCell"];
    
    [serviceList registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    serviceList.delegate = self;
    serviceList.dataSource = self;
    
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
//    [self getServicersByDistance];
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [_locaManager stopUpdatingLocation];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@/qwt/server/Server/showServerByDistance",baseUrl];
        NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:currentLocation.coordinate.longitude],@"lon",
                                  [NSNumber numberWithFloat:currentLocation.coordinate.latitude],@"lat",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //            NSLog(jsonData);
            NSArray *rowsArr = d[@"data"];
            self.servicers = @[].mutableCopy;
            for(NSDictionary *dict in rowsArr){
                ServicerObj *servicer = [ServicerObj new];
                servicer.name = [dict objectForKey:@"realname"];
                servicer.phone = [dict objectForKey:@"phoneNum"];
                servicer.servicerId = [dict objectForKey:@"userId"];
                servicer.sourse = [dict objectForKey:@"sourse"];
                servicer.score = [dict objectForKey:@"avgscore"];
                servicer.distance = [dict objectForKey:@"distance"];
                servicer.skillToShow = [dict objectForKey:@"skill"];
                servicer.lat = [dict objectForKey:@"lat"];
                servicer.lon = [dict objectForKey:@"lon"];
                [_servicers addObject:servicer];
            }
            if([_servicers count]== 0){
                [MyUtils alertMsg:@"未找到3km内的服务人员" method:@"getServicersByDistance" vc:self];
            }
            else
                [serviceList reloadData];
        } FailureBlock:^(id error) {
            [MyUtils alertMsg:@"获取附近服务人员失败" method:@"getServicersByDistance" vc:self];
        }];
    });
    
}
//-(void)getServicersByDistance{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *url = [NSString stringWithFormat:@"%@/qwt/server/Server/showServerByDistance",baseUrl];
//        NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                  [NSNumber numberWithInt:60],@"lat",
//                                  [NSNumber numberWithInt:100],@"lon",nil];
//
//        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
//            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//            //            NSLog(jsonData);
//            NSArray *rowsArr = d[@"data"];
//            self.servicers = @[].mutableCopy;
//            for(NSDictionary *dict in rowsArr){
//                ServicerObj *servicer = [ServicerObj new];
//                servicer.name = [dict objectForKey:@"realname"];
//                servicer.phone = [dict objectForKey:@"phoneNum"];
//                servicer.servicerId = [dict objectForKey:@"userId"];
//                servicer.sourse = [dict objectForKey:@"sourse"];
//                servicer.score = [dict objectForKey:@"avgscore"];
//                servicer.distance = [dict objectForKey:@"distance"];
//                servicer.skillToShow = [dict objectForKey:@"skill"];
//                servicer.lat = [dict objectForKey:@"lat"];
//                servicer.lon = [dict objectForKey:@"lon"];
//                [_servicers addObject:servicer];
//            }
//            if([_servicers count]== 0){
//                [ErrorAlertVC showError:@"未找到3km内的服务人员" method:@"getServicersByDistance" vc:self];
//            }
//            else
//                [serviceList reloadData];
//        } FailureBlock:^(id error) {
//            [ErrorAlertVC showError:@"获取附近服务人员失败" method:@"getServicersByDistance" vc:self];
//        }];
//    });
//}
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_servicers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ServiceListCell *c =(ServiceListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"serviceCell" forIndexPath:indexPath];
    ServicerObj *so = [_servicers objectAtIndex:indexPath.row];
    if([_servicers count]==0)
        return c;
    //    if(!so)
    //        NSLog(@"ServiceListVC:collectionCell布局函数：空指针异常");
    c.name.text = so.name;
    c.distance.text = [NSString stringWithFormat:@"%.1fkm",[so.distance floatValue]];
    //    long t1 = [so.phone longLongValue];
    //    NSNumber *longNumber = [NSNumber numberWithLong:t1];
    //    NSString *longStr = [longNumber stringValue];
    c.tel.text = [[NSNumber numberWithLong:[so.phone longLongValue]] stringValue];//嵌套的就是上面三行
    c.services.text = so.skillToShow;
    c.servicerId = so.servicerId;
    c.photo.image = [UIImage imageNamed:@"logo.png"];
    c.address.text = @"西安市太白南路2号西安电子科技大学";
    c.starsControl.score = [so.score floatValue];
    c.backgroundColor = [UIColor whiteColor];
    return c;
    
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.bounds.size.width, 110);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ServiceListCell *cell = (ServiceListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ServicerObj *obj = [_servicers objectAtIndex:indexPath.row];
    ServicerInfoVC *vc = [[ServicerInfoVC alloc] init];
    [vc setServicerId:obj.servicerId setLat:[obj.lat doubleValue] setLon:[obj.lon doubleValue]];
    [self.navigationController pushViewController:vc animated:NO];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
//    [self getServicersByDistance];
    [self.locaManager startUpdatingLocation];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
//    self.tabBarController.tabBar.hidden=YES;
//    self.navigationController.navigationBarHidden = YES;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    self.tabBarController.tabBar.hidden = YES;
////    self.navigationController.navigationBarHidden = NO;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

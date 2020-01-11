//
//  ServiceListVC.m
//  QinWuTong
//
//  Created by ltl on 2018/11/30.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "ServiceListVC.h"
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
@interface ServiceListVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *serviceList;
}
@property (nonatomic, retain)NSString *pageTitle;
@property (nonatomic) NSMutableArray *servicers;

@property (nonatomic) CLLocation *location;
//@property (nonatomic, retain)MKMapView *mapView;
@property (nonatomic, retain)CLLocationManager *locaManager;
@property (nonatomic, retain)CLGeocoder *geocoder;
@property (nonatomic, retain)NSString *addressTmp;//设置个全局变量用于传值。。。
@end

@implementation ServiceListVC
/*
 服务人员的列表，根据分类获取服务人员list
 */
- (void)viewDidLoad {
    [super viewDidLoad];
//    CGFloat topOffset = statusBarFrame.size.height+navigationHeight;
    CGFloat topOffset = 0;
    self.navigationItem.title = _pageTitle;
//    [self getServicers];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
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

}


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
    
    c.photo.image = [UIImage imageNamed:@"icon_default_head.png"];
    c.address.text = [self getAddressByLat:[so.lat doubleValue] lon:[so.lon doubleValue]];
//    c.address.text = @"西安市太白南路2号西安电子科技大学";
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
    if (!cell.servicerId || [cell.servicerId isKindOfClass:[NSNull class]])
        return;
    ServicerObj *obj = [_servicers objectAtIndex:indexPath.row];
    ServicerInfoVC *vc = [[ServicerInfoVC alloc] init];
    if(cell.servicerId)
    [vc setServicerId:obj.servicerId setLat:[obj.lat doubleValue] setLon:[obj.lon doubleValue]];
    [self.navigationController pushViewController:vc animated:NO];
}

-(NSString *)getAddressByLat:(double)lat lon:(double)lon{
    _addressTmp = nil;
    CLLocation *location = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    NSLog(@"%f,%f",location.coordinate.latitude,location.coordinate.longitude);
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *addressToShow = placeMark.locality;
            if (!addressToShow)
                addressToShow = @"无法定位当前城市";
            else
                addressToShow = placeMark.name;
            _addressTmp = addressToShow;
        }
    }];
    if([MyUtils isBlankString:_addressTmp] || _addressTmp.length == 0)
        return @"(未获取到用户地址)";
    return _addressTmp;
}

-(void)setTitle:(NSString *)title setLocation:(CLLocation *)location{
    _pageTitle = title;
    _location = location;
    [self getServicersByFirstSkills];
}
-(void)setTitles:(NSString *)first second:(NSString *)second third:(NSString *)third setLocation:(CLLocation *)location{
    _pageTitle = third;
    _location = location;
    [self getServicersByAllSkills:first second:second];
}
-(void)setTitle:(NSString *)title setArr:(NSMutableArray *)arr{
    _pageTitle = title;
//    _location = location;
    _servicers = arr;
    [serviceList reloadData];
//    [self getServicersBySkills];
}

-(void)getServicersRequest:(NSDictionary *)dic{
    NSString *url = [NSString stringWithFormat:@"%@/qwt/server/Server/showServerBySkill",baseUrl];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:dic SuccessBlock:^(id responseObject) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[d objectForKey:@"code"]integerValue];
            if(res == 1){
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
                if([_servicers count]== 0)
                    [MyUtils alertMsg:@"未找到该分类下的服务人员" method:@"getServicersBySkills" vc:self];
                else
                    [serviceList reloadData];
            }
            else{
                NSString *error = [d objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取服务人员列表失败：error:%@",error] method:@"getServicersRequest" vc:self];
            }
        } FailureBlock:^(id error) {
            [MyUtils alertMsg:@"请求错误" method:@"getServicersRequest" vc:self];
        }];
    });
}
-(void)getServicersByFirstSkills{
    NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              _pageTitle,@"skill1",
                              [NSNumber numberWithFloat:_location.coordinate.longitude],@"lon",
                              [NSNumber numberWithFloat:_location.coordinate.latitude],@"lat",nil];
    [self getServicersRequest:num_dic];
}
-(void)getServicersByAllSkills:(NSString *)first second:(NSString *)second{
    NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              first,@"skill1",
                              second,@"skill2",
                              _pageTitle,@"skill3",
                              [NSNumber numberWithFloat:_location.coordinate.longitude],@"lon",
                              [NSNumber numberWithFloat:_location.coordinate.latitude],@"lat",nil];
    [self getServicersRequest:num_dic];
}


//进入页面时显示顶部导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden=NO;
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

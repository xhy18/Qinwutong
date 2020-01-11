//
//  SecondPage.m
//  QinWuTong
//
//  Created by ltl on 2018/11/19.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "SecondPage.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
#import "CDZStarsControl.h"

//#import "ctlUnit/StarUtils/CDZStarsControl.h"

#import "Constants.h"

#import "SkillObj.h"

#import <AVFoundation/AVFoundation.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SecondPage ()<CDZStarsControlDelegate, CLLocationManagerDelegate,MKMapViewDelegate>

//@property (nonatomic, strong) CDZStarsControl *starsControl;
@property (nonatomic) NSMutableArray *skills;
@property (nonatomic , strong)CDZStarsControl *starsControl;

@property (nonatomic, retain)MKMapView *mapView;
@property (nonatomic, retain)CLLocationManager *locaManager;
@property (nonatomic, retain)CLGeocoder *geocoder;

//NSString *currentCity;//当前城市
@property (nonatomic, retain)NSString *strlatitude;//经度
@property (nonatomic, retain)NSString *strlongitude;//纬度


@property (nonatomic, retain)UIImageView *img;//经度


@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation SecondPage

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"fewfwe";
    self.navigationItem.title = @"测试页";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    
//    img.image
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    _img = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
    [_img setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_img];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage) object:nil];
    [operationQueue addOperation:op];
    
//
//    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//        if (granted) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self loadScanView];
//            });
//        } else {
//            NSLog(@"无权限访问相机");
//        }
//    }];
    
    
//    self.starsControl = [[CDZStarsControl alloc] initWithFrame:CGRectMake(140,40,16*5,16) stars:5 starSize:CGSizeMake(16, 16) noramlStarImage:[UIImage imageNamed:@"star_normal"] highlightedStarImage:[UIImage imageNamed:@"star_highlighted"]];
////    [self.view addSubview:self.starsControl];
//    //    _starsControl.score =[self.shop_detail.shop.score floatValue];
//    _starsControl.allowFraction = YES;
//    [self getSkillByServicerId];

//    CGFloat frameWidth = self.view.bounds.size.width;
//    UILabel *tlbl = [[UILabel alloc]initWithFrame:CGRectMake(10, statusBarFrame.size.height+navigationHeight, 48, [[UIScreen mainScreen] bounds].size.height-ToolBarHeight-statusBarFrame.size.height-navigationHeight-5)];
//    tlbl.backgroundColor = [UIColor grayColor];
//
//    _starsControl = [CDZStarsControl.alloc initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 20) / 8 - 10, 65 + 30, ([UIScreen mainScreen].bounds.size.width - 20) / 4 , 12) stars:5 starSize:CGSizeMake(12, 12) noramlStarImage:[UIImage imageNamed:@"star_normal"] highlightedStarImage:[UIImage imageNamed:@"star_highlighted"]];
//    //_starsControl.backgroundColor = [UIColor redColor];
//    _starsControl.delegate = self;
//    _starsControl.userInteractionEnabled = YES;
//    _starsControl.allowFraction = NO;
//    _starsControl.score = 3.6f;//初始化分数
//    [self.view addSubview:_starsControl];


     //位置管理类
    //创建管理器对象
//    self.locationManager = [[AMapLocationManager alloc] init];//设置精度[self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];//设置定位超时时间self.locationManager.locationTimeout = 10;//设置反地理编码超时时间self.locationManager.reGeocodeTimeout = 10;

}

- (void)downloadImage
{
    NSURL *imageUrl = [NSURL URLWithString:@"http://qinwutong-app-1258058303.cos.ap-chengdu.myqcloud.com/8722ba87-7bec-470f-bd73-95c9d2d84b74.png"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    _img.image = image;
}




//
//-(void)getCoor{
//    //判断定位功能是否打开
//    if ([CLLocationManager locationServicesEnabled]) {
//        _locaManager = [[CLLocationManager alloc]init];
//        _locaManager.delegate = self;
//        [_locaManager requestAlwaysAuthorization];
////        currentCity = [NSString new];
//        [_locaManager requestWhenInUseAuthorization];
//
//        //设置寻址精度
//        _locaManager.desiredAccuracy = kCLLocationAccuracyBest;
//        _locaManager.distanceFilter = 5.0;
//        [_locaManager startUpdatingLocation];
//    }
//}
//#pragma mark 定位成功后则执行此代理方法
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
//{
//    [_locaManager stopUpdatingHeading];
//    //旧址
//    CLLocation *currentLocation = [locations lastObject];
//    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
//    //打印当前的经度与纬度
//    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
//
//    //反地理编码
//    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count > 0) {
//            CLPlacemark *placeMark = placemarks[0];
////            currentCity = placeMark.locality;
////            if (!currentCity) {
////                currentCity = @"无法定位当前城市";
////            }
////
//            /*看需求定义一个全局变量来接收赋值*/
//            NSLog(@"----%@",placeMark.country);//当前国家
////            NSLog(@"%@",currentCity);//当前的城市
//                        NSLog(@"%@",placeMark.subLocality);//当前的位置
//                        NSLog(@"%@",placeMark.thoroughfare);//当前街道
//                        NSLog(@"%@",placeMark.name);//具体地址
//
//        }
//    }];
//
//}
//#pragma mark -- mapViewDelegate
//
//- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
//    NSLog(@"加载完毕");
//}
//- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
//    NSLog(@"将要获取用户位置");
//}
//#pragma mark 根据坐标取得地名
//-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
//    //反地理编码
//    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
//    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *placemark=[placemarks firstObject];
//        NSString *str = [placemark.addressDictionary valueForKey:@"Name"];
//        NSLog(@"详细信息:%@",str);
//    }];
//}
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    //点击大头针，出现信息
//    userLocation.title = @"丁健";
//    userLocation.subtitle = @"dingjianjaja";
//    //让地图视图转移到用户当前位置
//    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//    //设置精度，以及显示用户所在地
//    MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);//比例尺为1：10^5,1厘米代表1公里
//    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
//    [mapView setRegion:region animated:YES];
//}
//tableview画圆角矩形的背景
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell respondsToSelector:@selector(tintColor)]) {
//        //        if (tableView == self.tableView) {
//        CGFloat cornerRadius = 10.f;
//        cell.backgroundColor = UIColor.clearColor;
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
//        BOOL addLine = NO;
//        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//        } else if (indexPath.row == 0) {
//
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//            addLine = YES;
//
//        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//        } else {
//            CGPathAddRect(pathRef, nil, bounds);
//            addLine = YES;
//        }
//        layer.path = pathRef;
//        CFRelease(pathRef);
//        //颜色修改
//        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.5f].CGColor;
//        layer.strokeColor=[UIColor blackColor].CGColor;
//        if (addLine == YES) {
//            CALayer *lineLayer = [[CALayer alloc] init];
//            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
//            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
//            [layer addSublayer:lineLayer];
//        }
//        UIView *testView = [[UIView alloc] initWithFrame:bounds];
//        [testView.layer insertSublayer:layer atIndex:0];
//        testView.backgroundColor = UIColor.clearColor;
//        cell.backgroundView = testView;
//    }
//}
//
//- (void)loadScanView {
//    //获取摄像设备
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    //创建输入流
//    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//    //创建输出流
//    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
//    //设置代理 在主线程里刷新
//    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//
//    //初始化链接对象
//    self.session = [[AVCaptureSession alloc]init];
//    //高质量采集率
//    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
//
//    [self.session addInput:input];
//    [self.session addOutput:output];
//
//    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,//二维码
//                                 //以下为条形码，如果项目只需要扫描二维码，下面都不要写
//                                 AVMetadataObjectTypeEAN13Code,
//                                 AVMetadataObjectTypeEAN8Code,
//                                 AVMetadataObjectTypeUPCECode,
//                                 AVMetadataObjectTypeCode39Code,
//                                 AVMetadataObjectTypeCode39Mod43Code,
//                                 AVMetadataObjectTypeCode93Code,
//                                 AVMetadataObjectTypeCode128Code,
//                                 AVMetadataObjectTypePDF417Code];
//
//    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
//    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    layer.frame = self.view.layer.bounds;
//    [self.view.layer insertSublayer:layer atIndex:0];
//    //开始捕获
//    [self.session startRunning];
//}
//-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
//    if (metadataObjects.count>0) {
//        [self.session stopRunning];
//        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
//
//        NSLog(@"%@",metadataObject.stringValue);
//    }
//}
////链接：https://www.jianshu.com/p/2dcb6dc75cd8





//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//[defaults stringForKey:@"userId"]





//处理数据编码
//NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//NSString *res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//[self.navigationController popViewControllerAnimated:YES];//返回上一页
//[self.navigationController popToRootViewControllerAnimated:YES];//返回首页
//.textAlignment = NSTextAlignmentCenter;
//.font = [UIFont systemFontOfSize:18];
//arc4random()%256
//[btn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
//[btn addTarget:self action:@selector(launchClick) forControlEvents:UIControlEventTouchUpInside];
//[btn setTitle:@"登陆" forState:UIControlStateNormal];
//[NSString stringWithFormat:@"%@/app/client/appUser/login", baseUrl]
//NSString *strUrl = [urlString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//[ErrorAlertVC showError:@"未找到该分类下的服务人员" method:@"getServicersBySkills" vc:self];
//高德地图key【5e2b618357e8eebf7949d78e2c999424】
//判断字符串为空
//+  (BOOL)isBlankString:(NSString *)aStr {
//    if (!aStr) {
//        return YES;
//    }
//    if ([aStr isKindOfClass:[NSNull class]]) {
//        return YES;
//    }
//    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
//    if (!trimmedStr.length) {
//        return YES;
//    }
//    return NO;
//}


//if (!c.remark.text || [c.remark.text isKindOfClass:[NSNull class]] || c.remark.text.length == 0)
//    so.remark = @"";
//else
//    so.remark = c.remark.text;



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)alert{
    _starsControl.score = 5;
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"上传失败，请重新上传" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end

//
//  ScanCodeViewController.m
//  scanmiam
//
//  Created by 秦焕 on 2018/6/18.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "ScanCodeViewController.h"

#import <AVFoundation/AVFoundation.h>
//#include "TableViewController.h"
//#include "lineViewController.h"
//#import "WebViewController.h"
//#import "ToolHeader.h"
#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) AVCaptureDevice * device;
@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, weak) UIImageView * line;
@property (nonatomic, assign) NSInteger distance;


@property (nonatomic, retain)NSString *orderId;
@property (nonatomic, retain)NSString *serverId;
@end

@implementation ScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫码确认上门";
    
    //初始化信息
    [self initInfo];
    
    //创建控件
    [self creatControl];
    
    //设置参数
    [self setupCamera];
    
    //添加定时器
    [self addTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
   // [self stopScanning];
}

- (void)initInfo
{
    //backgroundcolor
    self.view.backgroundColor = [UIColor whiteColor];
    
    //navigation title
//    self.navigationItem.title = @"QR Code";
    
    //导航右侧相册按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"photo" style:UIBarButtonItemStylePlain target:self action:@selector(photoBtnOnClick)];
}
//创建控件
- (void)creatControl
{
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
    CGFloat scanW = KMainW * 0.65;
    CGFloat padding = 10.0f;    //label用的时候往右挪10
    CGFloat labelH = 22.0f;     //The QR code can be ...height那行字的高度
  //  CGFloat tabBarH = 64.0f;    // 可扩展的选项栏高度
    CGFloat cornerW = 26.0f;
    CGFloat marginX = (KMainW - scanW) * 0.5;
    CGFloat marginY = (KMainH - scanW - padding - labelH) * 0.2;

    //遮盖视图
    for (int i = 0; i < 4; i++) {
        UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, (marginY + scanW) * i, KMainW, marginY + (KMainH-marginY-scanW)  * i)];
        if (i == 2 || i == 3) {
            cover.frame = CGRectMake((marginX + scanW) * (i - 2), marginY, marginX, scanW);
        }
        cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self.view addSubview:cover];
    }
    //这段代码很精辟，当i=0时，是框的上方。i=1时，是框的下方。i=2时，是框的左边。i=3时，是框的右边

    //扫描视图
    UIView *scanView = [[UIView alloc] initWithFrame:CGRectMake(marginX, marginY, scanW, scanW)];
    [self.view addSubview:scanView];
    
    //扫描线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scanW, 2)];
    [self drawLineForImageView:line]; //？
    [scanView addSubview:line]; //将线添加到框里面
    self.line = line;   //？
    
    //边框
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scanW, scanW)];
    borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    borderView.layer.borderWidth = 1.0f;
    [scanView addSubview:borderView];   //给扫描视图加上边框，边框设置颜色和宽度即可
    
    //扫描视图四个角
    for (int i = 0; i < 4; i++) {
        CGFloat imgViewX = (scanW - cornerW) * (i % 2);
        CGFloat imgViewY = (scanW - cornerW) * (i / 2);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, imgViewY, cornerW, cornerW)];
        if (i == 0 || i == 1) {
            imgView.transform = CGAffineTransformRotate(imgView.transform, M_PI_2 * i);
        }else {
            imgView.transform = CGAffineTransformRotate(imgView.transform, - M_PI_2 * (i - 1));
        }
        [self drawImageForImageView:imgView];
        [scanView addSubview:imgView];
    }
    
    //提示标签 okay，y的坐标确定？
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scanView.frame) + padding, KMainW, labelH)];
    label.text = @"请将二维码放在扫码框内";
    label.font = [UIFont systemFontOfSize:18.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];

    UIView * background_view = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-80, SCREEN_WIDTH, 80)];
    background_view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:background_view];
    //开启照明按钮  okay
    UIButton * photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH-120)/3)*2+60,10, 60, 60)];
    [photoBtn setImage:[UIImage imageNamed:@"相册.png"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photoBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [background_view addSubview:photoBtn];
    
    UIButton *lightBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-120)/3, 10, 60, 60)];
    lightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [lightBtn setImage:[UIImage imageNamed:@"手电筒.png"] forState:UIControlStateNormal];
    
    [lightBtn addTarget:self action:@selector(lightBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [background_view addSubview:lightBtn];
}

- (void)setupCamera
{
    //二维码扫描功能的实现步骤是创建好回话对象，用来获取从硬件设备输入的数据，并实时显示在界面上，在扫描到形影图像数据的时候，通过AVCaptureVideoPreviewLayer类型进行返回
    //1、创建设备会话对象，用来设置设备数据输入
//    2、获取摄像头，并且将摄像头对象加入当前会话中
//    3、实时获取摄像头原始数据显示在屏幕上
//    4、扫描到二维码/条形码数据，通过协议方法回调
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //初始化相机设备
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //初始化输入流
        //AVCaptureDeviceInput 设备输入类。这个类用来表示输入数据的硬件设备，配置抽象设备的port
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        //初始化输出流
        //AVCaptureMetadataOutput输出类。这个支持二维码、条形码等图像数据的识别
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        //设置代理，主线程刷新  设置好扫描成功回调代理以及回调线程
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        //AVCaptureSession 会话对象。此类作为硬件设备输入输出信息的桥梁，承担实时获取设备数据的责任
        self.session= [[AVCaptureSession alloc] init];
        //高质量采集率
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([self.session canAddInput:input]) [self.session addInput:input];
        if ([self.session canAddOutput:output]) [self.session addOutput:output];
        
        //条码类型（二维码/条形码）
        output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
        
        //更新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            //AVCaptureVideoPreviewLayer图层类。用来快速呈现摄像头获取的原始数据
            self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.preview.frame = CGRectMake(0, 0, KMainW, KMainH);
            [self.view.layer insertSublayer:self.preview atIndex:0];
            [self.session startRunning];
        });
    });
}

- (void)addTimer
{
    _distance = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    if (_distance++ > KMainW * 0.65) _distance = 0;
    _line.frame = CGRectMake(0, _distance, KMainW * 0.65, 2);
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

//照明按钮点击事件
- (void)lightBtnOnClick:(UIButton *)btn
{
    if(!_device.hasTorch){
        [self showAlertWithTitle:@"This device has no light" message:nil sureHandler:nil cancelHandler:nil];
        return;
    }
   
    btn.selected = !btn.selected;
    [_device lockForConfiguration:nil];
    if(btn.selected){
        [_device setTorchMode:AVCaptureTorchModeOn];
    }else{
        [_device setTorchMode:AVCaptureTorchModeOff];
    }
}

//进入相册
- (void)photoBtnOnClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    }else {
        [self showAlertWithTitle:@"当前设备不支持访问相册" message:nil sureHandler:nil cancelHandler:nil];
    }
}

-(void)setOrderId:(NSString *)orderId setServerId:(NSString *)serverId{
    _orderId = orderId;
    _serverId = serverId;
}
-(NSDate*)str2Date:(NSString *)str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    NSString *dateString = @"2011-05-03 23:11:40";
    NSDate *date = [formatter dateFromString:str];
    return date;
}
-(NSDate*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return datenow;
}
-(void)checkCode:(NSString *)strFormCode{
    NSArray *errorMsg = [NSArray arrayWithObjects:@"orderId",@"serverId",@"dateTime",nil];
//    NSArray *time1 = [[self getCurrentTimes] componentsSeparatedByString:@"#"];
    NSDate *date1 = [self getCurrentTimes];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr1 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",_orderId],
                     [NSString stringWithFormat:@"%@",_serverId],date1,nil];
    NSArray *arr2 = [strFormCode componentsSeparatedByString:@"#"];
    if([arr1 count] != [arr2 count]){
        [MyUtils alertMsg:@"二维码格式错误！" method:@"checkCode" vc:self];
        return;
    }
    int error = -1;
    for(int i=0;i<[arr1 count]-1;i++){//比较orderId和serverId，第3个元素是date类型，不写入for循环
        if(![[arr2 objectAtIndex:i] isEqualToString:[arr1 objectAtIndex:i]]){
            error = i;
            [MyUtils debugMsg:[NSString stringWithFormat:@"\n二维码校验发现%@不一致:\n%@ %@",[errorMsg objectAtIndex:i],
                                    [arr2 objectAtIndex:i],[arr1 objectAtIndex:i]] vc:self];
        }
    }
    NSDate *date2 = [self str2Date:[arr2 objectAtIndex:2]];
    NSTimeInterval time = [date1 timeIntervalSinceDate:date2];
    if(time > 600){//10min
        [MyUtils alertMsg:@"二维码超时，请重新生成" method:@"checkCode" vc:self];
        return;
    }
    if(error < 0){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [NSString stringWithFormat:@"%@",[defaults stringForKey:@"userId"]    ],@"userId",
                             [NSString stringWithFormat:@"%@",_orderId],@"orderId",nil];
//        [ErrorAlertVC testUrl:dic];
//        return;
        NSLog(@"%@,%@",[defaults stringForKey:@"userId"],[NSString stringWithFormat:@"%@",_orderId]);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appOrder/inService", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                int res = [[dict objectForKey:@"code"]integerValue];
                if(res == 0){
                    //success body
                    NSLog(@"修改状态为 服务中 成功jason:%@",responseObject);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    self.tabBarController.selectedIndex = 2;
                }
                else{
                    NSString *error = [dict objectForKey:@"error"];
                    [MyUtils alertMsg:@"二维码校验正确但修改状态失败" method:@"checkCode" vc:self];
                }
            } FailureBlock:^(id error){
                [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误error:%@",error] method:@"checkCode" vc:self];
            }
             ];
        });
    }
    else{
        [MyUtils alertMsg:[NSString stringWithFormat:@"二维码校验失败！%d\n%@",error,strFormCode] method:@"checkCode" vc:self];
//        [ErrorAlertVC showError:[NSString stringWithFormat:@"%@\n",strFormCode] method:@"checkCode" vc:self];
    }
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描完成
    if ([metadataObjects count] > 0) {
        //停止扫描
        [self stopScanning];
        NSString * scanInfo = [[metadataObjects firstObject] stringValue];
//        NSLog(@"array = %@",scan_information);
        NSArray * scanInfoArray = [scanInfo componentsSeparatedByString:@"#"];
        [self checkCode:scanInfo];
//        NSLog(@"array = %@",scan_info_array);
//        [ErrorAlertVC showError:scanInfo method:@"showAlertWithTitle" vc:self];
    }
}

- (void)stopScanning
{
    [_session stopRunning];
    _session = nil;
    [_preview removeFromSuperlayer];
    [self removeTimer];
}

#pragma mark - UIImagePickerControllrDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //获取相册图片
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        //识别图片
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        
        //识别结果
        if (features.count > 0) {
            //在这里对扫描结果进行处理

            [self showAlertWithTitle:@"扫描结果" message:[[features firstObject] messageString] sureHandler:nil cancelHandler:nil];


        }else{
            [self showAlertWithTitle:@"没有识别到二维码或条形码" message:nil sureHandler:nil cancelHandler:nil];
        }
    }];
}

//提示弹窗
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message sureHandler:(void (^)())sureHandler cancelHandler:(void (^)())cancelHandler
{
    
    NSArray * scan_info_array = [message componentsSeparatedByString:@"#"];
    [MyUtils alertMsg:message method:@"showAlertWithTitle" vc:self];
}
//绘制角图片  no
- (void)drawImageForImageView:(UIImageView *)imageView
{
    UIGraphicsBeginImageContext(imageView.bounds.size);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(context, 6.0f);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    //路径
    CGContextBeginPath(context);
    //设置起点坐标
    CGContextMoveToPoint(context, 0, imageView.bounds.size.height);
    //设置下一个点坐标
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, imageView.bounds.size.width, 0);
    //渲染，连接起点和下一个坐标点
    CGContextStrokePath(context);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

//绘制线图片  no
- (void)drawLineForImageView:(UIImageView *)imageView
{
    CGSize size = imageView.bounds.size;  //线的宽、高
    UIGraphicsBeginImageContext(size);
    //创建一个基于位图的上下文，并将其设置为当前上下文
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建一个颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //设置开始颜色
    const CGFloat *startColorComponents = CGColorGetComponents([[UIColor greenColor] CGColor]);
    //设置结束颜色
    const CGFloat *endColorComponents = CGColorGetComponents([[UIColor whiteColor] CGColor]);
    //颜色分量的强度值数组
    CGFloat components[8] = {startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]
    };
    //渐变系数数组
    CGFloat locations[] = {0.0, 1.0};
    //创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    //绘制渐变
    CGContextDrawRadialGradient(context, gradient, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.25, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.5, kCGGradientDrawsBeforeStartLocation);
    //释放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end

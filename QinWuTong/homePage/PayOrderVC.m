//
//  PayOrderVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/22.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "PayOrderVC.h"
#import <AlipaySDK/AlipaySDK.h>

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface PayOrderVC ()

@property(strong, nonatomic) UIButton *selectAlipay;
@property(strong, nonatomic) UIButton *selectWechat;
@property(nonatomic) long *orderId;
@property(nonatomic) bool homeFee;
@end

@implementation PayOrderVC

- (void)viewDidLoad {
    self.navigationItem.title = @"支付订单";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    //添加监听事件，用于从支付宝回调函数中返回并执行页面跳转功能
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toOrderList) name:@"paySuccess" object:nil];
    
    CGFloat topOffset = 0;
    //  CGFloat topOffset = statusBarFrame.size.height+navigationHeight+5;
    UIImageView *orderSuccessImg = [[UIImageView alloc] init];
    orderSuccessImg.image = [UIImage imageNamed:@"alipay.png"];
    orderSuccessImg.frame = CGRectMake(SCREEN_WIDTH/2-40, topOffset+40, 80, 80);
    UILabel *orderSuccess = [[UILabel alloc]initWithFrame:CGRectMake(0, orderSuccessImg.frame.origin.y+orderSuccessImg.frame.size.height+3, SCREEN_WIDTH, 20)];
    orderSuccess.text = @"下 单 成 功";
    orderSuccess.textAlignment = NSTextAlignmentCenter;
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, orderSuccess.frame.origin.y+orderSuccess.frame.size.height+20, SCREEN_WIDTH , 1)];
    line2.backgroundColor = grayBgColor;
    
    [self.view addSubview:orderSuccessImg];
    [self.view addSubview:orderSuccess];
    [self.view addSubview:line2];
    
    UIImageView *alipayIcon = [[UIImageView alloc] init];
    alipayIcon.image = [UIImage imageNamed:@"alipay.ico"];
    alipayIcon.frame = CGRectMake(10, line2.frame.origin.y+line2.frame.size.height+20, 40, 40);
    _selectAlipay = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, alipayIcon.frame.origin.y+5, 30, 30)];
    [_selectAlipay setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    [_selectAlipay addTarget:self action:@selector(toAlipay:) forControlEvents:UIControlEventTouchUpInside];
    _selectAlipay.selected = true;
    UILabel *alipayLbl = [[UILabel alloc]initWithFrame:CGRectMake(alipayIcon.frame.origin.x+alipayIcon.frame.size.width+5, alipayIcon.frame.origin.y+5, 200, 30)];
    alipayLbl.text = @"支付宝支付";
    alipayLbl.font = [UIFont systemFontOfSize:20];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, alipayIcon.frame.origin.y+alipayIcon.frame.size.height+3, SCREEN_WIDTH , 1)];
    line.backgroundColor = grayBgColor;
    [self.view addSubview:alipayIcon];
    [self.view addSubview:alipayLbl];
    [self.view addSubview:_selectAlipay];
    [self.view addSubview:line];
    
    UIImageView *wechatIcon = [[UIImageView alloc] init];
    wechatIcon.image = [UIImage imageNamed:@"alipay.ico"];
    wechatIcon.frame = CGRectMake(10, line.frame.origin.y+4, 40, 40);
    _selectWechat = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, wechatIcon.frame.origin.y+5, 30, 30)];
    [_selectWechat setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [_selectWechat addTarget:self action:@selector(toWechat:) forControlEvents:UIControlEventTouchUpInside];
    _selectWechat.selected = false;
    UILabel *wechatLbl = [[UILabel alloc]initWithFrame:CGRectMake(wechatIcon.frame.origin.x+wechatIcon.frame.size.width+5, wechatIcon.frame.origin.y+5, 200, 30)];
    wechatLbl.text = @"支付宝支付";
    wechatLbl.font = [UIFont systemFontOfSize:20];
    
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, wechatIcon.frame.origin.y+wechatIcon.frame.size.height+3, SCREEN_WIDTH , 1)];
    line3.backgroundColor = grayBgColor;
    
    [self.view addSubview:line3];
    [self.view addSubview:wechatIcon];
    [self.view addSubview:wechatLbl];
    [self.view addSubview:_selectWechat];
    
    UIButton *payOrder = [[UIButton alloc]initWithFrame:CGRectMake(10, wechatLbl.frame.origin.y+wechatLbl.frame.size.height+30, SCREEN_WIDTH-10*2, 40)];
    [payOrder setTitle:@"前 往 支 付" forState:UIControlStateNormal];
    payOrder.titleLabel.textColor = textColorOnBg;
    payOrder.titleLabel.font = [UIFont systemFontOfSize:28];
    payOrder.backgroundColor = themeColor;
    payOrder.layer.cornerRadius = 4;
    [payOrder addTarget:self action:@selector(payForOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payOrder];
    

//    [back addTarget:self action:@selector(launchClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:back];
}

-(void)toOrderList{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 2;
}
-(void)dealloc{
//    NSLog(@"1231234");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"paySuccess" object:nil];
}
-(void)setOrderId:(long)orderId isHomeFee:(bool)homeFee{
//    NSLog(@"%d",orderId);
    _orderId = orderId;
    _homeFee = homeFee;
}

-(void)toAlipay:(UIButton *)btn{
    [_selectAlipay setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    [_selectWechat setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    _selectAlipay.selected = true;
    _selectWechat.selected = false;
}
-(void)toWechat:(UIButton *)btn{
    [_selectAlipay setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [_selectWechat setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    _selectAlipay.selected = false;
    _selectWechat.selected = true;
}

-(void)payForOrder:(UIButton *)btn{
//    if(_selectAlipay.selected){
    if(true){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",
                                 [NSNumber numberWithLong:_orderId],@"orderId",
                                 [NSNumber numberWithFloat:2],@"payWay",
                                 @"",@"payPwd",
                                 nil];
            NSString *urlStr = [NSString stringWithFormat:@"%@/app/client/appOrder/%@", baseUrl, _homeFee?@"book":@"pay"];//支付两个费用使用的是2个api，使用问号表达式拼接。
//            if(!_homeFee){
//                NSLog(apiStr);
//            }
            [DIYAFNetworking PostHttpDataWithUrlStr:urlStr Dic:dic SuccessBlock:^(id responseObject){
                NSLog(@"获取支付信息成功jason:%@",responseObject);
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//                            NSLog(jsonData);
                int res = [[d objectForKey:@"code"]integerValue];
                if(res == 0){
                    NSString *t;
                    t = responseObject[@"data"];
                    NSLog(t);
                    NSString *fromScheme = @"com.Ios.QinWuTong";
                    [[AlipaySDK defaultService] payOrder:t fromScheme:fromScheme callback:^(NSDictionary* resultDic) {
                        
                        NSLog(@"%@",resultDic);
                        if ([resultDic[@"resultStatus"] intValue] == 9000) {
                            [MyUtils alertMsg:@"支付成功" method:@"payForOrder" vc:self];
                        }else{
                            [MyUtils alertMsg:@"支付失败或取消" method:@"payForOrder" vc:self];
                        }
                        
                    }];
                }
                else{
                    NSString *error = [d objectForKey:@"error"];
                    NSLog(@"payForOrder: %d",_orderId);
                    [MyUtils alertMsg:[NSString stringWithFormat:@"获取支付所需信息失败：error:%@",error] method:@"payForOrder" vc:self];
                }
            } FailureBlock:^(id error){
                [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"payForOrder" vc:self];
            }];
        });
    }
}


//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    if ([url.host isEqualToString:@"safepay"]) {
//        // 支付跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//        
//        // 授权跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            // 解析 auth code
//            NSString *result = resultDic[@"result"];
//            NSString *authCode = nil;
//            if (result.length>0) {
//                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                for (NSString *subResult in resultArr) {
//                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
//                        break;
//                    }
//                }
//            }
//            NSLog(@"授权结果 authCode = %@", authCode?:@"");
//        }];
//    }
//    return YES;
//}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    if ([url.host isEqualToString:@"safepay"]) {
//        // 支付跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//        
//        // 授权跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            // 解析 auth code
//            NSString *result = resultDic[@"result"];
//            NSString *authCode = nil;
//            if (result.length>0) {
//                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                for (NSString *subResult in resultArr) {
//                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
//                        break;
//                    }
//                }
//            }
//            NSLog(@"授权结果 authCode = %@", authCode?:@"");
//        }];
//    }
//    return YES;
//}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden=NO;
//}

@end

//
//  PayPageVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/16.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "PayPageVC.h"

#import "LMPopInputPasswordView.h"

#import <AlipaySDK/AlipaySDK.h>

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface PayPageVC ()<LMPopInputPassViewDelegate>
{
    LMPopInputPasswordView *popView;//这是一个6位数字密码输入框的轮子
}

@property(nonatomic) int type;//0-支付上门费；1-支付服务费；2-钱包充值
@property(nonatomic) long *orderId;//支付上门费和服务费时可用
@property(nonatomic) float amount;//钱包充值时使用
@property(nonatomic) int payWay;//1-微信；2-Alipay；3-钱包（与api对应）

@property(strong, nonatomic) NSString *tip;
@property(strong, nonatomic) NSString *payPwd;



@property(strong, nonatomic) UIButton *selectAlipay;
@property(strong, nonatomic) UIButton *selectWechat;
@property(strong, nonatomic) UIButton *selectWallet;
@end

@implementation PayPageVC

/*本来是不同支付场景用不同的VC来控制，但是支付宝的回调触发在一个函数中，然后就改成了这个集成的支付页面
 1先通过setType方法，设置是哪一个支付场景
 2根据传入的tip和充值金额或者订单号参数调整界面上的label信息
 3通过界面选择支付方式
 4点击支付按钮，进入支付环节：alipay使用byAlipay方法，钱包支付直接在请求中完成
 4.1判断type，调用不同的url，并组装不同的参数dic
 4.2钱包支付需要弹出密码输入框，密码存放在payPwd参数中；非钱包字段该参数为空串；空串也会发送给后台
 4.3通过请求，后台将根据支付方式，返回封装在字符串中的数据；钱包支付不需要数据
 5成功后调用afterSuccess方法处理页面跳转
 5.1支付宝的回调在AppDelegate.m中，通过通知的方式返回到该方法
 5.2钱包支付直接调用afterSuccess
 6完了还要注销通知：在dealloc中去处理
 */
- (void)initFrame {
    _payPwd = @"";
//    CGFloat topOffset = 0;
    CGFloat topOffset = statusBarFrame.size.height+navigationHeight+5;
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"icon_logo.jpg"];
    imgView.frame = CGRectMake(SCREEN_WIDTH/2-70, topOffset+40, 140, 140);
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+3, SCREEN_WIDTH, 28)];
    tipLabel.text = _tip;
    tipLabel.font = [UIFont systemFontOfSize:24];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, tipLabel.frame.origin.y+tipLabel.frame.size.height+3, SCREEN_WIDTH, 20)];
    lbl.text = @"请选择支付方式";
    lbl.textColor = textColorGray;
    lbl.textAlignment = NSTextAlignmentCenter;
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lbl.frame.origin.y+lbl.frame.size.height+10, SCREEN_WIDTH , 1)];
    line2.backgroundColor = grayBgColor;
    
    [self.view addSubview:imgView];
    [self.view addSubview:tipLabel];
//    [self.view addSubview:line2];
    
    UIImageView *alipayIcon = [[UIImageView alloc] init];
    alipayIcon.image = [UIImage imageNamed:@"alipay.ico"];
    alipayIcon.frame = CGRectMake(20, line2.frame.origin.y+line2.frame.size.height+5, 40, 40);
    _selectAlipay = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, alipayIcon.frame.origin.y+5, 30, 30)];
    [_selectAlipay setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    [_selectAlipay addTarget:self action:@selector(changeBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    _selectAlipay.selected = true;
    _selectAlipay.tag = 1;
    _payWay = 2;
    UILabel *alipayLbl = [[UILabel alloc]initWithFrame:CGRectMake(alipayIcon.frame.origin.x+alipayIcon.frame.size.width+5, alipayIcon.frame.origin.y+5, 200, 30)];
    alipayLbl.text = @"支付宝支付";
    alipayLbl.font = [UIFont systemFontOfSize:20];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, alipayIcon.frame.origin.y+alipayIcon.frame.size.height+3, SCREEN_WIDTH-30 , 1)];
    line.backgroundColor = grayBgColor;
    [self.view addSubview:alipayIcon];
    [self.view addSubview:alipayLbl];
    [self.view addSubview:_selectAlipay];
    [self.view addSubview:line];
    
    UIImageView *wechatIcon = [[UIImageView alloc] init];
    wechatIcon.image = [UIImage imageNamed:@"alipay.ico"];
    wechatIcon.frame = CGRectMake(20, line.frame.origin.y+4, 40, 40);
    _selectWechat = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, wechatIcon.frame.origin.y+5, 30, 30)];
    [_selectWechat setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [_selectWechat addTarget:self action:@selector(changeBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    _selectWechat.selected = false;
    _selectWechat.tag = 2;
    UILabel *wechatLbl = [[UILabel alloc]initWithFrame:CGRectMake(wechatIcon.frame.origin.x+wechatIcon.frame.size.width+5, wechatIcon.frame.origin.y+5, 200, 30)];
    wechatLbl.text = @"微信支付";
    wechatLbl.font = [UIFont systemFontOfSize:20];

    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(15, wechatIcon.frame.origin.y+wechatIcon.frame.size.height+3, SCREEN_WIDTH-30 , 1)];
    line3.backgroundColor = grayBgColor;
    [self.view addSubview:line3];
    [self.view addSubview:wechatIcon];
    [self.view addSubview:wechatLbl];
    [self.view addSubview:_selectWechat];
    
    
    UIImageView *walletIcon = [[UIImageView alloc] init];
    walletIcon.image = [UIImage imageNamed:@"coin.png"];
    walletIcon.frame = CGRectMake(20, line3.frame.origin.y+4, 40, 40);
    _selectWallet = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, walletIcon.frame.origin.y+5, 30, 30)];
    [_selectWallet setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [_selectWallet addTarget:self action:@selector(changeBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    _selectWallet.selected = false;
    _selectWallet.tag = 3;
    UILabel *walletLbl = [[UILabel alloc]initWithFrame:CGRectMake(walletIcon.frame.origin.x+walletIcon.frame.size.width+5, walletIcon.frame.origin.y+5, 200, 30)];
    walletLbl.text = @"钱包支付";
    walletLbl.font = [UIFont systemFontOfSize:20];
    
    UILabel *line4 = [[UILabel alloc]initWithFrame:CGRectMake(15, walletIcon.frame.origin.y+walletIcon.frame.size.height+3, SCREEN_WIDTH-30, 1)];
    line4.backgroundColor = grayBgColor;
    
    if(_type == 2){//钱包充值时不能使用钱包支付
        line4.frame = CGRectMake(0, line3.frame.origin.y, 0, 0);
    }
    else{
        [self.view addSubview:line4];
        [self.view addSubview:walletIcon];
        [self.view addSubview:walletLbl];
        [self.view addSubview:_selectWallet];
    }
    
    UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, line4.frame.origin.y+25, SCREEN_WIDTH-10*2, 40)];
    [payBtn setTitle:@"前 往 支 付" forState:UIControlStateNormal];
    payBtn.titleLabel.textColor = textColorOnBg;
    payBtn.titleLabel.font = [UIFont systemFontOfSize:28];
    payBtn.backgroundColor = themeColor;
    payBtn.layer.cornerRadius = 4;
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
}
- (void)byAliPay:(NSString *)payOrder {
    NSString *fromScheme = @"com.Ios.QinWuTong";
    [[AlipaySDK defaultService] payOrder:payOrder fromScheme:fromScheme callback:^(NSDictionary* resultDic) {
        
        NSLog(@"%@",resultDic);
        if ([resultDic[@"resultStatus"] intValue] == 9000) {
            [MyUtils alertMsg:@"支付成功" method:@"payForOrder" vc:self];
        }else{
            [MyUtils alertMsg:@"支付失败或取消" method:@"payForOrder" vc:self];
        }
        
    }];
}
-(void)byWechat{
    [MyUtils alertMsg:@"暂不支持微信支付" method:@"byWechat" vc:self];
}
- (void)payMethod {
    NSString *urlStr;
    NSDictionary *dic;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (_type) {
        case 0:
            urlStr = [NSString stringWithFormat:@"%@/app/client/appOrder/book", baseUrl];
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",
                   [NSNumber numberWithLong:_orderId],@"orderId",
                   [NSNumber numberWithInt:_payWay],@"payWay",
                   _payPwd,@"payPwd",
                   nil];
            break;
        case 1:
            urlStr = [NSString stringWithFormat:@"%@/app/client/appOrder/pay", baseUrl];
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",
                   [NSNumber numberWithLong:_orderId],@"orderId",
                   [NSNumber numberWithInt:_payWay],@"payWay",
                   _payPwd,@"payPwd",
                   nil];
            break;
        case 2:
            urlStr = [NSString stringWithFormat:@"%@/app/client/appUser/recharge", baseUrl];
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",
                   [NSNumber numberWithInt:_payWay],@"payWay",
                   [NSNumber numberWithFloat:_amount],@"money",
                   nil];
            break;
        default:
            [MyUtils alertMsg:@"type参数错误！" method:@"pay" vc:self];
            return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [DIYAFNetworking PostHttpDataWithUrlStr:urlStr Dic:dic SuccessBlock:^(id responseObject){
            NSLog(@"请求成功jason:%@",responseObject);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //                            NSLog(jsonData);
            int res = [[d objectForKey:@"code"]integerValue];
            if(res == 0){
                NSString *t = responseObject[@"data"];
//                                NSLog(t);
                if(_payWay == 2)
                    [self byAliPay:t];
                else if(_payPwd == 1)
                    [self byWechat];
                else if(_payWay == 3)
                    [self afterSuccess];
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

-(void)payBtnClick{
    if(_payWay == 3)
        [self showInputView];//呼出输支付密码界面，并修改_payPwd
    else
        [self payMethod];
}
//支付成功后根据不同支付场景跳转到不同的页面
-(void)afterSuccess{
    if(_type == 0 || _type == 1){//支付订单的上门费和服务费，返回订单页面
        [self.navigationController popToRootViewControllerAnimated:NO];
        self.tabBarController.selectedIndex = 2;
    }
    else if(_type == 3){//钱包充值返回上一页
        [self.navigationController popViewControllerAnimated:NO];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"支付订单";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    //添加监听事件，用于从支付宝回调函数中返回并执行页面跳转功能
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterSuccess) name:@"paySuccess" object:nil];
    
    //涉及LMPopInputPasswordView
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}
//选中不同支付方式后界面的变化
-(void)changeBtnSelect:(UIButton *)btn{
    if(btn.tag == 1){
        [_selectAlipay setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        _payWay = 2;
        _selectAlipay.selected = true;
    }
    else{
        [_selectAlipay setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        _selectAlipay.selected = false;
    }
    if(btn.tag == 2){
        [_selectWechat setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        _payWay = 1;
        _selectWechat.selected = true;
    }
    else{
        [_selectWechat setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        _selectWechat.selected = false;
    }
    if(btn.tag == 3){
        [_selectWallet setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        _payWay = 3;
        _selectWallet.selected = true;
    }
    else{
        [_selectWallet setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        _selectWallet.selected = false;
    }
}

//处理支付上门费和服务费
-(void)setType:(int)type setId:(long)orderId tip:(NSString *)tip{
    _type = type;
    _tip = tip;
    _orderId = orderId;
    [self initFrame];
}
//处理钱包充值
-(void)setAmount:(int)amount tip:(NSString *)tip{
    _tip = tip;
    _type = 2;
    _amount = amount;
    if(debugMode)
        _amount = 0.01;//测试呢，省点钱
    [self initFrame];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)dealloc{
    //    NSLog(@"1231234");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"paySuccess" object:nil];
    
    //涉及LMPopInputPasswordView
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

//=====================github上找的输入密码框==================
- (IBAction)showInputView {
    popView = [[LMPopInputPasswordView alloc]init];
    popView.frame = CGRectMake((self.view.frame.size.width - 300)*0.5, 150, 300, 150);
    popView.delegate = self;
    [popView pop];
}

#pragma mark ---LMPopInputPassViewDelegate
-(void)buttonClickedAtIndex:(NSUInteger)index withText:(NSString *)text
{
    NSLog(@"buttonIndex = %li password=%@",(long)index,text);
    if(index==1){
        if(text.length==0){
            NSLog(@"密码长度不正确");
        }else if(text.length<6){
            NSLog(@"密码长度不正确");
        }
        else{
            _payPwd = text;
            [self payMethod];
        }
    }
}

-(void)deviceOrientationDidChange:(NSObject*)sender{
    UIDevice* device = [sender valueForKey:@"object"];
    if(device.orientation==UIInterfaceOrientationLandscapeLeft||device.orientation==UIInterfaceOrientationLandscapeRight)
    {
        popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, 50, 250, 150);
    }
    else if(device.orientation==UIInterfaceOrientationPortrait||device.orientation==UIInterfaceOrientationPortraitUpsideDown)
    {
        popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, 50, 250, 150);
    }
}
//==========================================================
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

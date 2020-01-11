//
//  WalletVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/16.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "WalletVC.h"
#import "SetPayPswdVC.h"
#import "RechargeOrCashVC.h"
#import "AccountLosVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface WalletVC ()

@property (nonatomic, strong)UILabel *numLbl;
@end

@implementation WalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的钱包";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(showLos)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    int coinWid = 100;
    UIImageView *coin = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-coinWid)/2, 140, coinWid, coinWid)];
    coin.image = [UIImage imageNamed:@"coin.png"];
    [self.view addSubview:coin];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, coin.frame.origin.y+coin.frame.size.height+10, SCREEN_WIDTH, 28)];
    title.text = @"零钱余额";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:24];
    _numLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, title.frame.origin.y+title.frame.size.height+10, SCREEN_WIDTH, 32)];
//    _numLbl.text = @"零钱余额";
    _numLbl.textAlignment = NSTextAlignmentCenter;
    _numLbl.font = [UIFont systemFontOfSize:28];
    [self.view addSubview:title];
    [self.view addSubview:_numLbl];
    
    UIButton *recharge= [[UIButton alloc]initWithFrame:CGRectMake(10, _numLbl.frame.origin.y+_numLbl.frame.size.height+20, SCREEN_WIDTH-10*2, 50)];
    [recharge setTitle:@"充  值" forState:UIControlStateNormal];
    recharge.titleLabel.textColor = textColorOnBg;
    recharge.titleLabel.font = [UIFont systemFontOfSize:32];
    recharge.backgroundColor = themeColor;
    recharge.layer.cornerRadius = 4;
    [recharge addTarget:self action:@selector(toRecharge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recharge];
    
    UIButton *getCash= [[UIButton alloc]initWithFrame:CGRectMake(10, recharge.frame.origin.y+recharge.frame.size.height+10, SCREEN_WIDTH-10*2, 50)];
    [getCash setTitle:@"账户明细" forState:UIControlStateNormal];
    [getCash setTitleColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0] forState:UIControlStateNormal];
    getCash.titleLabel.font = [UIFont systemFontOfSize:32];
    getCash.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    getCash.layer.cornerRadius = 4;
    [getCash addTarget:self action:@selector(showLos) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCash];
    // Do any additional setup after loading the view.
}
-(void)showLos{
    AccountLosVC*vc = [[AccountLosVC alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)toRecharge{
    RechargeOrCashVC *vc = [[RechargeOrCashVC alloc]init];
    [vc isRecharge:true];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)toGetCash{
    RechargeOrCashVC *vc = [[RechargeOrCashVC alloc]init];
    [vc isRecharge:false];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)getWallet{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appUser/selectWallet", baseUrl]Dic:dic SuccessBlock:^(id responseObject){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[d objectForKey:@"code"]integerValue];
            if(res == 0){
                if([MyUtils isBlankString:responseObject[@"data"][@"payPwd"]]){
                    [self alert:self error:@"未设置支付密码"];
//                    [MyUtils alertMsg:@"未设置支付密码" method:@"getWallet" vc:self];
                    return;
                }
                _numLbl.text = [NSString stringWithFormat:@"￥%.2f",[responseObject[@"data"][@"account"]floatValue]];
            }
            else{
                NSString *error = [d objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取零钱信息失败：error:%@",error] method:@"getWallet" vc:self];
            }
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"getWallet" vc:self];
        }];
    });
}
//提示需要设置支付密码，点击确定跳转至页面
-(void)alert:(UIViewController *)vc error:(NSString *)error{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SetPayPswdVC *vc = [[SetPayPswdVC alloc]init];
        [vc isFirstSetPswd:true];
        [self.navigationController pushViewController:vc animated:NO];
    }];
    [alert addAction:sureAction];
    [vc presentViewController:alert animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getWallet];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBarHidden = NO;
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

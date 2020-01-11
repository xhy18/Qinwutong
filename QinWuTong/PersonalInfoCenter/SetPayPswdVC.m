//
//  SetPayPswdVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/16.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "SetPayPswdVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface SetPayPswdVC ()

@property(strong, nonatomic) UILabel *pswLbl;
@property(strong, nonatomic) UILabel *pswLbl2;
@property(strong, nonatomic) UITextField *psw;
@property(strong, nonatomic) UITextField *psw2;

@property(nonatomic) bool *isFirstSetPswd;
@end

@implementation SetPayPswdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置支付密码";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    [self.navigationItem setHidesBackButton:YES];//隐藏返回按钮，如果是因为未设置密码强制跳转进来的，返回还会触发强制跳转
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0,30, SCREEN_WIDTH, 30)];
    tip.text = @"请输入由6位数字构成的支付密码";
    tip.textAlignment = NSTextAlignmentCenter;
    tip.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:tip];
    CGFloat tfHeight = 40;
    _pswLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, tip.frame.origin.y+tip.frame.size.height+20, 80, tfHeight)];
    _pswLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(15, _pswLbl.frame.origin.y+_pswLbl.frame.size.height+15, 80, tfHeight)];
    _psw = [[UITextField alloc]initWithFrame:CGRectMake(95, _pswLbl.frame.origin.y+tfHeight*0.1, SCREEN_WIDTH-120, tfHeight*0.8)];
    _psw2 = [[UITextField alloc]initWithFrame:CGRectMake(95, _pswLbl2.frame.origin.y+tfHeight*0.1, SCREEN_WIDTH-120, tfHeight*0.8)];
    _psw.backgroundColor = tfBgColor;
    _psw2.backgroundColor = tfBgColor;
    _psw.borderStyle = UITextBorderStyleRoundedRect;
    _psw.secureTextEntry = YES;
    _psw2.borderStyle = UITextBorderStyleRoundedRect;
    _psw2.secureTextEntry = YES;
    _pswLbl.text = @"密码";
    _pswLbl.textAlignment = NSTextAlignmentCenter;
    _pswLbl.font = [UIFont systemFontOfSize:18];
    _pswLbl2.text = @"再次输入";
    _pswLbl2.textAlignment = NSTextAlignmentCenter;
    _pswLbl2.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_pswLbl];
    [self.view addSubview:_pswLbl2];
    [self.view addSubview:_psw];
    [self.view addSubview:_psw2];
    _psw.keyboardType = UIKeyboardTypeNumberPad;
    _psw2.keyboardType = UIKeyboardTypeNumberPad;
    
    
    UIButton *btn= [[UIButton alloc]initWithFrame:CGRectMake(10, _pswLbl2.frame.origin.y+_pswLbl2.frame.size.height+25, SCREEN_WIDTH-10*2, 40)];
    [btn setTitle:@"提  交" forState:UIControlStateNormal];
    btn.titleLabel.textColor = textColorOnBg;
    btn.titleLabel.font = [UIFont systemFontOfSize:28];
    btn.backgroundColor = themeColor;
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    UIButton *cancel= [[UIButton alloc]initWithFrame:CGRectMake(10, btn.frame.origin.y+btn.frame.size.height+15, SCREEN_WIDTH-10*2, 40)];
//    [cancel setTitle:@"取  消" forState:UIControlStateNormal];
//    [cancel setTitleColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0] forState:UIControlStateNormal];
//    cancel.titleLabel.font = [UIFont systemFontOfSize:28];
//    cancel.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
//    cancel.layer.cornerRadius = 4;
//    [cancel addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancel];
    // Do any additional setup after loading the view.
}
-(void)submit{
    NSString *pswd = self->_psw.text;
    if(pswd.length !=6){
        [MyUtils alertMsg:@"密码限定为6位数字密码，请重新输入" method:@"submit" vc:self];
        return;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[pswd componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if (![pswd isEqualToString:filtered]){
        [MyUtils alertMsg:@"密码中含有非数字字符，请重新输入" method:@"submit" vc:self];
        return;
    }
    if(pswd.length == 0 || [MyUtils isBlankString:self->_psw.text]){
        [MyUtils alertMsg:@"请输入密码" method:@"submit" vc:self];
        return;
    }
    if(pswd != self->_psw2.text){
        [MyUtils alertMsg:@"两次输入的密码不相同" method:@"submit" vc:self];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@/app/client/appUser/%@", baseUrl,_isFirstSetPswd?@"setPayPwd":@"updatePayPwd"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [defaults stringForKey:@"userId"],@"userId",pswd,@"payPwd",nil];
        //13488309249  13345627894
        [DIYAFNetworking PostHttpDataWithUrlStr:url Dic:dic SuccessBlock:^(id responseObject){
            NSLog(@"json:%@",responseObject);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 0){
                [self.navigationController popViewControllerAnimated:YES];
                [MyUtils alertMsg:@"设置成功" method:@"submit" vc:self];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"设置失败：error:%@",error] method:@"submit" vc:self];
            }
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误：error:%@",error] method:@"submit" vc:self];
            //                    NSLog(@"登录失败：error:%@",error);
        }];
    });
}
//对于初次设置密码，点击放弃将返回个人中心；修改密码将返回“我的钱包”
-(void)back{
    if(_isFirstSetPswd){
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 3;
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}
-(void)isFirstSetPswd:(bool)tag{
    _isFirstSetPswd = tag;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
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

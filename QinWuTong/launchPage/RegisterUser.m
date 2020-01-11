//
//  RegisterUser.m
//  QinWuTong
//
//  Created by ltl on 2018/11/29.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "RegisterUser.h"
#import "Constants.h"
#import "LoginPageVC.h"
#import "ViewController.h"

#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface RegisterUser ()
@property(strong, nonatomic) UILabel *userLbl;
@property(strong, nonatomic) UILabel *pswLbl;
@property(strong, nonatomic) UILabel *pswLbl2;
@property(strong, nonatomic) UITextField *username;
@property(strong, nonatomic) UITextField *psw;
@property(strong, nonatomic) UITextField *psw2;
@property(strong, nonatomic) UIButton *isPersonal;
@property(strong, nonatomic) UIButton *isCompany;
@property(strong, nonatomic) NSString *belongTo;
@end

@implementation RegisterUser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat topOffset = 10;//自顶部向下的偏移量
    UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    bgLabel.backgroundColor = themeColor;
    UILabel *pageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, topOffset+10, SCREEN_WIDTH, 40)];
    pageTitle.textAlignment = NSTextAlignmentCenter;
    pageTitle.text = @"用户登录";
    pageTitle.backgroundColor = themeColor;
    pageTitle.textColor = [UIColor whiteColor];
    pageTitle.font = [UIFont boldSystemFontOfSize:titleFontSize];
    [self.view addSubview:bgLabel];
    [self.view addSubview:pageTitle];
    
    
    CGFloat tfHeight = 40;
//    dataSource=@[@"用户名",@"密码"];
    UILabel *inputBg = [[UILabel alloc]init];
    inputBg.frame = CGRectMake(10, topOffset+60, SCREEN_WIDTH-20, 3*tfHeight+21);
    inputBg.layer.cornerRadius = 5;
    inputBg.layer.masksToBounds = YES;
    inputBg.layer.borderWidth = 1;
    [self.view addSubview:inputBg];
    
    _userLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, topOffset+65, 80, tfHeight)];
    _pswLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, topOffset+70+tfHeight, 80, tfHeight)];
    _pswLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(15, topOffset+75+2*tfHeight, 80, tfHeight)];
    _username = [[UITextField alloc]initWithFrame:CGRectMake(95, topOffset+65+tfHeight*0.1, SCREEN_WIDTH-120, tfHeight*0.8)];
    _psw = [[UITextField alloc]initWithFrame:CGRectMake(95, topOffset+70+tfHeight*1.1, SCREEN_WIDTH-120, tfHeight*0.8)];
    _psw2 = [[UITextField alloc]initWithFrame:CGRectMake(95, topOffset+75+tfHeight*2.1, SCREEN_WIDTH-120, tfHeight*0.8)];
    CGFloat gray = 245;
    _username.backgroundColor = [UIColor colorWithRed:gray/255.0 green:gray/255.0 blue:gray/255.0 alpha:1.0];
    _psw.backgroundColor = [UIColor colorWithRed:gray/255.0 green:gray/255.0 blue:gray/255.0 alpha:1.0];
    _psw2.backgroundColor = [UIColor colorWithRed:gray/255.0 green:gray/255.0 blue:gray/255.0 alpha:1.0];
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _psw.borderStyle = UITextBorderStyleRoundedRect;
    _psw.secureTextEntry = YES;
    _psw2.borderStyle = UITextBorderStyleRoundedRect;
    _psw2.secureTextEntry = YES;
    _userLbl.text = @"用户名";
    _userLbl.textAlignment = NSTextAlignmentCenter;
    _userLbl.font = [UIFont systemFontOfSize:18];
    _pswLbl.text = @"密码";
    _pswLbl.textAlignment = NSTextAlignmentCenter;
    _pswLbl.font = [UIFont systemFontOfSize:18];
    _pswLbl2.text = @"再次输入";
    _pswLbl2.textAlignment = NSTextAlignmentCenter;
    _pswLbl2.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_userLbl];
    [self.view addSubview:_pswLbl];
    [self.view addSubview:_pswLbl2];
    [self.view addSubview:_username];
    [self.view addSubview:_psw];
    [self.view addSubview:_psw2];
    
    _isPersonal = [[UIButton alloc]initWithFrame:CGRectMake(20, _pswLbl2.frame.origin.y+_pswLbl2.frame.size.height+12, 24, 24)];
    [_isPersonal setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    UILabel *isPersonalLbl = [[UILabel alloc]initWithFrame:CGRectMake(_isPersonal.frame.origin.x+_isPersonal.frame.size.width+5, _isPersonal.frame.origin.y, 80, 24)];
    _isPersonal.tag = 10;
    _belongTo = @"10";
    isPersonalLbl.text = @"个人用户";
    [_isPersonal addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_isPersonal];
    [self.view addSubview:isPersonalLbl];
    _isCompany = [[UIButton alloc]initWithFrame:CGRectMake(isPersonalLbl.frame.origin.x+isPersonalLbl.frame.size.width+20, _isPersonal.frame.origin.y, 24, 24)];
    [_isCompany setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    UILabel *isCompanyLbl = [[UILabel alloc]initWithFrame:CGRectMake(_isCompany.frame.origin.x+_isCompany.frame.size.width+5, _isCompany.frame.origin.y, 80, 24)];
    _isCompany.tag = 20;
    isCompanyLbl.text = @"企业用户";
    [_isCompany addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_isCompany];
    [self.view addSubview:isCompanyLbl];
    
    UIButton *registerBtn= [[UIButton alloc]initWithFrame:CGRectMake(10, _isPersonal.frame.origin.y+_isPersonal.frame.size.height+8, SCREEN_WIDTH-10*2, 40)];
    [registerBtn setTitle:@"注 册" forState:UIControlStateNormal];
    registerBtn.titleLabel.textColor = textColorOnBg;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:28];
    registerBtn.backgroundColor = themeColor;
    registerBtn.layer.cornerRadius = 4;
    [registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *cancel= [[UIButton alloc]initWithFrame:CGRectMake(10, registerBtn.frame.origin.y+registerBtn.frame.size.height+10, SCREEN_WIDTH-10*2, 40)];
    [cancel setTitle:@"返回登录" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:28];
    cancel.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    cancel.layer.cornerRadius = 4;
    [cancel addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
}
-(void)back{
    LoginPageVC *vc = [[LoginPageVC alloc]init];
    UIApplication.sharedApplication.delegate.window.rootViewController = vc;
}
-(void)btnClick:(UIButton *)btn{
    if(btn.tag == 10){
        _isPersonal.selected = YES;
        _isCompany.selected = NO;
        [_isPersonal setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        [_isCompany setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        _belongTo = @"10";
    }
    else{
        _isCompany.selected = YES;
        _isPersonal.selected = NO;
        [_isPersonal setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [_isCompany setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        _belongTo = @"20";
    }
}
//在textfield中输入弹出键盘后，点击背景收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)registerClick{
    if(self->_psw.text.length == 0 || [MyUtils isBlankString:self->_psw.text]){
        [MyUtils alertMsg:@"请输入密码" method:@"registerClick" vc:self];
        return;
    }
    if(self->_psw.text != self->_psw2.text){
        [MyUtils alertMsg:@"两次输入的密码不相同" method:@"registerClick" vc:self];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self->_username.text,@"phone",self->_psw.text,@"pwd",_belongTo,@"belongTo",nil];
        [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appUser/register", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 0){
                NSLog(@"json:%@",responseObject);
                
                //直接执行登录功能
                ViewController *vc = [[ViewController alloc]init];
                UIApplication.sharedApplication.delegate.window.rootViewController = vc;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:responseObject[@"data"][@"userID"] forKey:@"userId"];
                [defaults setObject:responseObject[@"data"][@"username"] forKey:@"userName"];
                [defaults setObject:responseObject[@"data"][@"belongTo"] forKey:@"userName"];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"注册失败：error:%@",error] method:@"registerClick" vc:self];
            }
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误：error:%@",error] method:@"registerClick" vc:self];
        }];
    });
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

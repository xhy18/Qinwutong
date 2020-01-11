//
//  LaunchPageVC.m
//  QinWuTong
//
//  Created by ltl on 2018/11/28.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "LoginPageVC.h"
#import "ViewController.h"
#import "RegisterUser.h"
#import "ForgetPswd.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface LoginPageVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    //最初想用一个CollectionView的3个section实现页面；改用3个Collection后沿用了section的命名
    UICollectionView *collectionView;
    NSArray *dataSource;
}

@property(strong, nonatomic) UILabel *userLbl;
@property(strong, nonatomic) UILabel *pswLbl;
@property(strong, nonatomic) UITextField *username;
@property(strong, nonatomic) UITextField *psw;
@property(strong, nonatomic) UIButton *toRegister;
@property(strong, nonatomic) UIButton *forgetPsw;
@property(strong, nonatomic) UILabel *split;


@property(strong, nonatomic) UILabel *errorLbl;
@property(nonatomic) bool *hadLogin;
@end

@implementation LoginPageVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _hadLogin = false;
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
//    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 60, frameWidth, 60)];
//    tf.text = @"test";
//    [self.view addSubview:tf];
    

    CGFloat ftHeight = 40;
    dataSource=@[@"用户名",@"密码"];
    UILabel *inputBg = [[UILabel alloc]init];
    inputBg.frame = CGRectMake(10, topOffset+60, SCREEN_WIDTH-20, 2*ftHeight+16);
    inputBg.layer.cornerRadius = 5;
    inputBg.layer.masksToBounds = YES;
    inputBg.layer.borderWidth = 1;
    [self.view addSubview:inputBg];
    
    _userLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, topOffset+65, 80, ftHeight)];
    _pswLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, topOffset+70+ftHeight, 80, ftHeight)];
    _username = [[UITextField alloc]initWithFrame:CGRectMake(95, topOffset+65+ftHeight*0.1, SCREEN_WIDTH-120, ftHeight*0.8)];
    _username.keyboardType = UIKeyboardTypeNumberPad;
    _psw = [[UITextField alloc]initWithFrame:CGRectMake(95, topOffset+70+ftHeight*1.1, SCREEN_WIDTH-120, ftHeight*0.8)];
//    CGFloat gray = 245;
    _username.backgroundColor = tfBgColor;
    _psw.backgroundColor = tfBgColor;
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _psw.borderStyle = UITextBorderStyleRoundedRect;
    _psw.secureTextEntry = YES;
    _userLbl.text = @"用户名";
    _userLbl.textAlignment = NSTextAlignmentCenter;
    _userLbl.font = [UIFont systemFontOfSize:18];
    _pswLbl.text = @"密码";
    _pswLbl.textAlignment = NSTextAlignmentCenter;
    _pswLbl.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_userLbl];
    [self.view addSubview:_pswLbl];
    [self.view addSubview:_username];
    [self.view addSubview:_psw];
    if(debugMode){
        _username.text = @"15232111721";
//        13488309249  13345627894 13572862259
        //13572862259
        _psw.text = @"123456";
    }
    
    UIButton *launch = [[UIButton alloc]initWithFrame:CGRectMake(10, topOffset+95+2*ftHeight, SCREEN_WIDTH-10*2, 40)];
    [launch setTitle:@"登 陆" forState:UIControlStateNormal];
    launch.titleLabel.textColor = textColorOnBg;
    launch.titleLabel.font = [UIFont systemFontOfSize:28];
    launch.backgroundColor = themeColor;
    launch.layer.cornerRadius = 4;
    [launch addTarget:self action:@selector(launchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:launch];
    
    _errorLbl = [[UILabel alloc]initWithFrame:CGRectMake(40, topOffset+105+2*ftHeight+40, SCREEN_WIDTH-80, 30)];
    _errorLbl.hidden = YES;
    _errorLbl.text = @"显示error信息";
    _errorLbl.textAlignment = NSTextAlignmentCenter;
    _errorLbl.textColor = themeColor;
    [self.view addSubview:_errorLbl];
    
    CGFloat bottomLblWid = 80;
    _toRegister = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-10-bottomLblWid, SCREEN_HEIGHT-50, bottomLblWid, 30)];
    _forgetPsw = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+10, SCREEN_HEIGHT-50, bottomLblWid, 30)];
    _split = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-2, SCREEN_HEIGHT-50, 4, 30)];
    [_toRegister setTitle:@"注册用户" forState:UIControlStateNormal];
    [_toRegister setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_toRegister addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [_forgetPsw setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPsw setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_forgetPsw addTarget:self action:@selector(findPsw) forControlEvents:UIControlEventTouchUpInside];
    _split.textAlignment = NSTextAlignmentCenter;
    _split.textColor = [UIColor blueColor];
    _split.text = @"|";
    [self.view addSubview:_toRegister];
    [self.view addSubview:_forgetPsw];
    [self.view addSubview:_split];
    
    // Do any additional setup after loading the view.
}

-(void)launchClick{
//    if(debugMode){
//        ViewController *Vcc = [[ViewController alloc]init];
//        UIApplication.sharedApplication.delegate.window.rootViewController = Vcc;
//        return;
//    }
    if(_hadLogin)//防止重复触发登录后开启多个线程进行登录操作
        return;
    _hadLogin = true;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(self->_username.text.length == 0 || self->_psw.text.length == 0){
            [MyUtils alertMsg:@"用户名或密码不能为空" method:@"submitAdv" vc:self];
        }
        else{
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self->_username.text,@"phone",self->_psw.text,@"pwd",nil];
        //13488309249  13345627894
            [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appUser/login", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
                NSLog(@"json:%@",responseObject);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                int res = [[dict objectForKey:@"code"]integerValue];
                if(res == 0){
                    [defaults setObject:responseObject[@"data"][@"userID"] forKey:@"userId"];
                    
                    [defaults setObject:responseObject[@"data"][@"userName"] forKey:@"userName"];
                    [defaults setObject:responseObject[@"data"][@"belongTo"] forKey:@"userType"];
                    ViewController *vc = [[ViewController alloc]init];
                    UIApplication.sharedApplication.delegate.window.rootViewController = vc;
                }
                else{
                    NSString *error = [dict objectForKey:@"error"];
                    [MyUtils alertMsg:[NSString stringWithFormat:@"登陆失败：error:%@",error] method:@"launchClick" vc:self];
                    _hadLogin = false;
                }
                } FailureBlock:^(id error){
                    [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误：error:%@",error] method:@"launchClick" vc:self];
                    _hadLogin = false;
//                    NSLog(@"登录失败：error:%@",error);
                }];
            }
    });
}

//-(void)showMsg:(NSString *)msg{
//    _errorLbl.hidden = NO;
//    _errorLbl.text = msg;
//}
//在textfield中输入弹出键盘后，点击背景收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)registerUser{
    RegisterUser *vc = [[RegisterUser alloc]init];
    UIApplication.sharedApplication.delegate.window.rootViewController = vc;
}
-(void)findPsw{
    ForgetPswd *vc = [[ForgetPswd alloc]init];
    UIApplication.sharedApplication.delegate.window.rootViewController = vc;
}

@end

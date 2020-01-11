//
//  ForgetPswd.m
//  QinWuTong
//
//  Created by ltl on 2019/1/13.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "ForgetPswd.h"
#import "ResetPswd.h"
#import "LoginPageVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface ForgetPswd ()

@property(strong, nonatomic) UILabel *userLbl;
@property(strong, nonatomic) UILabel *verCodeLbl;
@property(strong, nonatomic) UITextField *verCode;
@property(strong, nonatomic) UITextField *username;
@end

@implementation ForgetPswd

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat topOffset = 10;//自顶部向下的偏移量
    UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    bgLabel.backgroundColor = themeColor;
    UILabel *pageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, topOffset+10, SCREEN_WIDTH, 40)];
    pageTitle.textAlignment = NSTextAlignmentCenter;
    pageTitle.text = @"找回密码";
    pageTitle.backgroundColor = themeColor;
    pageTitle.textColor = [UIColor whiteColor];
    pageTitle.font = [UIFont boldSystemFontOfSize:titleFontSize];
    [self.view addSubview:bgLabel];
    [self.view addSubview:pageTitle];
    
    
    CGFloat tfHeight = 40;
    //    dataSource=@[@"用户名",@"密码"];
    UILabel *inputBg = [[UILabel alloc]init];
    inputBg.frame = CGRectMake(10, topOffset+60, SCREEN_WIDTH-20, 2*tfHeight+21);
    inputBg.layer.cornerRadius = 5;
    inputBg.layer.masksToBounds = YES;
    inputBg.layer.borderWidth = 1;
    [self.view addSubview:inputBg];
    
    
    _userLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, inputBg.frame.origin.y+5, 80, tfHeight)];
    _verCodeLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, _userLbl.frame.origin.y+_userLbl.frame.size.height+5, 80, tfHeight)];
    _username = [[UITextField alloc]initWithFrame:CGRectMake(95, _userLbl.frame.origin.y+tfHeight*0.1, SCREEN_WIDTH-120, tfHeight*0.8)];
    _verCode = [[UITextField alloc]initWithFrame:CGRectMake(95, _verCodeLbl.frame.origin.y+tfHeight*0.1, 160, tfHeight*0.8)];
    _username.backgroundColor = tfBgColor;
    _verCode.backgroundColor = tfBgColor;
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _verCode.borderStyle = UITextBorderStyleRoundedRect;
    _userLbl.text = @"用户名";
    _userLbl.textAlignment = NSTextAlignmentCenter;
    _userLbl.font = [UIFont systemFontOfSize:18];
    _verCodeLbl.text = @"验证码";
    _verCodeLbl.textAlignment = NSTextAlignmentCenter;
    _verCodeLbl.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_userLbl];
    [self.view addSubview:_verCodeLbl];
    [self.view addSubview:_username];
    [self.view addSubview:_verCode];
    
    UIButton *getVerCodeBtn= [[UIButton alloc]initWithFrame:CGRectMake(_verCode.frame.origin.x+_verCode.frame.size.width+5, _verCode.frame.origin.y, SCREEN_WIDTH-120-165, tfHeight*0.8)];
    [getVerCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getVerCodeBtn.titleLabel.textColor = textColorOnBg;
    getVerCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    getVerCodeBtn.backgroundColor = themeColor;
    getVerCodeBtn.layer.cornerRadius = 4;
    [getVerCodeBtn addTarget:self action:@selector(getVerCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getVerCodeBtn];
    

    
    UIButton *btn= [[UIButton alloc]initWithFrame:CGRectMake(10, inputBg.frame.origin.y+inputBg.frame.size.height+8, SCREEN_WIDTH-10*2, 40)];
    [btn setTitle:@"提  交" forState:UIControlStateNormal];
    btn.titleLabel.textColor = textColorOnBg;
    btn.titleLabel.font = [UIFont systemFontOfSize:28];
    btn.backgroundColor = themeColor;
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(checkVerCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *cancel= [[UIButton alloc]initWithFrame:CGRectMake(10, btn.frame.origin.y+btn.frame.size.height+10, SCREEN_WIDTH-10*2, 40)];
    [cancel setTitle:@"取  消" forState:UIControlStateNormal];
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
-(void)getVerCode{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(self->_username.text.length == 0 || [MyUtils isBlankString:self->_username.text]){
            [MyUtils alertMsg:@"请输入手机号码" method:@"getVerCode" vc:self];
        }
        else{
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self->_username.text,@"phone",nil];
            [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appUser/forgetPwd", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
                NSLog(@"json:%@",responseObject);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                int res = [[dict objectForKey:@"code"]integerValue];
                if(res == 0){
                    //获取验证码成功不需要操作
                }
                else{
                    NSString *error = [dict objectForKey:@"error"];
                    [MyUtils alertMsg:[NSString stringWithFormat:@"获取验证码失败：error:%@",error] method:@"getVerCode" vc:self];
                }
            } FailureBlock:^(id error){
                [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误：error:%@",error] method:@"getVerCode" vc:self];
            }];
        }
    });
}
-(void)checkVerCode{
    if(self->_username.text.length == 0 || [MyUtils isBlankString:self->_username.text]){
        [MyUtils alertMsg:@"请输入手机号码" method:@"checkVerCode" vc:self];
        return ;
    }
    if(self->_verCode.text.length == 0 || [MyUtils isBlankString:self->_verCode.text]){
        [MyUtils alertMsg:@"请输入验证码" method:@"checkVerCode" vc:self];
        return ;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self->_username.text,@"phone",
                             self->_verCode.text,@"verCode",
                             nil];
        [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appUser/checkVerCode", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
            NSLog(@"json:%@",responseObject);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 0){
                ResetPswd *vc = [[ResetPswd alloc]init];
                [vc setPhone:self->_username.text];
                UIApplication.sharedApplication.delegate.window.rootViewController = vc;
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"验证码错误:%@",error] method:@"checkVerCode" vc:self];
            }
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误：error:%@",error] method:@"checkVerCode" vc:self];
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

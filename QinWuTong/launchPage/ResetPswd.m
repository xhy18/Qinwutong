//
//  ResetPswd.m
//  QinWuTong
//
//  Created by ltl on 2019/1/13.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "ResetPswd.h"
#import "LoginPageVC.h"


#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface ResetPswd ()
@property(strong, nonatomic) NSString *phone;

@property(strong, nonatomic) UILabel *pswLbl;
@property(strong, nonatomic) UILabel *pswLbl2;
@property(strong, nonatomic) UITextField *psw;
@property(strong, nonatomic) UITextField *psw2;
@end

@implementation ResetPswd

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat topOffset = 10;//自顶部向下的偏移量
    UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    bgLabel.backgroundColor = themeColor;
    UILabel *pageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, topOffset+10, SCREEN_WIDTH, 40)];
    pageTitle.textAlignment = NSTextAlignmentCenter;
    pageTitle.text = @"重置密码";
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
    
    _pswLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, inputBg.frame.origin.y+5, 80, tfHeight)];
    _pswLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(15, _pswLbl.frame.origin.y+_pswLbl.frame.size.height+5, 80, tfHeight)];
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
    
    
    UIButton *btn= [[UIButton alloc]initWithFrame:CGRectMake(10, inputBg.frame.origin.y+inputBg.frame.size.height+8, SCREEN_WIDTH-10*2, 40)];
    [btn setTitle:@"提  交" forState:UIControlStateNormal];
    btn.titleLabel.textColor = textColorOnBg;
    btn.titleLabel.font = [UIFont systemFontOfSize:28];
    btn.backgroundColor = themeColor;
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(resetPswd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *cancel= [[UIButton alloc]initWithFrame:CGRectMake(10, btn.frame.origin.y+btn.frame.size.height+10, SCREEN_WIDTH-10*2, 40)];
    [cancel setTitle:@"取  消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:28];
    cancel.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    cancel.layer.cornerRadius = 4;
    [cancel addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    // Do any additional setup after loading the view.
}
-(void)back{
    LoginPageVC *vc = [[LoginPageVC alloc]init];
    UIApplication.sharedApplication.delegate.window.rootViewController = vc;
}
-(void)setPhone:(NSString *)phone{
    _phone = phone;
}
-(void)resetPswd{
    if(self->_psw.text.length == 0 || [MyUtils isBlankString:self->_psw.text]){
        [MyUtils alertMsg:@"请输入密码" method:@"resetPswd" vc:self];
        return ;
    }
    if(self->_psw.text != self->_psw2.text){
        [MyUtils alertMsg:@"两次输入的密码不相同" method:@"resetPswd" vc:self];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _phone,@"phone",
                             self->_psw.text,@"pwd",
                             nil];
        [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appUser/resetPwd", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
            NSLog(@"json:%@",responseObject);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 0){
//                [MyUtils alertMsg:@"重置密码成功，请返回登录页面" method:@"resetPswd" vc:self];
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"重置密码成功，请返回登录页面" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LoginPageVC *vc = [[LoginPageVC alloc]init];
                    UIApplication.sharedApplication.delegate.window.rootViewController = vc;
                }];
                [alert addAction:sureAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"重置密码失败：error:%@",error] method:@"resetPswd" vc:self];
            }
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误：error:%@",error] method:@"resetPswd" vc:self];
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

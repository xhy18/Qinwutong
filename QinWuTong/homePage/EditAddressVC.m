//
//  EditAddressVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/28.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "EditAddressVC.h"
#import "UserAddressCell.h"
#import "UserAddressInfoObj.h"
#import "EditAddressVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface EditAddressVC ()

@property(strong, nonatomic) UserAddressInfoObj *uo;
@property(strong, nonatomic) UITextField *nameTf;
@property(strong, nonatomic) UITextField *telTf;
@property(strong, nonatomic) UITextField *zoneTf;
@property(strong, nonatomic) UITextField *addressTf;
//@property(strong, nonatomic) UILabel *telLbl;
//@property(strong, nonatomic) UILabel *zoneLbl;
//@property(strong, nonatomic) UILabel *addressLbl;
@property(strong, nonatomic) UIButton *isDefaultAdd;
@property(strong , nonatomic)NSString *addressId;
@property(nonatomic)bool *isNewAddress;
@end

@implementation EditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
//    self.view.backgroundColor = grayBgColor;
    
//    CGFloat topOffset = 0;
    CGFloat topOffset = statusBarFrame.size.height+navigationHeight+5;
    CGFloat titleHei = 30;
    CGFloat ftHeight = 36;
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, topOffset, SCREEN_WIDTH, titleHei)];
    nameLbl.text = @"联系人：";
    _nameTf = [[UITextField alloc]initWithFrame:CGRectMake(10, nameLbl.frame.origin.y+nameLbl.frame.size.height+4, SCREEN_WIDTH-20, ftHeight)];
    _nameTf.backgroundColor = tfBgColor;
    UILabel *telLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, _nameTf.frame.origin.y+_nameTf.frame.size.height+6, SCREEN_WIDTH, titleHei)];
    telLbl.text = @"联系电话：";
    _telTf = [[UITextField alloc]initWithFrame:CGRectMake(10, telLbl.frame.origin.y+telLbl.frame.size.height+4, SCREEN_WIDTH-20, ftHeight)];
    _telTf.backgroundColor = tfBgColor;
    UILabel *zoneLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, _telTf.frame.origin.y+_telTf.frame.size.height+6, SCREEN_WIDTH, titleHei)];
    zoneLbl.text = @"所在地区：（省、市、区/县）";
    _zoneTf = [[UITextField alloc]initWithFrame:CGRectMake(10, zoneLbl.frame.origin.y+zoneLbl.frame.size.height+4, SCREEN_WIDTH-20, ftHeight)];
    _zoneTf.backgroundColor = tfBgColor;
    UILabel *addressLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, _zoneTf.frame.origin.y+_zoneTf.frame.size.height+6, SCREEN_WIDTH, titleHei)];
    addressLbl.text = @"详细地址：（街道、社区、楼牌号）";
    _addressTf = [[UITextField alloc]initWithFrame:CGRectMake(10, addressLbl.frame.origin.y+addressLbl.frame.size.height+4, SCREEN_WIDTH-20, ftHeight)];
    _addressTf.backgroundColor = tfBgColor;
    _isDefaultAdd = [[UIButton alloc]initWithFrame:CGRectMake(10, _addressTf.frame.origin.y+_addressTf.frame.size.height+10, 16, 16)];
    [_isDefaultAdd setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    _isDefaultAdd.selected = YES;
    [_isDefaultAdd addTarget:self action:@selector(isDefaultAddClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *defaultAddLbl = [[UILabel alloc]initWithFrame:CGRectMake(_isDefaultAdd.frame.origin.x+_isDefaultAdd.frame.size.width+5, _isDefaultAdd.frame.origin.y-4, SCREEN_WIDTH, 24)];
    defaultAddLbl.text = @"设置为默认地址";
    
//    _nameTf.text = @"2";
//    _telTf.text = @"2";
//    _addressTf.text = @"2";
    [self.view addSubview:nameLbl];
    [self.view addSubview:_nameTf];
    [self.view addSubview:telLbl];
    [self.view addSubview:_telTf];
    [self.view addSubview:zoneLbl];
    [self.view addSubview:_zoneTf];
    [self.view addSubview:addressLbl];
    [self.view addSubview:_addressTf];
    [self.view addSubview:_isDefaultAdd];
    [self.view addSubview:defaultAddLbl];
    
    UIButton *saveThis = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-50, SCREEN_WIDTH-20, 40)];
    [saveThis setTitle:@"保 存 地 址" forState:UIControlStateNormal];
    saveThis.titleLabel.textColor = textColorOnBg;
    saveThis.titleLabel.font = [UIFont systemFontOfSize:28];
    saveThis.backgroundColor = themeColor;
    saveThis.layer.cornerRadius = 4;
    [saveThis addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveThis];
    [self reflashTextField];
}
-(void)reflashTextField{
    _nameTf.text = _uo.name;
    _telTf.text = _uo.tel;
    _addressTf.text = _uo.address;
}
-(void)setAddressObj:(UserAddressInfoObj *)obj{
    if(obj){
        _isNewAddress = false;
        self.navigationItem.title = @"修改服务地址";
        _uo = obj;
        _nameTf.text = obj.name;
        _telTf.text = obj.tel;
        _addressTf.text = obj.address;
        _addressId = obj.id;
//        [self reflashTextField];
        if(obj.isdefault){
            _isDefaultAdd.selected = YES;
            [_isDefaultAdd setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        }
        else{
            _isDefaultAdd.selected = NO;
            [_isDefaultAdd setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        }
    }
    else{
        _isNewAddress = true;
        self.navigationItem.title = @"新增服务地址";
    }
}
-(void)isDefaultAddClick{
    if(_isDefaultAdd.selected == NO){
        _isDefaultAdd.selected = YES;
        [_isDefaultAdd setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else{
        _isDefaultAdd.selected = NO;
        [_isDefaultAdd setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    }
}

-(void)saveAddress{
    NSLog(self->_addressTf.text);
    if(self->_addressTf.text.length == 0 || self->_nameTf.text.length == 0 || self->_telTf.text.length == 0){
//        NSLog(@"联系人、联系电话、详细地址均不能为空");//【wait】修改为弹窗提示。
        [MyUtils alertMsg:@"联系人、联系电话、详细地址均不能为空" method:@"saveAddress" vc:self];
        return;
    }
    int tmp = 1;
    if(_isDefaultAdd.selected == NO)
        tmp=0;
    if(_isNewAddress){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self->_telTf.text,@"phone",
                                 self->_nameTf.text,@"name",
                                 [defaults stringForKey:@"userId"],@"userId",
                                 self->_addressTf.text,@"address",
                                 [NSNumber numberWithInt:tmp],@"flag",nil];
            [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appAddress/", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
//                NSLog(@"json:%@",responseObject);
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                int res = [[dict objectForKey:@"code"]integerValue];
                if(res == 0){
//                    [ErrorAlertVC showError:[NSString stringWithFormat:@"地址添加成功"] method:@"saveAddress" vc:self];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    NSString *error = [dict objectForKey:@"error"];
                    [MyUtils alertMsg:[NSString stringWithFormat:@"地址添加失败：error:%@",error] method:@"saveAddress" vc:self];
                }
            } FailureBlock:^(id error){
                [MyUtils alertMsg:[NSString stringWithFormat:@"地址添加失败：error:%@",error] method:@"saveAddress" vc:self];
    //            NSLog(@"登录失败：error:%@",error);
            }];
        });
    }
    else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 self->_telTf.text,@"phone",self->_nameTf.text,@"name",
//                                 _uo.id,@"id",self->_addressTf.text,"address",[NSNumber numberWithInt:tmp],nil];
//            //13488309249  13345627894
//            [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appAddress/", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
//                [ErrorAlertVC showError:[NSString stringWithFormat:@"地址添加成功"] method:@"saveAddress" vc:self];
//            } FailureBlock:^(id error){
//                [ErrorAlertVC showError:[NSString stringWithFormat:@"地址添加失败：error:%@",error] method:@"saveAddress" vc:self];
//                //            NSLog(@"登录失败：error:%@",error);
//            }];
        });
    }
}

//在textfield中输入弹出键盘后，点击背景收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden=NO;
//}

@end

//
//  RechargeOrCashVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/16.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "RechargeOrCashVC.h"
#import "PayPageVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface RechargeOrCashVC ()

@property(strong, nonatomic) UITextField *amount;

@property(nonatomic) bool *isRecharge;
@end

@implementation RechargeOrCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"填写充值金额";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0,20, SCREEN_WIDTH, 30)];
    tip.text = [NSString stringWithFormat:@"请输入%@金额",_isRecharge?@"充值":@"提现"];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:tip];
    
    _amount = [[UITextField alloc]initWithFrame:CGRectMake(15, tip.frame.origin.y+tip.frame.size.height+20 , SCREEN_WIDTH-30, 36)];
    _amount.backgroundColor = tfBgColor;
    _amount.borderStyle = UITextBorderStyleRoundedRect;
    _amount.keyboardType = UIKeyboardTypeNumberPad;
    _amount.textAlignment = NSTextAlignmentCenter;
    _amount.font = [UIFont systemFontOfSize:28];
    [self.view addSubview:_amount];
    
    UIButton *btn= [[UIButton alloc]initWithFrame:CGRectMake(10, _amount.frame.origin.y+_amount.frame.size.height+25, SCREEN_WIDTH-10*2, 40)];
    [btn setTitle:@"确认并支付" forState:UIControlStateNormal];
    btn.titleLabel.textColor = textColorOnBg;
    btn.titleLabel.font = [UIFont systemFontOfSize:28];
    btn.backgroundColor = themeColor;
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)submit{
    if(_isRecharge)
        [self recharge];
    else
        [self getCash];
}
-(void)recharge{
    PayPageVC *vc = [[PayPageVC alloc]init];
    [vc setAmount:[_amount.text intValue] tip:[NSString stringWithFormat:@"将向钱包充值%d.00元",[_amount.text intValue]]];
//    [vc setType:2 setId:[_amount.text longLongValue] tip:[NSString stringWithFormat:@"将向钱包充值%lld元",[_amount.text longLongValue]]];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)getCash{
    //界面做完发现就没有提现这个功能。。。。。先这样不删了
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)isRecharge:(bool)tag{
    _isRecharge = tag;
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

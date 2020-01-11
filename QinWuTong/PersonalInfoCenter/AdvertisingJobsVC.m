//
//  AdvertisingJobsVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/5.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "AdvertisingJobsVC.h"
#import "JobObj.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface AdvertisingJobsVC ()

@property(strong, nonatomic) UITextField *positionTitle;
@property(strong, nonatomic) UITextField *duties;
@property(strong, nonatomic) UITextField *claim;
@property(strong, nonatomic) UITextField *number;
@property(strong, nonatomic) UITextField *salary;
@property(strong, nonatomic) UIDatePicker *deadline;
@property(strong, nonatomic) UITextField *officialWebsite;
@property(strong, nonatomic) UITextField *phone;
@property(strong, nonatomic) UITextField *email;

@property(strong, nonatomic) JobObj *obj;

@property(nonatomic) bool hadInit;

@end

@implementation AdvertisingJobsVC

- (void)initFrame {
    if(_hadInit)
        return;
    _hadInit = true;
    
    CGFloat lblHei = 20;
    CGFloat lblWid = 85;
    CGFloat tfHei = 24;
    int fontSize = 16;
    UILabel *positionTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, lblWid, lblHei)];
    positionTitleLbl.font = [UIFont systemFontOfSize:fontSize];
    positionTitleLbl.text = @"岗位名称：";
    _positionTitle = [[UITextField alloc]initWithFrame:
                      CGRectMake(positionTitleLbl.frame.origin.x+positionTitleLbl.frame.size.width+5, positionTitleLbl.frame.origin.y
                                 , SCREEN_WIDTH-20-positionTitleLbl.frame.size.width, tfHei)];
    _positionTitle.backgroundColor = tfBgColor;
    [self.view addSubview:positionTitleLbl];
    [self.view addSubview:_positionTitle];
    
    UILabel *dutiesLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, _positionTitle.frame.origin.y+_positionTitle.frame.size.height+8, lblWid, lblHei)];
    dutiesLbl.font = [UIFont systemFontOfSize:fontSize];
    dutiesLbl.text = @"岗位职责：";
    _duties = [[UITextField alloc]initWithFrame:
               CGRectMake(10, dutiesLbl.frame.origin.y+dutiesLbl.frame.size.height+5
                          , SCREEN_WIDTH-20, tfHei*2)];
    _duties.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _duties.backgroundColor = tfBgColor;
    [self.view addSubview:dutiesLbl];
    [self.view addSubview:_duties];
    
    UILabel *claimLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, _duties.frame.origin.y+_duties.frame.size.height+8, lblWid, lblHei)];
    claimLbl.font = [UIFont systemFontOfSize:fontSize];
    claimLbl.text = @"岗位要求：";
    _claim = [[UITextField alloc]initWithFrame:
              CGRectMake(10, claimLbl.frame.origin.y+claimLbl.frame.size.height+5
                         , SCREEN_WIDTH-20, tfHei*3)];
    _claim.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _claim.backgroundColor = tfBgColor;
    [self.view addSubview:claimLbl];
    [self.view addSubview:_claim];
    
    UILabel *numLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, _claim.frame.origin.y+_claim.frame.size.height+8, lblWid, lblHei)];
    numLbl.font = [UIFont systemFontOfSize:fontSize];
    numLbl.text = @"招聘人数：";
    _number = [[UITextField alloc]initWithFrame:
               CGRectMake(numLbl.frame.origin.x+numLbl.frame.size.width+5, numLbl.frame.origin.y
                          , SCREEN_WIDTH-20-numLbl.frame.size.width, tfHei)];
    _number.backgroundColor = tfBgColor;
    [self.view addSubview:numLbl];
    [self.view addSubview:_number];
    
    UILabel *salaryLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, _number.frame.origin.y+_number.frame.size.height+8, lblWid, lblHei)];
    salaryLbl.font = [UIFont systemFontOfSize:fontSize];
    salaryLbl.text = @"岗位薪资：";
    _salary = [[UITextField alloc]initWithFrame:
               CGRectMake(salaryLbl.frame.origin.x+salaryLbl.frame.size.width+5, salaryLbl.frame.origin.y
                          , SCREEN_WIDTH-20-salaryLbl.frame.size.width, tfHei)];
    _salary.backgroundColor = tfBgColor;
    [self.view addSubview:salaryLbl];
    [self.view addSubview:_salary];
    
    UILabel *deadLineLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, _salary.frame.origin.y+_salary.frame.size.height+8, lblWid, lblHei)];
    deadLineLbl.font = [UIFont systemFontOfSize:fontSize];
    deadLineLbl.text = @"截止日期：";
    _deadline = [[UIDatePicker alloc]initWithFrame:CGRectMake(10, deadLineLbl.frame.origin.y+deadLineLbl.frame.size.height+5
                                                              , SCREEN_WIDTH-20, tfHei*2)];
    _deadline.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [_deadline setCalendar:[NSCalendar currentCalendar]];
    //    _duties = [[UITextField alloc]initWithFrame:
    //               CGRectMake(10, dutiesLbl.frame.origin.y+dutiesLbl.frame.size.height+5
    //                          , SCREEN_WIDTH-20, tfHei*2)];
    //    _duties.backgroundColor = tfBgColor;
    [self.view addSubview:deadLineLbl];
    [self.view addSubview:_deadline];
    
    UILabel *webLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, _deadline.frame.origin.y+_deadline.frame.size.height+8, lblWid, lblHei)];
    webLbl.font = [UIFont systemFontOfSize:fontSize];
    webLbl.text = @"官网地址：";
    _officialWebsite = [[UITextField alloc]initWithFrame:
                        CGRectMake(10, webLbl.frame.origin.y+webLbl.frame.size.height+5
                                   , SCREEN_WIDTH-20, tfHei)];
    _officialWebsite.backgroundColor = tfBgColor;
    [self.view addSubview:webLbl];
    [self.view addSubview:_officialWebsite];
    
    UILabel *emailLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, _officialWebsite.frame.origin.y+_officialWebsite.frame.size.height+8, lblWid, lblHei)];
    emailLbl.font = [UIFont systemFontOfSize:fontSize];
    emailLbl.text = @"邮件地址：";
    _email = [[UITextField alloc]initWithFrame:
              CGRectMake(10, emailLbl.frame.origin.y+emailLbl.frame.size.height+5
                         , SCREEN_WIDTH-20, tfHei)];
    _email.backgroundColor = tfBgColor;
    [self.view addSubview:emailLbl];
    [self.view addSubview:_email];
    
    UILabel *telLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, _email.frame.origin.y+_email.frame.size.height+8, lblWid, lblHei)];
    telLbl.font = [UIFont systemFontOfSize:fontSize];
    telLbl.text = @"联系电话：";
    _phone = [[UITextField alloc]initWithFrame:
              CGRectMake(10, telLbl.frame.origin.y+telLbl.frame.size.height+5
                         , SCREEN_WIDTH-20, tfHei)];
    _phone.backgroundColor = tfBgColor;
    [self.view addSubview:telLbl];
    [self.view addSubview:_phone];
    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-50, SCREEN_WIDTH-20, 40)];
    [submit setTitle:@"提 交" forState:UIControlStateNormal];
    submit.titleLabel.textColor = textColorOnBg;
    submit.titleLabel.font = [UIFont systemFontOfSize:28];
    submit.backgroundColor = themeColor;
    submit.layer.cornerRadius = 4;
    [submit addTarget:self action:@selector(submitAdv) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布招聘";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    [self initFrame];
    
//    if(debugMode){
//        int tmp = arc4random();
//        _positionTitle.text = [NSString stringWithFormat:@"岗位名称 %d",tmp];
//        _duties.text = [NSString stringWithFormat:@"岗位职责 %d",tmp];
//        _claim.text = [NSString stringWithFormat:@"岗位要求 %d",tmp];
//        _number.text = [NSString stringWithFormat:@"%d",tmp];
//        _salary.text = [NSString stringWithFormat:@"%d",tmp*100];
//        _officialWebsite.text = [NSString stringWithFormat:@"官方网站 %d",tmp];
//        _email.text = [NSString stringWithFormat:@"email %d",tmp];
//        _phone.text = [NSString stringWithFormat:@"联系电话 %d",tmp];
//    }
}
-(void)editJobsInfo:(JobObj *)job{
    _obj = job;
    [self initFrame];
    _positionTitle.text = job.positionTitle;
    if(![MyUtils isBlankString:job.duties])
        _duties.text = job.duties;
    if(![MyUtils isBlankString:job.claim])
        _claim.text = job.claim;
    if(![MyUtils isBlankString:job.salary])
        _salary.text = job.salary;
    if(![MyUtils isBlankString:job.officialWebsite])
        _officialWebsite.text = job.officialWebsite;
    if(![MyUtils isBlankString:job.email])
        _email.text = job.email;
    if(![MyUtils isBlankString:job.phone])
        _phone.text = job.phone;
    if(job.number > 0)
        _number.text = [NSString stringWithFormat:@"%d",job.number];
    if(![MyUtils isBlankString:job.deadline]){
//        _deadline = [[UIDatePicker alloc] init];
        _deadline.date = [self str2Date:job.deadline];
//        [_deadline setCalendar:[NSCalendar currentCalendar]];
    }
}

-(NSDate*)str2Date:(NSString *)str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //    NSString *dateString = @"2011-05-03 23:11:40";
    NSDate *date = [formatter dateFromString:str];
    return date;
}
- (NSString *)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式@"2018-12-11T16:38:12.00+0000"
    //    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.000+0000";
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
//    NSLog(dateStr);
//    [ErrorAlertVC debugMsg:[NSString stringWithFormat:@"%@",dateStr] vc:self];
    return dateStr;
}
-(void)submitAdv{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(self->_positionTitle.text.length == 0){
            [MyUtils alertMsg:@"岗位名称不能为空" method:@"submitAdv" vc:self];
//            NSLog(@"用户名或密码不能为空");//【wait】修改为弹窗提示。
        }
        else{
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.phone.text,@"phone",
                                 self.positionTitle.text,@"positionTitle",
                                 self.duties.text,@"duties",
                                 self.claim.text,@"claim",
                                 [NSNumber numberWithInt:[_number.text integerValue]],@"number",
                                 self.salary.text,@"salary",
                                 self.officialWebsite.text,@"officialWebsite",
                                 self.email.text,@"email",
                                 [self dateChange:self->_deadline],@"deadline",
                                 [defaults stringForKey:@"userId"],@"userId"
                                 ,nil];
//            [MyUtils testUrl:dic];
//            return ;
            [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appRecruitment/", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
                NSLog(@"json:%@",responseObject);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                int res = [[dict objectForKey:@"code"]integerValue];
                if(res == 0){
                    [MyUtils alertMsg:[NSString stringWithFormat:@"招聘信息发布成功"] method:@"submitAdv" vc:self];
                }
                else{
                    NSString *error = [dict objectForKey:@"error"];
                    [MyUtils alertMsg:[NSString stringWithFormat:@"发布失败：error:%@",error] method:@"submitAdv" vc:self];
                }
            } FailureBlock:^(id error){
                [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误：error:%@",error] method:@"submitAdv" vc:self];
//                NSLog(@"登录失败：error:%@",error);
            }];
        }
    });
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

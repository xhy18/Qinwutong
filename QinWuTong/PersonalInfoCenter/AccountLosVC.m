//
//  AccountLosVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/17.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "AccountLosVC.h"
#import "AccountLosObj.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface AccountLosVC ()

@property(nonatomic) NSMutableArray *losArr;
@end

@implementation AccountLosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"钱包明细";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mycell"];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.rowHeight = 48;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.rowHeight = 65;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mycell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = grayBgColor;
    // Do any additional setup after loading the view.
}

-(void)getLos{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appUser/selectUserAccountLos", baseUrl]Dic:dic SuccessBlock:^(id responseObject){
            NSLog(@"请求成功jason:%@",responseObject);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //            NSLog(jsonData);
            int res = [[d objectForKey:@"code"]integerValue];
            if(res == 0){
                //success body
                NSArray *rowsArr = d[@"data"];
                self.losArr = @[].mutableCopy;
                for(NSDictionary *dict in rowsArr){
                    AccountLosObj *obj = [AccountLosObj new];
//                    ao. = [dict objectForKey:@"name"];
                    obj.flag = [[dict objectForKey:@"flag"]intValue];
                    obj.money = [[dict objectForKey:@"money"]floatValue];
                    obj.losId = [dict objectForKey:@"id"];
                    obj.orderId = [dict objectForKey:@"orderId"];
                    NSString *timeInStr = [dict objectForKey:@"createTime"];
                    if(![MyUtils isBlankString:timeInStr]){
                        timeInStr = [timeInStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        timeInStr = [timeInStr stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
                        obj.createTime = timeInStr;
                    }
                    [_losArr addObject:obj];
                }
                [self.tableView reloadData];
            }
            else{
                NSString *error = [d objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取明细失败：error:%@",error] method:@"getLos" vc:self];
            }
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"getLos" vc:self];
        }];
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_losArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    AccountLosObj *obj = [_losArr objectAtIndex:indexPath.row];
    //如果单独写一个cell类，就不需要移除view
    for (UIView *view in [c.contentView subviews]){
        [view removeFromSuperview];
    }
    int moneyWid = 120;
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH-moneyWid-10, 24)];
    title.text = [NSString stringWithFormat:@"订单编号：%@",obj.orderId];
    title.font = [UIFont systemFontOfSize:20];
    [c.contentView addSubview:title];
    UILabel *moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-moneyWid-10, 15, moneyWid, 40)];
    if(obj.flag == 1){
        moneyLbl.text = [NSString stringWithFormat:@"+ %.2f",obj.money];
        moneyLbl.textColor = themeColor;
    }
    else{
        moneyLbl.text = [NSString stringWithFormat:@"- %.2f",obj.money];
        moneyLbl.textColor = [UIColor blackColor];
    }
    moneyLbl.textAlignment = NSTextAlignmentRight;
    moneyLbl.font = [UIFont systemFontOfSize:22];
    [c.contentView addSubview:moneyLbl];
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(5, title.frame.origin.y+title.frame.size.height, SCREEN_WIDTH-moneyWid-10, 16)];
    time.text = [NSString stringWithFormat:@"交易时间：%@",obj.createTime];
    time.font = [UIFont systemFontOfSize:14];
    time.textColor = textColorGray;
    [c.contentView addSubview:time];
    c.selectionStyle = UITableViewCellSelectionStyleNone;
//    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, time.frame.origin.y+time.frame.size.height+3, SCREEN_WIDTH, 1)];
//    line.backgroundColor = grayBgColor;
//    [c.contentView addSubview:line];
    return c;
}

//点击item方法
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UserAddressInfoObj *uo = [_addressArr objectAtIndex:indexPath.row];
//    [_submitOrderVC showAddress:uo];
//    [self.navigationController popViewControllerAnimated:YES];
    //    NSLog(@"%d",c.btn.tag);
//}


//-(void)viewWillAppear:(BOOL)animated{
//    //    self.navigationController.navigationBarHidden = NO;
//    //    self.tabBarController.tabBar.hidden=YES;
//    //    self.tabBarController.tabBar.hidden=YES;
//    //    self.navigationController.navigationBarHidden = YES;
//}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
    [self getLos];
}
@end

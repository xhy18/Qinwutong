//
//  OrderObj.m
//  QinWuTong
//
//  Created by ltl on 2018/12/27.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "OrderObj.h"
#import "OrderObj.h"
#import "skillObj.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@implementation OrderObj

+(NSString *)getOrderStateInStr:(int )state{
    NSString *res;
    switch (state) {
        case -10:
            res = @"已拒绝";
            break;
        case -5:
            res = @"已取消";
            break;
        case -1:
            res = @"申请取消";
            break;
        case 10:
            res = @"待接单";
            break;
        case 12:
            res = @"待付款";
            break;
        case 14:
            res = @"待上门";
            break;
        case 16:
            res = @"服务中";
            break;
        case 18:
            res = @"待确认";
            break;
        case 20:
            res = @"已完成";
            break;
        default:
            [MyUtils alertMsg:@"订单状态无效" method:@"getOrderStateInStr" vc:self];
            break;
    }
    return res;
}
//重构了order的json解析方法。
//getOrderListFromDB:(NSArray *)stateList 传入需要查询的订单状态数组
//tableNeedReload:(UITableView *)tableView 传入收到数据后执行刷新的tableView（由于各页面没有继承个父类来实现，就先传进来刷新了）
//vc:(UIViewController *)vc 用于报错时提示错误的页面
+(NSMutableArray *)getOrderListFromDB:(NSArray *)stateList tableNeedReload:(UITableView *)tableView vc:(UIViewController *)vc{
    //由于线程异步，不能直接返回list，需要调用vc的接口将list传回去？
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSArray *stateList =[NSArray arrayWithObjects:[NSNumber numberWithInt:10],nil];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",
                             stateList,@"stateList",nil];//订单状态用数字表示，需进行查阅
        
        NSMutableArray *orderList = @[].mutableCopy;
        [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appOrder/userOrders", baseUrl] isJson:TRUE Dic:dic SuccessBlock:^(id responseObject){
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 0){
                //success body
                NSArray *rowsArr = dict[@"data"];
                //                int tag = -1;
                for(NSDictionary *dict in rowsArr){
                    OrderObj *obj = [OrderObj new];
                    obj.address = [dict objectForKey:@"address"];
                    NSDictionary *servicer = [[NSDictionary alloc]init];
                    servicer = [dict objectForKey:@"serviceUser"];
//                    NSLog(@"%@",[servicer objectForKey:@"serverId"]);
                    obj.servicerId = [dict objectForKey:@"serverId"];
                    obj.servicerName = [servicer objectForKey:@"realname"];
                    obj.orderId = [dict objectForKey:@"orderId"];
                    obj.id = [dict objectForKey:@"id"];
                    obj.homeFee = [[dict objectForKey:@"homeFee"]floatValue];
                    obj.total = [[dict objectForKey:@"total"] floatValue];
                    obj.state = [[dict objectForKey:@"state"] intValue];
                    //                obj.createTime = [dict objectForKey:@"createTime"];
                    NSString *timeInStr = [dict objectForKey:@"createTime"];
                    if(![MyUtils isBlankString:timeInStr]){
                        timeInStr = [timeInStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        timeInStr = [timeInStr stringByReplacingOccurrencesOfString:@".000+0000" withString:@"下单"];
                        obj.createTime = timeInStr;
                    }
                    timeInStr = [dict objectForKey:@"dateExpected"];
                    if(![MyUtils isBlankString:timeInStr]){
                        timeInStr = [timeInStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        timeInStr = [timeInStr stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
                        obj.dateExpected = timeInStr;
                    }
                    int payWayTmp;
                    if(obj.state > 12){//已经支付过上门费
                        payWayTmp =[[dict objectForKey:@"homePayBy"] intValue];
                        if(payWayTmp == 1)
                            obj.homePayBy = @"支付宝支付";
                        else if(payWayTmp == 2)
                            obj.homePayBy = @"微信支付";
                        else
                            obj.homePayBy = @"钱包支付";
                        
                        timeInStr = [dict objectForKey:@"homePayTime"];
                        if(![MyUtils isBlankString:timeInStr]){
                            timeInStr = [timeInStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                            timeInStr = [timeInStr stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
                            obj.homePayTime = timeInStr;
                        }
                    }
                    else{
                        obj.homePayBy = nil;
                        obj.homePayTime = nil;
                    }
                    
                    if(obj.state > 20){//已经支付过服务费
                        payWayTmp =[[dict objectForKey:@"servicePayBy"] intValue];
                        if(payWayTmp == 1)
                            obj.servicePayBy = @"支付宝支付";
                        else if(payWayTmp == 2)
                            obj.servicePayBy = @"微信支付";
                        else
                            obj.servicePayBy = @"钱包支付";
                        
                        
                        timeInStr = [dict objectForKey:@"servicePayTime"];
                        timeInStr = [timeInStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        timeInStr = [timeInStr stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
                        obj.servicePayTime = timeInStr;
                    }
                    else{
                        obj.servicePayBy = nil;
                        obj.servicePayTime = nil;
                    }
                    //                NSLog(@"%@",[dict objectForKey:@"createTime"]);
                    NSArray *rowsArr = [dict objectForKey:@"goodsList"];
                    NSMutableArray *serverList = @[].mutableCopy;
                    NSMutableArray *serverConent = @[].mutableCopy;
                    for(NSDictionary *skillDict in rowsArr){
                        SkillObj *so = [SkillObj new];
                        NSString *tmp = [skillDict objectForKey:@"content"];
                        NSArray *arr = [tmp componentsSeparatedByString:@"#"];
                        //                    NSLog(@"\n\nid==%d",[[skillDict objectForKey:@"times"] integerValue]);
                        if([arr count] != 3){
                            so.lv3 = tmp;
                        }
                        else{
                            so.lv1 = [arr objectAtIndex:0];
                            so.lv2 = [arr objectAtIndex:1];
                            so.lv3 = [arr objectAtIndex:2];
                        }
                        [serverConent addObject:so.lv3];
                        so.price = [[skillDict objectForKey:@"unitPrice"] floatValue];
                        so.num = [[skillDict objectForKey:@"times"] integerValue];
                        so.remark = [skillDict objectForKey:@"remarks"];
                        so.comments = [skillDict objectForKey:@"comments"];
                        so.reply = [skillDict objectForKey:@"reply"];
                        so.additionalComments = [skillDict objectForKey:@"additionalComments"];
                        so.skillId = [[skillDict objectForKey:@"id"] integerValue];
                        [serverList addObject:so];
                    }
                    //                NSString *string = [serverConent componentsJoinedByString:@","];
                    obj.servicerContent = [serverConent componentsJoinedByString:@","];
                    obj.skillsList = serverList;
                    [orderList addObject:obj];
                }
                [tableView reloadData];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取订单失败"] method:@"getOrderListFromDB" vc:vc];
            }
        } FailureBlock:^(id error){
            //                NSLog(@"订单提交失败error:%@",error);
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误error:%@",error] method:@"getOrderListFromDB" vc:vc];
        }
         ];
        return orderList;
}

@end

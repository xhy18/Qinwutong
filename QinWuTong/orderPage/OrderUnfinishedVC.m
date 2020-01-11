//
//  OrderUnfinishedVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/10.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "OrderUnfinishedVC.h"
#import "OrderCell.h"
#import "OrderObj.h"
#import "skillObj.h"
#import "MJRefresh.h"
#import "OrderDetailVC.h"

#import "ServerPositionVC.h"
//#import "PayOrderVC.h"
#import "PayPageVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface OrderUnfinishedVC ()

@property (nonatomic, retain)NSString *orderState;
@property (nonatomic) NSMutableArray *orderList;
@property (nonatomic, strong)UIImageView *noOrderImgView;
@property (nonatomic, strong)UILabel *noOrderLbl;
@property (nonatomic)bool getData;//用于标记尝试获取过一次数据。该参数初始值为false，置true后不再置false
@end

@implementation OrderUnfinishedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderState = @"进行中";
    self.title = @"进行中";
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.rowHeight = 89;
    [self.tableView registerClass:[OrderCell class] forCellReuseIdentifier:@"mycell"];
    [self getOrderListByState];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor clearColor];
    //    _firstReflash = true;
    
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tableView.mj_header = header;
    
    _getData =false;
    _noOrderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4,80,SCREEN_WIDTH/2,SCREEN_WIDTH/2)];
    _noOrderImgView.image = [UIImage imageNamed:@"icon_logo.jpg"];
    _noOrderImgView.hidden = YES;
    _noOrderLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, _noOrderImgView.frame.origin.y+_noOrderImgView.frame.size.height+5, SCREEN_WIDTH, 30)];
    _noOrderLbl.text = @"没有该分类下的订单";
    _noOrderLbl.textAlignment = NSTextAlignmentCenter;
    _noOrderLbl.font = [UIFont systemFontOfSize:24];
    _noOrderLbl.textColor = textColorGray;
    _noOrderLbl.hidden = YES;
    [self.view addSubview:_noOrderImgView];
    [self.view addSubview:_noOrderLbl];
    
    
//    UIBarButtonItem *rightbariten = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(click:)];
//    [rightbariten setTintColor:[UIColor colorWithRed:126.0/255.0 green:127.0/255.0 blue:128/255.0 alpha:1.0]];
//    self.navigationItem.rightBarButtonItem = rightbariten;
}

// 头部的下拉刷新触发事件
- (void)headerClick {
    [self getOrderListByState];
    [NSThread sleepForTimeInterval:3];
    //由于获取数据是另开启线程，此处将动画持续3秒
    [self.tableView.mj_header endRefreshing];
}
//原文：https://blog.csdn.net/u013892686/article/details/51941286
//5个页面通用获取订单数据的函数，写在OrderObj类中
-(void)getOrderListByState{
    NSArray *stateList =[NSArray arrayWithObjects:[NSNumber numberWithInt:14],[NSNumber numberWithInt:16],[NSNumber numberWithInt:18],nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _orderList = [OrderObj getOrderListFromDB:stateList tableNeedReload:self.tableView vc:self];
        _getData = true;
    });
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    NSLog(@"setupRefresh -- 下拉刷新");
//
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//控制无订单时的控件显示。放在获取数据方法中处理的话，orderList始终为空，因此放到这里来处理，确保orderList的数量正常
//由于初始化页面时就会调用该方法，加入了getData的布尔值进行判断，防止出现闪屏
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_getData && [_orderList count]==0){
        _noOrderImgView.hidden = NO;
        _noOrderLbl.hidden = NO;
    }
    else{
        _noOrderImgView.hidden = YES;
        _noOrderLbl.hidden = YES;
    }
    return [_orderList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell *c = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    if([_orderList count]==0)
        return c;
    OrderObj *obj = [_orderList objectAtIndex:indexPath.row];
    c.servicerName.text = obj.servicerName;
    c.state.text = [OrderObj getOrderStateInStr:obj.state];
    c.time.text = obj.createTime;
    c.content.text = obj.servicerContent;
    c.price.text = [NSString stringWithFormat:@"￥%.2f",obj.total];
    if(obj.state == 14){
        [c.btn setTitle:@"位置" forState:UIControlStateNormal];
        [c.btn addTarget:self action:@selector(getPosition:) forControlEvents:UIControlEventTouchUpInside];
        c.btn.tag = indexPath.row;
    }
    else if(obj.state == 16){
        c.btn.hidden = YES;
    }
    else if(obj.state == 18){
        [c.btn setTitle:@"确认" forState:UIControlStateNormal];
        [c.btn addTarget:self action:@selector(finishAndPay:) forControlEvents:UIControlEventTouchUpInside];
        c.btn.tag = indexPath.row;
    }
    c.img.image = [UIImage imageNamed:@"icon_default_head.png"];
    return c;
}
-(void)getPosition:(UIButton *)btn{
    ServerPositionVC *vc = [[ServerPositionVC alloc]init];
    OrderObj *obj = [_orderList objectAtIndex:btn.tag];
//    [vc addAnnotation:obj.servicerId];
    [vc setOrderId:obj];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)finishAndPay:(UIButton *)btn{
    OrderObj *obj = [_orderList objectAtIndex:btn.tag];
    PayPageVC *vc = [[PayPageVC alloc]init];
    [vc setType:1 setId:[obj.orderId longLongValue] tip:[NSString stringWithFormat:@"请支付服务费:%.2f元",(obj.total - obj.homeFee)]];
    [self.navigationController pushViewController:vc animated:NO];
//    PayOrderVC *vc = [[PayOrderVC alloc]init];
//    [vc setOrderId:btn.tag isHomeFee:false];
//    [self.navigationController pushViewController:vc animated:NO];
}
//点击item方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell *c = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    if([_orderList count]==0)
        return;
    OrderObj *obj = [_orderList objectAtIndex:indexPath.row];
    OrderDetailVC *vc = [[OrderDetailVC alloc]init];
    [vc initFrame:obj];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getOrderListByState];
}

@end

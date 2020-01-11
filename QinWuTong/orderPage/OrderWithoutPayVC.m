//
//  OrderWithoutPayVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/26.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "OrderWithoutPayVC.h"
#import "OrderCell.h"
#import "OrderObj.h"
#import "skillObj.h"
#import "MJRefresh.h"
#import "OrderDetailVC.h"
//#import "PayOrderVC.h"
#import "PayPageVC.h"


#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface OrderWithoutPayVC ()

@property (nonatomic, retain)NSString *orderState;
@property (nonatomic) NSMutableArray *orderList;
@property (nonatomic, strong)UIImageView *noOrderImgView;
@property (nonatomic, strong)UILabel *noOrderLbl;
@property (nonatomic)bool getData;
@end

@implementation OrderWithoutPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderState = @"待付款";
    self.title = @"待付款";
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
    _noOrderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4,40,SCREEN_WIDTH/2,SCREEN_WIDTH/2)];
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
}

// 头部的下拉刷新触发事件
- (void)headerClick {
    [self getOrderListByState];
    [NSThread sleepForTimeInterval:3];
    //由于获取数据是另开启线程，此处将动画持续3秒
    [self.tableView.mj_header endRefreshing];
}
//原文：https://blog.csdn.net/u013892686/article/details/51941286

-(void)getOrderListByState{
    NSArray *stateList =[NSArray arrayWithObjects:[NSNumber numberWithInt:12],nil];
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
    //    c.servicerName.text = [NSString stringWithFormat:@"%d",obj.servicerId];
    c.servicerName.text = obj.servicerName;
    c.state.text = [OrderObj getOrderStateInStr:obj.state];
    c.time.text = obj.createTime;
    c.content.text = obj.servicerContent;
    c.price.text = [NSString stringWithFormat:@"￥%.2f",obj.total];
//    c.btn.hidden = YES;
    [c.btn setTitle:@"支付" forState:UIControlStateNormal];
    [c.btn addTarget:self action:@selector(toPay:) forControlEvents:UIControlEventTouchUpInside];
    c.btn.tag = indexPath.row;
//    NSLog(@"测试orderId数据传值：%d",[obj.orderId longLongValue]);
    c.img.image = [UIImage imageNamed:@"icon_default_head.png"];
    return c;
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
-(void)toPay:(UIButton *)btn{
    
//    PayOrderVC *vc = [[PayOrderVC alloc]init];
//    [vc setOrderId:btn.tag isHomeFee:true];
////    NSLog(@"测试orderId数据传值：%d",btn.tag);
//    [self.navigationController pushViewController:vc animated:NO];
    
    OrderObj *obj = [_orderList objectAtIndex:btn.tag];
    PayPageVC *vc = [[PayPageVC alloc]init];
    [vc setType:0 setId:[obj.orderId longLongValue] tip:[NSString stringWithFormat:@"请支付上门费:%.2f元",obj.homeFee]];
    [self.navigationController pushViewController:vc animated:NO];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self getOrderListByState];
}
@end
//
//  OrderDetailVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/3.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderObj.h"
#import "SkillObj.h"
#import "SkillsCellOfOrderDetail.h"
#import "SubmitCommentVC.h"
#import "ApplyReceipt.h"
#import "BtnForOrderDetail.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface OrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) UIScrollView *indexscrol;
@property(strong, nonatomic) UILabel *nameLbl;
@property(strong, nonatomic) UILabel *stateLbl;
@property(strong, nonatomic) UILabel *addressContentLbl;
@property(strong, nonatomic) UILabel *addressNameLbl;
@property(strong, nonatomic) UILabel *serverTimeLbl;
//@property(strong, nonatomic) UILabel *distanceLbl;
//@property(strong, nonatomic) NSString *homeFeeNum;
//@property(strong, nonatomic) UILabel *homeFee;
//@property(strong, nonatomic) UILabel *addressLbl;
//@property(strong, nonatomic) UILabel *introductionLbl;
//@property(strong, nonatomic) UILabel *orderCntLbl;
//@property(strong, nonatomic) UIButton *toOrderPage;
@property(strong, nonatomic) OrderObj *order;
@property(strong, nonatomic) SkillObj *skill;

@property(strong, nonatomic) UITableView *tableView;
@property(nonatomic) bool homeFee;
@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

-(void)initFrame:(OrderObj *)obj{
    _order = obj;
    CGFloat topOffset = statusBarFrame.size.height+navigationHeight+8;
    int splitHei = 10;
    int normalLblHei = 30;
    //############################ScrollCView滚动条
    _indexscrol = [[UIScrollView alloc] init];
    
    _indexscrol.frame = CGRectMake(0,0, SCREEN_WIDTH, self.view.bounds.size.height-60);
    _indexscrol.backgroundColor = [UIColor whiteColor];
    _indexscrol.showsVerticalScrollIndicator = NO;
    _indexscrol.showsHorizontalScrollIndicator = NO;
    _indexscrol.delegate = self;
    
    UILabel *split0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, splitHei)];
    split0.backgroundColor = grayBgColor;
    [self.indexscrol addSubview:split0];
    
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(5, split0.frame.origin.x+splitHei, 40, 40)];
    logo.image = [UIImage imageNamed:@"icon_logo.jpg"];
//    logo.backgroundColor = [UIColor grayColor];
    [self.indexscrol addSubview:logo];
    
    
    _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(logo.frame.origin.x+logo.frame.size.width+5, logo.frame.origin.y, 300, 40)];
    _nameLbl.text = obj.servicerName;
    _nameLbl.font = [UIFont systemFontOfSize:20];
    _nameLbl.textColor = textColorGray;
    [self.indexscrol addSubview:_nameLbl];
    _stateLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-105, logo.frame.origin.y, 100, 40)];
    _stateLbl.text = [OrderObj getOrderStateInStr:obj.state];
    _stateLbl.font = [UIFont systemFontOfSize:18];
    _stateLbl.textColor = textColorBlue;
    _stateLbl.textAlignment = NSTextAlignmentRight;
    [self.indexscrol addSubview:_stateLbl];
    UILabel *split1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _nameLbl.frame.origin.y+_nameLbl.frame.size.height, SCREEN_WIDTH, splitHei)];
    split1.backgroundColor = grayBgColor;
    [self.indexscrol addSubview:split1];
//    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(5, _stateLbl.frame.origin.y+_stateLbl.frame.size.height+3, SCREEN_WIDTH-10, splitHei)];
//    line1.backgroundColor = grayBgColor;
//    [self.indexscrol addSubview:line1];
    
    CGFloat itemHei = 90;
    if(_order.state != 20)
        itemHei = 60;//20是已完成状态的订单，需要增加一行按键。其他不需要按键，在后续布局中将按键隐藏，高度置0；tableview的行高减小30；
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, split1.frame.origin.y+splitHei, SCREEN_WIDTH, [obj.skillsList count]*itemHei)];
    [self.tableView registerClass:[SkillsCellOfOrderDetail class] forCellReuseIdentifier:@"mycell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = itemHei;
    //    self.tableView.frame = CGRectMake(0, line1.frame.origin.y+6, SCREEN_WIDTH, 600);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.indexscrol addSubview:_tableView];
    UILabel *split2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _tableView.frame.origin.y+_tableView.frame.size.height, SCREEN_WIDTH, splitHei)];
    split2.backgroundColor = grayBgColor;
    [self.indexscrol addSubview:split2];
    
    UILabel *orderIdLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, split2.frame.origin.y+splitHei, SCREEN_WIDTH-10, normalLblHei)];
    orderIdLbl.text = [NSString stringWithFormat:@"订单编号:%@",obj.orderId];
    orderIdLbl.textColor = textColorGray;
    [self.indexscrol addSubview:orderIdLbl];
    UILabel *orderTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(5,  orderIdLbl.frame.origin.y+orderIdLbl.frame.size.height+3, SCREEN_WIDTH-10, normalLblHei)];
    orderTimeLbl.text = [NSString stringWithFormat:@"下单时间:%@",obj.createTime];
    orderTimeLbl.textColor = textColorGray;
    [self.indexscrol addSubview:orderTimeLbl];
    UILabel *split3 = [[UILabel alloc]initWithFrame:CGRectMake(0, orderTimeLbl.frame.origin.y+orderTimeLbl.frame.size.height, SCREEN_WIDTH, splitHei)];
    split3.backgroundColor = grayBgColor;
    [self.indexscrol addSubview:split3];

    UILabel *payWay = [[UILabel alloc]initWithFrame:CGRectMake(5, split3.frame.origin.y+splitHei, SCREEN_WIDTH-10, normalLblHei)];
    payWay.textColor = textColorGray;
    UILabel *payTime = [[UILabel alloc]initWithFrame:CGRectMake(5, payWay.frame.origin.y+payWay.frame.size.height, SCREEN_WIDTH-10, normalLblHei)];
    payTime.textColor = textColorGray;
    [self.indexscrol addSubview:payWay];
    [self.indexscrol addSubview:payTime];
    UILabel *split4 = [[UILabel alloc]initWithFrame:CGRectMake(0, payTime.frame.origin.y+payTime.frame.size.height, SCREEN_WIDTH, splitHei)];
    split4.backgroundColor = grayBgColor;
    [self.indexscrol addSubview:split4];
    if(obj.state > 20){
        payWay.text = [NSString stringWithFormat:@"支付方式：%@",obj.servicePayBy];
        payTime.text = [NSString stringWithFormat:@"支付时间：%@",obj.servicePayTime];
        _homeFee = true;
    }
    else if(obj.state > 12){
        payWay.text = [NSString stringWithFormat:@"支付方式：%@",obj.homePayBy];
        payTime.text = [NSString stringWithFormat:@"支付时间：%@",obj.homePayTime];
        _homeFee = true;
    }
    else{
        payWay.hidden = YES;
        payTime.hidden = YES;
        split4.frame = CGRectMake(0, orderTimeLbl.frame.origin.y+orderTimeLbl.frame.size.height, SCREEN_WIDTH, splitHei);
        _homeFee = false;
    }
    
    _addressContentLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, split4.frame.origin.y+splitHei, SCREEN_WIDTH-10, normalLblHei)];
    _addressContentLbl.textColor = textColorGray;
    NSArray *addressInfo = [obj.address componentsSeparatedByString:@"&"];
    if([addressInfo count] != 3){
        _addressContentLbl.text = [NSString stringWithFormat:@"服务地址：%@",obj.address];
    }
    else{
//        _addressNameLbl.text = [addressInfo objectAtIndex:0];
//        _serverTimeLbl.text = [addressInfo objectAtIndex:1];
        _addressContentLbl.text = [NSString stringWithFormat:@"服务地址：%@",[addressInfo objectAtIndex:2]];
    }
    _serverTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, _addressContentLbl.frame.origin.y+ _addressContentLbl.frame.size.height+3, SCREEN_WIDTH-10, normalLblHei)];
    _serverTimeLbl.textColor = textColorGray;
    _serverTimeLbl.text = [NSString stringWithFormat:@"上门时间：%@",obj.dateExpected];
//    [self.indexscrol addSubview:_addressNameLbl];
    [self.indexscrol addSubview:_serverTimeLbl];
    [self.indexscrol addSubview:_addressContentLbl];
    UILabel *split5 = [[UILabel alloc]initWithFrame:CGRectMake(0, _serverTimeLbl.frame.origin.y+_serverTimeLbl.frame.size.height, SCREEN_WIDTH, splitHei)];
    split5.backgroundColor = grayBgColor;
    [self.indexscrol addSubview:split5];


    UILabel *totalLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, split5.frame.origin.y+splitHei, 200, normalLblHei)];
    totalLbl.text = @"费用总额";
    totalLbl.textColor = textColorGray;
    UILabel *numLblT = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-105, totalLbl.frame.origin.y, 100, normalLblHei)];
    numLblT.text = [NSString stringWithFormat:@"￥%.2f",obj.total];
    numLblT.textAlignment = NSTextAlignmentRight;
    numLblT.textColor = textColorGray;
    UILabel *homeFeeLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, totalLbl.frame.origin.y+totalLbl.frame.size.height+3, 200, normalLblHei)];
    homeFeeLbl.text = @"上门费";
    homeFeeLbl.textColor = textColorGray;
    UILabel *numLblH = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-105, homeFeeLbl.frame.origin.y, 100, normalLblHei)];
    numLblH.text = [NSString stringWithFormat:@"￥%.2f",obj.homeFee];
    numLblH.textAlignment = NSTextAlignmentRight;
    numLblH.textColor = textColorGray;
    UILabel *serverFeeLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, homeFeeLbl.frame.origin.y+homeFeeLbl.frame.size.height+3, 200, normalLblHei)];
    serverFeeLbl.text = @"服务费";
    serverFeeLbl.textColor = textColorGray;
    UILabel *numLblS = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-105, serverFeeLbl.frame.origin.y, 100, normalLblHei)];
    numLblS.text = [NSString stringWithFormat:@"￥%.2f",obj.total-obj.homeFee];
    numLblS.textAlignment = NSTextAlignmentRight;
    numLblS.textColor = textColorGray;
    [self.indexscrol addSubview:homeFeeLbl];
    [self.indexscrol addSubview:serverFeeLbl];
    [self.indexscrol addSubview:totalLbl];
    [self.indexscrol addSubview:numLblT];
    [self.indexscrol addSubview:numLblH];
    [self.indexscrol addSubview:numLblS];
    UILabel *split6 = [[UILabel alloc]initWithFrame:CGRectMake(0, serverFeeLbl.frame.origin.y+serverFeeLbl.frame.size.height, SCREEN_WIDTH, splitHei)];
    split6.backgroundColor = grayBgColor;
    [self.indexscrol addSubview:split6];
    

    UILabel *btnBackground = [[UILabel alloc]initWithFrame:CGRectMake(0, split6.frame.origin.y+splitHei, SCREEN_WIDTH, normalLblHei)];
    btnBackground.backgroundColor = [UIColor whiteColor];
    [self.indexscrol addSubview:btnBackground];
    
    int btnNum = 2;
    if(obj.state >=20 || obj.state <0)
        btnNum = 1;
    int btnWid = 120;
    NSMutableArray *btnOrigin = @[].mutableCopy;
    int origin = (SCREEN_WIDTH - btnNum*btnWid-(btnNum-1)*10)/2;
    for(int i = 0;i<btnNum;i++){
        [btnOrigin addObject:[NSNumber numberWithInteger:(origin + i*(btnWid+10))]];
    }
    int i=0;
    BtnForOrderDetail *callBtn = [[BtnForOrderDetail alloc] initWithFrame:CGRectMake([[btnOrigin objectAtIndex:i++]intValue], btnBackground.frame.origin.y, btnWid, normalLblHei)];
    [callBtn setTitle:@"联系商家" forState:UIControlStateNormal];
    [callBtn setImage:[UIImage imageNamed:@"icon_phone.png"] forState:UIControlStateNormal];
    callBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    callBtn.backgroundColor = [UIColor whiteColor];
    [callBtn setTitleColor:textColorGray forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    [self.indexscrol addSubview:callBtn];
    BtnForOrderDetail *cancelBtn;
    if(obj.state >=0 && obj.state <20){
        cancelBtn = [[BtnForOrderDetail alloc] initWithFrame:CGRectMake([[btnOrigin objectAtIndex:i++]intValue], btnBackground.frame.origin.y, btnWid, normalLblHei)];
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancelBtn setImage:[UIImage imageNamed:@"icon_phone.png"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitleColor:textColorGray forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        [self.indexscrol addSubview:cancelBtn];
    }
//    链接：https://www.jianshu.com/p/d24cec6dada3
    
    if(btnBackground.frame.origin.x+normalLblHei+25 < SCREEN_HEIGHT){
        split6.frame = CGRectMake(0, serverFeeLbl.frame.origin.y+serverFeeLbl.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - split6.frame.origin.y-splitHei);
    }
    
    _indexscrol.contentSize = CGSizeMake(0, split6.frame.origin.y+splitHei+25);
    [self.view addSubview:_indexscrol];
    [self.tableView reloadData];
    
}
-(void)cancelOrder{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@/app/client/appOrder/%@",baseUrl,_homeFee?@"cancel":@"cancelling"];
        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:_order.orderId ,@"orderId",
                              [defaults stringForKey:@"userId"],@"userId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:dic SuccessBlock:^(id responseObject) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 0){
                [MyUtils alertMsg:@"订单取消成功" method:@"cancelOrder" vc:self];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"订单取消失败：%@",error] method:@"cancelOrder" vc:self];
            }
        } FailureBlock:^(id error) {
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误%@",error] method:@"cancelOrder" vc:self];
        }];
    });
}
//这里没有传入服务人员电话，需要从数据库获取
-(void)makeCall{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@/qwt/server/Server/showServer",baseUrl];
        NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:_order.servicerId ,@"serverId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 1){
                //success body
                NSArray *rowsArr = dict[@"data"];
                if([rowsArr count]==0){
                    [MyUtils alertMsg:@"data数组为空，请重试" method:@"getSkillByServicerId" vc:self];
                    return;
                }
                dict = [rowsArr objectAtIndex:0];
                NSString *str= [NSString stringWithFormat:@"tel:%@",[dict objectForKey:@"phoneNum"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取服务人员联系方式失败：error:%@",error] method:@"makeCall" vc:self];
            }
            //            _gettingServerData = false;
        } FailureBlock:^(id error) {
            [MyUtils alertMsg:@"请求错误" method:@"makeCall" vc:self];
            //            _gettingServerData = false;
        }];
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%d",[_order.skillsList count]);
    return [_order.skillsList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SkillsCellOfOrderDetail *c = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    SkillObj *so = [_order.skillsList objectAtIndex:indexPath.row];
    CGFloat blank = 5;//距离两侧的边距
    c.content.text = [NSString stringWithFormat:@"%@", so.lv3];
    c.price.text = [NSString stringWithFormat:@"单价￥%.2f/%@", so.price, so.unit];
    c.num.text = [NSString stringWithFormat:@"数量:%d", so.num];
    c.total.text = [NSString stringWithFormat:@"合计￥%.2f", so.price*so.num];
//    if(_order.state == 10 || _order.state == 12 || _order.state == 14 || _order.state == 16 || _order.state == 18){
    if(_order.state <= 18){
        c.btn1.frame = CGRectMake(0, c.price.frame.origin.y+c.price.frame.size.height+9, 0, 0);
        c.btn1.hidden = YES;
        c.btn2.frame = CGRectMake(0, c.price.frame.origin.y+c.price.frame.size.height+9, 0, 0);
        c.btn2.hidden = YES;
        c.line.hidden = YES;
    }
    else if(_order.state == 20){
        [c.btn1 addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        [c.btn1 setTitle:@"评价" forState:UIControlStateNormal];
        c.btn1.tag = indexPath.row;
        [c.btn2 addTarget:self action:@selector(receipt:) forControlEvents:UIControlEventTouchUpInside];
        [c.btn2 setTitle:@"投诉" forState:UIControlStateNormal];
        c.btn2.tag = indexPath.row;
    }
    else{
        [MyUtils alertMsg:@"订单状态错误" method:@"cellForRowAtIndexPath" vc:self];
    }
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5, c.btn1.frame.origin.y+c.btn1.frame.size.height+2, SCREEN_WIDTH-10, 1)];
    line.backgroundColor = grayBgColor;
    [c.contentView addSubview:line];
    c.selectionStyle = UITableViewCellSelectionStyleNone;
    return c;
}
-(void)receipt:(UIButton *)btn{
    ApplyReceipt *vc = [[ApplyReceipt alloc]init];
    [vc setAndInit:_order setSkill:[_order.skillsList objectAtIndex:btn.tag]];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)comment:(UIButton*)btn{
    SubmitCommentVC *vc = [[SubmitCommentVC alloc]init];
//    [vc setOrderId:_orderId setServerId:_serverId];
    [vc initFrameWithData:_order skill:[_order.skillsList objectAtIndex:btn.tag]];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden= YES;
}

@end

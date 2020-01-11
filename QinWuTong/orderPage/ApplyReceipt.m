//
//  ApplyReceipt.m
//  QinWuTong
//
//  Created by ltl on 2019/1/10.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "ApplyReceipt.h"
#import "SkillObj.h"
#import "OrderObj.h"
#import "EBDropdownListView.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface ApplyReceipt ()
//@property (nonatomic, retain)NSString *serverId;
@property (nonatomic, retain)NSString *afterSalesCategory;
@property (nonatomic, retain)SkillObj *skill;
@property (nonatomic, retain)OrderObj *order;
@property(strong, nonatomic) UITextField *recepitContent;
@end

@implementation ApplyReceipt
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请售后";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
}

-(void)setAndInit:(OrderObj *)obj setSkill:(SkillObj *)skill{
    _order = obj;
//    _serverId = obj.servicerId;
    _skill = skill;
    UILabel *serverName = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-10, 24)];
    serverName.text = obj.servicerName;
    serverName.font = [UIFont systemFontOfSize:20];
    UILabel *stateLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-105, 5, 100, 24)];
    stateLbl.text = [OrderObj getOrderStateInStr:obj.state];
    stateLbl.font = [UIFont systemFontOfSize:20];
    stateLbl.textColor = textColorBlue;
    stateLbl.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:serverName];
    [self.view addSubview:stateLbl];
    UILabel *skillLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, stateLbl.frame.origin.y+stateLbl.frame.size.height+3, SCREEN_WIDTH-10, 24)];
    skillLbl.text = skill.lv3;
    skillLbl.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:skillLbl];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(5, skillLbl.frame.origin.y+skillLbl.frame.size.height+3, SCREEN_WIDTH-10, 1)];
    line1.backgroundColor = grayBgColor;
    [self.view addSubview:line1];
    
    UILabel *categoryLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, line1.frame.origin.y+6, 140, 24)];
    categoryLbl.text = @"请选择投诉类型：";
    categoryLbl.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:categoryLbl];
    
    EBDropdownListItem *item1 = [[EBDropdownListItem alloc] initWithItem:@"1" itemName:@"服务质量不满意"];
    EBDropdownListItem *item2 = [[EBDropdownListItem alloc] initWithItem:@"2" itemName:@"服务态度不佳"];
    EBDropdownListItem *item3 = [[EBDropdownListItem alloc] initWithItem:@"3" itemName:@"超时完成"];
    EBDropdownListItem *item4 = [[EBDropdownListItem alloc] initWithItem:@"4" itemName:@"item4"];
    // 弹出框向下
    EBDropdownListView *dropdownListView1 = [EBDropdownListView new];
    dropdownListView1.dataSource = @[item1, item2, item3, item4];
    dropdownListView1.frame = CGRectMake(categoryLbl.frame.origin.x+categoryLbl.frame.size.width+5, line1.frame.origin.y+6, 130, 24);
    dropdownListView1.selectedIndex = 0;
    _afterSalesCategory = item1.itemName;
    [dropdownListView1 setViewBorder:0.5 borderColor:[UIColor grayColor] cornerRadius:2];
    [self.view addSubview:dropdownListView1];
    [dropdownListView1 setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
        NSString *msg = [NSString stringWithFormat:
                               @"selected name:%@  id:%@  index:%ld"
                               , dropdownListView.selectedItem.itemName
                               , dropdownListView.selectedItem.itemId
                               , dropdownListView.selectedIndex];
        [MyUtils debugMsg:msg vc:self];
        _afterSalesCategory = dropdownListView.selectedItem.itemName;
    }];
    
    UILabel *contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, categoryLbl.frame.origin.y+categoryLbl.frame.size.height+3, 140, 24)];
    contentLbl.text = @"请填写投诉原因：";
    contentLbl.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:contentLbl];
    

    _recepitContent = [[UITextField alloc]initWithFrame:CGRectMake(5, contentLbl.frame.origin.y+contentLbl.frame.size.height+5, SCREEN_WIDTH-10, 28*7)];//默认7行的高度
    _recepitContent.backgroundColor = tfBgColor;
    _recepitContent.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [self.view addSubview:_recepitContent];
    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(10, _recepitContent.frame.origin.y+_recepitContent.frame.size.height+5, SCREEN_WIDTH-20, 40)];
    [submit setTitle:@"提  交" forState:UIControlStateNormal];
    submit.titleLabel.textColor = textColorOnBg;
    submit.titleLabel.font = [UIFont systemFontOfSize:28];
    submit.backgroundColor = themeColor;
    submit.layer.cornerRadius = 4;
    [submit addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
}

-(void)submitClick{
    if([MyUtils isBlankString:_recepitContent.text]){
        [MyUtils alertMsg:@"请填写投诉原因" method:@"submitClick" vc:self];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *reason = self.recepitContent.text;
        if([MyUtils isBlankString:reason])
            reason = @"";
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%d",_skill.skillId],@"goodsId",
                             [defaults stringForKey:@"userId"],@"userId",
                             [NSString stringWithFormat:@"%@",_order.servicerId],@"serverId",
                             [NSString stringWithFormat:@"%@",_skill.lv3],@"content",
                             [NSString stringWithFormat:@"%@",_afterSalesCategory],@"afterSalesCategory",
                             reason,@"reason",
                             nil];//根据后台管理平台需要拼接三级分类
//        [MyUtils testUrl:dic];
//        return ;
        [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appGoods/afterSales", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 0){
                NSLog(@"提交投诉成功jason:%@",responseObject);
                //                [self.navigationController popToRootViewControllerAnimated:YES];
                //                self.tabBarController.selectedIndex = 2;
//                [self.navigationController popViewControllerAnimated:YES];
                [MyUtils alertMsg:@"提交投诉成功" method:@"submitClick" vc:self];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"提交投诉失败：error:%@",error] method:@"submitClick" vc:self];
            }
        } FailureBlock:^(id error){
            //                NSLog(@"订单提交失败error:%@",error);
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误error:%@",error] method:@"submitClick" vc:self];
        }
         ];
    });
}
//在textfield中输入弹出键盘后，点击背景收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

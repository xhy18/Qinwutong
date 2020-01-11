//
//  ChangeAddressVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/26.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "AddressManagerVC.h"
#import "SubmitOrderVC.h"
#import "UserAddressCell.h"
#import "UserAddressInfoObj.h"
#import "EditAddressVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface AddressManagerVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic) SubmitOrderVC *submitOrderVC;
@property(nonatomic) NSMutableArray *addressArr;
@property(strong , nonatomic)UITableView *addressList;
@end

@implementation AddressManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更换地址";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    [self.tableView registerClass:[UserAddressCell class] forCellReuseIdentifier:@"mycell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 48;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50);
//    self.view.backgroundColor = grayBgColor;

//    CGFloat topOffset = 0;
    CGFloat topOffset = statusBarFrame.size.height+navigationHeight;
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-topOffset-90, SCREEN_WIDTH-20, 40)];
    [addBtn setTitle:@"添加地址" forState:UIControlStateNormal];
    addBtn.titleLabel.textColor = textColorOnBg;
    addBtn.titleLabel.font = [UIFont systemFontOfSize:28];
    addBtn.backgroundColor = themeColor;
    addBtn.layer.cornerRadius = 4;
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
}

-(void)addAddress{
    EditAddressVC *vc = [[EditAddressVC alloc]init];
    [vc setAddressObj:nil];//加入地址为空，判断为新增地址
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)initVC:(SubmitOrderVC *)vc{
    _submitOrderVC = vc;
    [self.tableView reloadData];
}

-(void)choose:(UIButton *)btn{
    UserAddressInfoObj *uo = [_addressArr objectAtIndex:btn.tag];
    [_submitOrderVC showAddress:uo];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toEditPage:(UIButton *)btn{
    UserAddressInfoObj *uo = [_addressArr objectAtIndex:btn.tag];
    if(!uo){
        [MyUtils alertMsg:[NSString stringWithFormat:@"未选中地址信息"] method:@"toEditPage" vc:self];
        return;
    }
    EditAddressVC *vc = [[EditAddressVC alloc]init];
    [vc setAddressObj:uo];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)getAddress{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appAddress/", baseUrl]Dic:dic SuccessBlock:^(id responseObject){
            NSLog(@"获取用户地址信息成功jason:%@",responseObject);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //            NSLog(jsonData);
            int res = [[d objectForKey:@"code"]integerValue];
            if(res == 0){
                //success body
                NSArray *rowsArr = d[@"data"];
                self.addressArr = @[].mutableCopy;
                int tag = -1;
                for(NSDictionary *dict in rowsArr){
                    UserAddressInfoObj *ao = [UserAddressInfoObj new];
                    ao.name = [dict objectForKey:@"name"];
                    ao.tel = [dict objectForKey:@"phone"];
                    ao.address = [dict objectForKey:@"address"];
                    ao.id = [dict objectForKey:@"id"];
                    NSString *tmp =[dict objectForKey:@"flag"];//获取默认地址，1是默认，其他为0
                    if([tmp integerValue] == 1){//如果是1，此时记录下arr的count，就是要显示的地址；如果从未有记录，tag == -1，显示第一个地址
                        tag = [_addressArr count];
                        ao.isdefault = true;
                    }
                    else
                        ao.isdefault = false;
                    [_addressArr addObject:ao];
                }
                [self.tableView reloadData];
            }
            else{
                NSString *error = [d objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取用户地址失败：error:%@",error] method:@"getAddress" vc:self];
            }
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"getAddress" vc:self];
        }];
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_addressArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserAddressCell *c = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    UserAddressInfoObj *obj = [_addressArr objectAtIndex:indexPath.row];
    
    c.name.text = obj.name;
    c.address.text = obj.address;
    c.tel.text = obj.tel;
    c.selectionStyle = UITableViewCellSelectionStyleNone;
    c.edit.tag = indexPath.row;
    c.choose.tag = indexPath.row;
    [c.choose addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [c.edit addTarget:self action:@selector(toEditPage:) forControlEvents:UIControlEventTouchUpInside];
    return c;
}
//点击item方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击事件用于选择地址，向订单提交页面返回选择的地址；从个人中心中进入地址管理页面，则未传入submitOrderVC，不执行点击事件
    if(!_submitOrderVC)
        return;
    UserAddressInfoObj *uo = [_addressArr objectAtIndex:indexPath.row];
    [_submitOrderVC showAddress:uo];
    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"%d",c.btn.tag);
}


//-(void)viewWillAppear:(BOOL)animated{
//    //    self.navigationController.navigationBarHidden = NO;
//    //    self.tabBarController.tabBar.hidden=YES;
//    //    self.tabBarController.tabBar.hidden=YES;
//    //    self.navigationController.navigationBarHidden = YES;
//}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
    //因为会新增、编辑地址，为了在返回页面时能获取到最新的数据，在此读取数据。
    [self getAddress];
    [_submitOrderVC updateAddressArr:_addressArr];
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

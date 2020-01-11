//
//  PersonallnfoVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/31.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "PersonalCenterVC.h"
#import "LoginPageVC.h"
#import "PersonalCenterCell.h"
#import "PersonInfoVC.h"
#import "EnterpriseInfoVC.h"
#import "JobsListVC.h"
#import "WalletVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface PersonalCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) UITableView *itemList;
@property(strong, nonatomic) UIImageView *photo;
@property(strong, nonatomic) UIImage *imgFromUrl;
@property(strong, nonatomic) UILabel *userName;
@property(strong, nonatomic) NSArray *itemName;
@property(strong, nonatomic) NSArray *itemIcon;
@property(strong, nonatomic) NSArray *itemPage;
@property(strong, nonatomic) NSString *picUrl;
@end

@implementation PersonalCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
//                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
//    self.navigationController.navigationBar.barTintColor = themeColor;
//    [[UINavigationBar appearance] setTintColor:textColorOnBg];
//    CGFloat topOffset = statusBarFrame.size.height+navigationHeight;
    
    self.view.backgroundColor = grayBgColor;
    CGFloat photoHei = 100;
    UILabel *topBg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, photoHei+60+24)];
    topBg.backgroundColor = themeColor;
    [self.view addSubview:topBg];
    
    //用户头像
    _photo = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-photoHei)/2, 40, photoHei, photoHei)];
    _photo.layer.masksToBounds=YES;
    _photo.layer.cornerRadius=photoHei/2;
    [self getPhoto];
    
    //用户名称
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(0, _photo.frame.origin.y+photoHei+10, SCREEN_WIDTH, 24)];
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.font = [UIFont systemFontOfSize:22];
    _userName.textColor = textColorOnBg;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults stringForKey:@"userId"])
        _userName.text = @"（尚未填写用户姓名）";
    else{
        _userName.text = [defaults stringForKey:@"userName"];
    }
    [self.view addSubview:_photo];
    [self.view addSubview:_userName];
    
    CGFloat itemHei = 54;
    //个人用户
    if([[defaults stringForKey:@"userType"] isEqualToString:@"10"]){
        _itemName = [NSArray arrayWithObjects:@"个人信息",@"服务地址",@"我的钱包",nil];
        _itemIcon = [NSArray arrayWithObjects:@"icon_person_info.png",@"icon_address.png",@"icon_wallet.png",nil];
        _itemPage = [NSArray arrayWithObjects:@"PersonInfoVC",@"AddressManagerVC",@"WalletVC",nil];
    }
    else{
        //企业用户
        _itemName = [NSArray arrayWithObjects:@"个人信息",@"服务地址",@"我的钱包",@"查看招聘",nil];
        _itemIcon = [NSArray arrayWithObjects:@"icon_person_info.png",@"icon_address.png",@"icon_wallet.png",@"icon_red.png",nil];
        _itemPage = [NSArray arrayWithObjects:@"EnterpriseInfoVC",@"AddressManagerVC",@"WalletVC",@"JobsListVC",nil];
    }
    
    _itemList = [[UITableView alloc]initWithFrame:CGRectMake(0, topBg.frame.origin.y+topBg.frame.size.height+30, SCREEN_WIDTH, itemHei*[_itemName count])];//+3*([_itemName count]-1)
    _itemList.delegate = self;
    _itemList.dataSource = self;
    _itemList.rowHeight = itemHei;
    [_itemList registerClass:[PersonalCenterCell class] forCellReuseIdentifier:@"mycell"];
    _itemList.scrollEnabled = NO;
    [self.view addSubview:_itemList];
    
//    UIButton *outLogin = [UIButton buttonWithType:UIButtonTypeSystem];
//    [outLogin setTitle:@"退出登录" forState:UIControlStateNormal];
//    outLogin.frame=CGRectMake(0, topBg.frame.origin.y+topBg.frame.size.height+60, SCREEN_WIDTH, 30);
//    outLogin.backgroundColor = [UIColor redColor];
//    outLogin.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    [outLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [outLogin addTarget:self action:@selector(outlogin) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:outLogin];
}
//退出登录
-(void)outlogin{
    NSLog(@"退出登录");
}

//用于刷新图片，主要是上传头像成功后直接掉用该函数进行刷新
-(void)refreshPhoto:(UIImage *)img{
    _photo.image = img;
}

//获取用户头像。其实也可以建立存储user数据的model，在此获取整个user数据，传入到PersonInfo页面，就不用发起两次请求了。现在只获取了头像传到下个页面
-(void)getPhoto{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",nil];
        NSString *url;
        if([[defaults stringForKey:@"userType"] isEqualToString:@"10"])
            url = [NSString stringWithFormat:@"%@/app/client/appUser/personalInfo", baseUrl];
        else
            url = [NSString stringWithFormat:@"%@/app/client/appUser/enterpriseInfo", baseUrl];
        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:dic SuccessBlock:^(id responseObject){
            NSLog(@"请求成功jason:%@",responseObject);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //            NSLog(jsonData);
            int res = [[d objectForKey:@"code"]integerValue];
            if(res == 0){
                _picUrl;
                if([MyUtils isBlankString:responseObject[@"data"][@"picture"]]){
                    _picUrl = nil;
                    _photo.image = [UIImage imageNamed:@"icon_default_head.png"];
                }
                else{
                    _picUrl = responseObject[@"data"][@"picture"];
                    [MyUtils debugMsg:_picUrl vc:self];
//                    [self downloadImage:picUrl];
                    NSURL *imageUrl = [NSURL URLWithString:_picUrl];
                    _imgFromUrl = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                    _photo.image = _imgFromUrl;
                }
            }
            else{
                NSString *error = [d objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取用户头像失败：error:%@",error] method:@"getPhoto" vc:self];
            }
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"getPhoto" vc:self];
        }];
    });
}
- (void)downloadImage:(NSString *)url{
    if(url){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSURL *imageUrl = [NSURL URLWithString:url];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            _photo.image = image;
        });
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_itemName count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalCenterCell *c = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    c.icon.image = [UIImage imageNamed:[_itemIcon objectAtIndex:indexPath.row]];
    c.title.text = [_itemName objectAtIndex:indexPath.row];
    c.moreInfo.tag = indexPath.row;
    [c.moreInfo addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    c.selectionStyle = UITableViewCellSelectionStyleNone;
    return c;
}
//点击item方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){//个人/企业信息页面需要传入参数，单独设置一下
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[defaults stringForKey:@"userType"] isEqualToString:@"10"]){
            PersonInfoVC *vc = [[PersonInfoVC alloc]init];
            [vc setPersonalCenterVC:self setPhoto:_imgFromUrl];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else{
            EnterpriseInfoVC *vc = [[EnterpriseInfoVC alloc]init];
            [vc setPersonalCenterVC:self setPhoto:_imgFromUrl];
            [self.navigationController pushViewController:vc animated:NO];
        }
        return;
    }
    Class class = NSClassFromString([_itemPage objectAtIndex:indexPath.row]);
    if (class) {
        UIViewController *vc = [[class alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
-(void)moreInfo:(UIButton *)btn{
//    PersonInfoVC *vc = [[PersonInfoVC alloc] init];
//    [self.navigationController pushViewController:vc animated:NO];
    Class class = NSClassFromString([_itemPage objectAtIndex:btn.tag]);
    if (class) {
        UIViewController *vc = [[class alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}


//进入页面时隐藏顶部导航栏
-(void)viewWillAppear:(BOOL)animated{
    [self getPhoto];
    self.tabBarController.tabBar.hidden=NO;//显示底部tabBar
    self.navigationController.navigationBarHidden = YES;//隐藏顶部导航栏
}
//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//    self.tabBarController.tabBar.hidden=YES;
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

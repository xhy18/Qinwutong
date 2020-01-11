//
//  JobsListVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/12.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "JobsListVC.h"
#import "JobsCell.h"
#import "JobObj.h"
#import "MJRefresh.h"
#import "AdvertisingJobsVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface JobsListVC ()

@property (nonatomic) NSMutableArray *jobList;
@end

@implementation JobsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布的招聘";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.rowHeight = 55;
    [self.tableView registerClass:[JobsCell class] forCellReuseIdentifier:@"mycell"];
    [self getJobList];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-70);
    //    _firstReflash = true;
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-110, SCREEN_WIDTH-20, 40)];
    [addBtn setTitle:@"新增招聘信息" forState:UIControlStateNormal];
    addBtn.titleLabel.textColor = textColorOnBg;
    addBtn.titleLabel.font = [UIFont systemFontOfSize:28];
    addBtn.backgroundColor = themeColor;
    addBtn.layer.cornerRadius = 4;
    [addBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tableView.mj_header = header;
    // Do any additional setup after loading the view.
}
- (void)headerClick {
    [self getJobList];
    [NSThread sleepForTimeInterval:3];
    //由于获取数据是另开启线程，此处将动画持续3秒
    [self.tableView.mj_header endRefreshing];
}

-(void)btnClick{
    AdvertisingJobsVC *vc = [[AdvertisingJobsVC alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)getJobList{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appRecruitment/", baseUrl]Dic:dic SuccessBlock:^(id responseObject){
            NSLog(@"获取招聘信息成功jason:%@",responseObject);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //            NSLog(jsonData);
            
            self.jobList = @[].mutableCopy;
            int res = [[d objectForKey:@"code"]integerValue];
            if(res == 0){
                
                NSArray *rowsArr = d[@"data"];
                for(NSDictionary *dict in rowsArr){
                    JobObj *obj = [JobObj new];
                    obj.jobId = [[dict objectForKey:@"userId"] intValue];
                    obj.positionTitle = [dict objectForKey:@"positionTitle"];
                    obj.deadline = [dict objectForKey:@"deadline"];
                    obj.duties = [dict objectForKey:@"duties"];
                    obj.claim = [dict objectForKey:@"claim"];
                    obj.salary = [dict objectForKey:@"salary"];
                    obj.officialWebsite = [dict objectForKey:@"officialWebsite"];
                    obj.email = [dict objectForKey:@"email"];
                    obj.phone = [dict objectForKey:@"phone"];
                    if([[dict objectForKey:@"number"] isKindOfClass:[NSNull class]])
                        obj.number = 0;
                    else
                        obj.number = [[dict objectForKey:@"number"] intValue];
                    [_jobList addObject:obj];
                }
                [self.tableView reloadData];
            }
            else{
                NSString *error = [d objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取招聘信息失败：error:%@",error] method:@"getJobList" vc:self];
            }
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"getJobList" vc:self];
        }];
    });
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_jobList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JobsCell *c = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    JobObj *obj = [_jobList objectAtIndex:indexPath.row];
    c.positionTitle.text = obj.positionTitle;
    if(obj.number == 0)
        c.number.hidden = YES;
    else
        c.number.text = [NSString stringWithFormat:@"招聘人数:%d",obj.number];
    if([MyUtils isBlankString:obj.deadline])
        c.deadline.text = @"（未设置截止时间）";
    else
        c.deadline.text = obj.deadline;
    return c;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JobObj *obj = [_jobList objectAtIndex:indexPath.row];
    AdvertisingJobsVC *vc = [[AdvertisingJobsVC alloc]init];
    [vc editJobsInfo:obj];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
    [self getJobList];
}

@end

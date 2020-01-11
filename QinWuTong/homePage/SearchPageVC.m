//
//  SearchPageVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/13.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "SearchPageVC.h"
#import "ServiceListVC.h"
#import "ServicerObj.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface SearchPageVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UISearchBar *searchBar;
@property (nonatomic) NSMutableArray *servicers;
@property (nonatomic) CLLocation *location;
@end

@implementation SearchPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.navigationItem.title = @"搜索";
    searchBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
//    searchBar.backgroundColor = bgColor;
    searchBar.barStyle = 0;
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    searchBar.showsCancelButton = YES;
    for (id cencelButton in [searchBar.subviews[0] subviews]){
        if([cencelButton isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    searchBar.placeholder = @"搜索";
//    self.searchBar = searchBar;
    searchBar.delegate =self;
    [self.view addSubview:searchBar];
    // Do any additional setup after loading the view.
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@/qwt/server/Server/showServerByInfo",baseUrl];
        NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  searchBar.text,@"info",
                                  [NSNumber numberWithFloat:_location.coordinate.longitude],@"lon",
                                  [NSNumber numberWithFloat:_location.coordinate.latitude],@"lat",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
            //            NSLog(@"\n\n\n\n:%@",responseObject);
            //            NSData *jsondata = [responseObject];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //            NSLog(jsonData);
            int res = [[d objectForKey:@"code"]integerValue];
            if(res == 1){
                //success body
                NSArray *rowsArr = d[@"data"];
                self.servicers = @[].mutableCopy;
                for(NSDictionary *dict in rowsArr){
                    //            dict = [rowsArr objectAtIndex:0];
                    //            int num =[[dict objectForKey:@"count"] intValue]/2;
                    ServicerObj *servicer = [ServicerObj new];
                    servicer.name = [dict objectForKey:@"realname"];
                    servicer.phone = [dict objectForKey:@"phoneNum"];
                    servicer.servicerId = [dict objectForKey:@"userId"];
                    servicer.sourse = [dict objectForKey:@"sourse"];
                    servicer.score = [dict objectForKey:@"avgscore"];
                    servicer.distance = [dict objectForKey:@"distance"];
                    servicer.skillToShow = [dict objectForKey:@"skill"];
                    servicer.lat = [dict objectForKey:@"lat"];
                    servicer.lon = [dict objectForKey:@"lon"];
                    [_servicers addObject:servicer];
                }
                if([_servicers count]== 0)
                    [MyUtils alertMsg:@"未找到该分类下的服务人员" method:@"getServicersBySkills" vc:self];
                else{
                    ServiceListVC *vc = [[ServiceListVC alloc] init];
                    
                    [vc setTitle:searchBar.text setArr:_servicers];
                    [self.navigationController pushViewController:vc animated:NO];
                }
            }
            else{
                NSString *error = [d objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取服务人员列表失败：error:%@",error] method:@"searchBarSearchButtonClicked" vc:self];
            }
        } FailureBlock:^(id error) {
            [MyUtils alertMsg:@"请求错误" method:@"searchBarSearchButtonClicked" vc:self];
        }];
    });
}

-(void)setLocation:(CLLocation *)location{
    _location = location;
//    [self getServicersBySkills];
}

//在textfield中输入弹出键盘后，点击背景收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//进入页面时隐藏顶部导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;//底部tabBar
    self.navigationController.navigationBarHidden = YES;//顶部导航栏
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

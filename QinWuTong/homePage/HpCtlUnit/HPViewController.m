//
//  HPViewController.m
//  scanmain6.23
//
//  Created by macbook for test on 2018/6/23.
//  Copyright © 2018年 JackPanda8. All rights reserved.
//

#import "HPViewController.h"
#import "ScrollTableViewCell.h"
//#import "IndexBtuTableViewCell.h"
//#import "threeScrollView.h"
//#import "TestViewController.h"
//#import "ResHPViewController.h"
//#import "ScanCodeViewController.h"
//#import "ReListViewController.h"
//#import "LocationTableViewController.h"
//#import "DIYAFNetworking.h"
//#import "MJExtension.h"
//#import "TuiJianRestModel.h"
//#import "UIButton+WebCache.h"
//#import "UIImageView+WebCache.h"
//#import "Restaurant_DetailViewController.h"
//#import "Youhuiquan_ViewController.h"
//#import "Tuancan_ViewController.h"
//#import "Mansong_ViewController.h"
//#import "ReAndPrViewController.h"
//#import "MyUtils.h"
//#import "LLSearchViewController.h"
//#import "SearchViewController.h"    //搜索商家界面
//#import "ReListNewViewController.h"
//#import "ToolHeader.h"

@interface HPViewController ()<UIScrollViewDelegate, UINavigationControllerDelegate>


@property(strong, nonatomic) UIView *topView;
@property(strong, nonatomic) UIScrollView *indexscrol;
@property (nonatomic, strong) NSArray *firstscrimage;
@property (nonatomic, strong) NSArray *firstscrlabel;
@property (nonatomic, strong) NSArray *secondscrimage;
@property (nonatomic, strong) NSArray *secondcrlabel;
@property (nonatomic, strong) NSMutableArray *thirdscrimage;
@property (nonatomic, strong) NSMutableArray *thirdcrlabel;
@property (nonatomic,strong)NSMutableArray * tuijianID;
@property (nonatomic,strong)UILabel *loclabel;
@property(nonatomic,retain)NSMutableArray * imageName;
@property(nonatomic,retain)NSMutableArray * tag_array;

@property (nonatomic,strong)NSString *currlanguage;
@end


@implementation HPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//
//    //*****************************************7.26
//    //存储系统语言
//    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//    NSLog(@"%@",languages[0]);
//    [MyUtils saveAddr:@"user_language.plist" saveKey:@"current_language" saveValue:languages[0]];
//    //***************************************
    NSLog(@"useID:%@",[defaults stringForKey:@"userId"]);
    //[defaults setObject:userId forKey:@"userId"];

//    self.currlanguage = [MyUtils GetTheCurrentLanguage];
//
//    [MyUtils changeLanguage:self.currlanguage strKey:@"emporter"];
//
//    self.firstscrimage = @[@"团餐.png",@"优惠券.png",@"满送.png"];
//    self.firstscrlabel = @[[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_TuanCan"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_coupon"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_mansong"]]; //@[@"REPAS GROUPE",@"COUPON",@"CARTE FIDELITE",@"REPAS GROUPE",@"CARTE FIDELITE",@"OFFRE SPECIALE"];//存放优惠活动名称
//    self.secondscrimage = @[@"法国餐4.jpg",@"日3.jpg",@"意3.jpg",@"中国餐4.jpg",@"德餐2.jpg",@"咖啡1.jpg",@"法国餐4.jpg",@"日3.jpg",@"意3.jpg",@"中国餐4.jpg",@"德餐2.jpg",@"咖啡1.jpg",@"法国餐4.jpg"];
//    self.secondcrlabel =@[[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_french"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_italian"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_chinese"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_japanse"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_bar"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_korean"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_seafood"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_asian"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_european"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_american"],[MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_african"]]; //@[@"French",@"Italian",@"Chinese",@"Japanese",@"Bar",@"Korean",@"Seafood",@"Asian",@"European",@"American",@"African"];//存放分类名称


    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.delegate = self;
//    self.navigationController.navigationBar.barTintColor = Color;
    
//    [self.view addSubview:self.topView];//添加顶部自定义顶部部分
//    self.topView = [[UIView alloc] init];
//    self.topView.frame = CGRectMake(0.0, 0.0, 75.0,60.0);
//    UIImageView *img = [[UIImageView alloc] init];
//    img.image = [UIImage imageNamed:@"LOGO.png"];
//    img.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    img.frame = self.topView.frame;
//    [self.topView addSubview:img];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.topView];
    
//    /********************************定位按钮**************************************/
//    UIView * left_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    locationButton.frame = left_view.frame;
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"toollocation.png" ofType:nil];
//    NSData *data1 = [NSData dataWithContentsOfFile:path1];
//    UIImage *firstimage1 = [UIImage imageWithData:data1];
//    [locationButton setBackgroundImage:firstimage1 forState:UIControlStateNormal];
//    [left_view addSubview:locationButton];
//    [locationButton addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
//    //    [self.view addSubview:searchButton];
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:left_view];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    /********************************搜索按钮**************************************/
//    UIView * right_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    searchButton.frame = right_view.frame;
//    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"搜索.png" ofType:nil];
//    NSData *data2 = [NSData dataWithContentsOfFile:path2];
//    UIImage *firstimage2 = [UIImage imageWithData:data2];
//    [searchButton setBackgroundImage:firstimage2 forState:UIControlStateNormal];
//    [right_view addSubview:searchButton];
//    [searchButton addTarget:self action:@selector(goin) forControlEvents:UIControlEventTouchUpInside];
//    //    [self.view addSubview:searchButton];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:right_view];
//    self.navigationItem.rightBarButtonItem = rightItem;
//
//    [self.view addSubview:self.indexscrol];

//    //*****************************************7.26
//    //存储系统语言
//    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//    NSLog(@"%@",languages[0]);
//    [MyUtils saveAddr:@"user_language.plist" saveKey:@"current_language" saveValue:languages[0]];
//    //*****************************************
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.loclabel.text= [MyUtils saveAddr:@"current_location.plist" getKey:@"current_location"];
//    NSLog(@"cfewfwe:%f",SCREEN_HEIGHT);
}
//-(void)request{
//    //网络请求推荐餐馆
//    self.thirdscrimage = [[NSMutableArray alloc]init];
//    self.tuijianID = [[NSMutableArray alloc]init];
//    self.thirdcrlabel = [[NSMutableArray alloc]init];
//    NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"50", @"num",nil];
//
//    NSString * url = [NSString stringWithFormat:@"%@/shop/HomeRecommend/",baseUrl];
//    [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
//                NSLog(@"返回结果:%@",responseObject);
//        if([[NSString stringWithFormat:@"%@",responseObject[@"res_code"]] isEqualToString:@"0"]){
//                for (NSDictionary * dic in responseObject[@"data"]){
//                    TuiJianRestModel * tuijianModel = [TuiJianRestModel mj_objectWithKeyValues:dic];
//                    [self.thirdcrlabel addObject:tuijianModel.name];
//                    [self.tuijianID addObject:[NSNumber numberWithInteger:tuijianModel.id]];
//                    NSLog(@"ddddddd:%@",tuijianModel.img);
//                    if(tuijianModel.img){
//                        [self.thirdscrimage addObject:tuijianModel.img];
//                    }else{
//                        [self.thirdscrimage addObject:@""];
//                    }
////                    [self.thirdscrimage addObject:tuijianModel.img];
//                }
//        }else{
//
//        }
//                NSLog(@"dxxcccc:%@",self.thirdscrimage);
//    } FailureBlock:^(id error) {
//        NSLog(@"%@",error);
//    }];
//
//}
//-(void)request_marketing_activity{
//    self.imageName = [[NSMutableArray alloc] initWithCapacity:0];
//    self.tag_array = [[NSMutableArray alloc] initWithCapacity:0];
//    NSString * url = [NSString stringWithFormat:@"%@/user/MarketingActivity/",baseUrl];
//    [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:nil SuccessBlock:^(id responseObject) {
//        NSLog(@"ffff:%@",responseObject);
//
//        if([[NSString stringWithFormat:@"%@",responseObject[@"res_code"]] isEqualToString:@"0"]){
//
//        for (NSDictionary * dic in responseObject[@"data"]) {
//            [self.imageName addObject:[dic objectForKey:@"img"]];
//            [self.tag_array addObject:[dic objectForKey:@"tag"]];
//        }
//
//        }else{
//            self.imageName = @[].mutableCopy;
//            self.tag_array = @[].mutableCopy;
//        }
//
//    } FailureBlock:^(id error) {
//        NSLog(@"%@",error);
//        self.imageName = @[].mutableCopy;
//        self.tag_array = @[].mutableCopy;
//    }];
//}

//-(UIView *)topView{
//    //初始化TopView，定义它的长和宽
//    if(!_topView){
//
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//
//        _topView = [[UIView alloc] init];
//        _topView.frame = CGRectMake(0, statusBarFrame.size.height, screenWidth, 0.1 * screenHeight);
//        _topView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:51/255.0 alpha:1.0];
//
//        CGFloat topVhight = 0.1 * screenHeight;
//        //添加地点标签
//        self.loclabel= [[UILabel alloc] init];
//        self.loclabel.frame = CGRectMake(20, 0.1 * topVhight, 180, 20);
//
//
//        CGFloat fontsize = 11.0;
//        UIFont *font = [UIFont boldSystemFontOfSize:fontsize];
//        self.loclabel.font = font;
//
//
//        [_topView addSubview:self.loclabel];
//        //添加Logo
//        UIImageView *logoimageV = [[UIImageView alloc]init];
//        logoimageV.frame = CGRectMake((screenWidth - 67)/2, (topVhight - 40)/2, 67, 40);
//        NSString *path = [[NSBundle mainBundle]
//                           pathForResource:@"homelogo.png" ofType:nil];
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        UIImage *logoimage = [UIImage imageWithData:data];
//        logoimageV.image = logoimage;
//        [_topView addSubview:logoimageV];
//
//        //添加定位按钮
//        UIButton *locbtn = [[UIButton alloc] init];
//        locbtn.frame = CGRectMake(20, self.loclabel.bounds.origin.y + self.loclabel.bounds.size.height + 5, 28, 28);
//        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"toollocation.png" ofType:nil];
//        NSData *data1 = [NSData dataWithContentsOfFile:path1];
//        UIImage *firstimage = [UIImage imageWithData:data1];
//        [locbtn setBackgroundImage:firstimage forState:UIControlStateNormal];
//        //定位按钮上添加事件，后续可更改  6.27 have changed
//        [locbtn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
//        [_topView addSubview:locbtn];
//
//        UIButton *searbtn = [[UIButton alloc] init];
//        searbtn.frame = CGRectMake(screenWidth - 52, self.loclabel.bounds.origin.y + self.loclabel.bounds.size.height + 5 , 28, 28);
//        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"topsearch.png" ofType:nil];
//        NSData *data2 = [NSData dataWithContentsOfFile:path2];
//        UIImage *firstimage2 = [UIImage imageWithData:data2];
//        [searbtn setBackgroundImage:firstimage2 forState:UIControlStateNormal];
//        //搜索按钮上添加事件
//        [searbtn addTarget:self action:@selector(goin) forControlEvents:UIControlEventTouchUpInside];
//        [_topView addSubview:locbtn];
//        [_topView addSubview:searbtn];
//    }
//    return _topView;
//}
//
//-(UIScrollView *)indexscrol{
//
//    if(!_indexscrol){
//
//
//        //多个异步请求完成后汇总结结果（任务执行不区分先后顺序）
//
//        dispatch_queue_t queue = dispatch_get_global_queue(0,0);
//
//        dispatch_group_t group = dispatch_group_create();
//
//        dispatch_group_async(group, queue, ^{
//            [self request];
//        });
//
//        dispatch_group_async(group, queue, ^{
//            [self request_marketing_activity];
//        });
//     //**********************************************************************************8
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        _indexscrol = [[UIScrollView alloc] init];
//
//        _indexscrol.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        _indexscrol.contentSize = CGSizeMake(0, 850 - 60 );
//        _indexscrol.backgroundColor = [UIColor whiteColor];
//        _indexscrol.showsVerticalScrollIndicator = NO;
//        _indexscrol.showsHorizontalScrollIndicator = NO;
//        _indexscrol.delegate = self;
//        dispatch_group_notify(group,dispatch_get_main_queue(), ^{
//            NSLog(@"end");
//            // 在a、b、c、d异步执行完成后，会回调这里
//            ScrollTableViewCell *lbsrol = [[ScrollTableViewCell alloc]init];
//            if(self.imageName.count > 0){
////                ScrollTableViewCell *lbsrol = [[ScrollTableViewCell alloc]init];
//                lbsrol.imageName = self.imageName;
//                lbsrol.tag_array = self.tag_array;
//                lbsrol.frame = CGRectMake(0, 0, screenWidth,170);
//                [lbsrol addSubview:lbsrol.firstscroll];
//                [lbsrol addSubview:lbsrol.mypageControl];
//
//
////                lbsrol.tapAction = ^(UIViewController * viewController,id rest_id){
////                    viewController.hidesBottomBarWhenPushed = YES;
////                    if(rest_id == nil){
////                        [self.navigationController pushViewController:viewController animated:YES];
////                    }else{
////
////                    Restaurant_DetailViewController * rest = [[Restaurant_DetailViewController alloc]init];
////                    rest.hidesBottomBarWhenPushed= YES;
////                    rest.restaurantID = rest_id;
////                    [self.navigationController pushViewController:rest animated:YES];
////                }
////                };
//
//                [self->_indexscrol addSubview:lbsrol];
//                [lbsrol.indextimer fire];
//               [lbsrol initTimerFunction];
//    //*********************************************************************************
//            }else{
////                ScrollTableViewCell *lbsrol = [[ScrollTableViewCell alloc]init];
//                lbsrol.imageName = self.imageName;
//                lbsrol.tag_array = self.tag_array;
//                lbsrol.frame = CGRectMake(0, 0, screenWidth, 180);
//                lbsrol.thedeaufultimg = [[UIImageView alloc]init];
//                lbsrol.thedeaufultimg.frame = CGRectMake(0, 0, screenWidth, 180);
//                lbsrol.thedeaufultimg.image = [UIImage imageNamed:@"德餐2.jpg"];
//                [lbsrol addSubview:lbsrol.thedeaufultimg];
//                [self->_indexscrol addSubview:lbsrol];
//            }
//
//
//            //添加左右按钮
//            IndexBtuTableViewCell *firstbtn1 = [[IndexBtuTableViewCell alloc]init];
//            firstbtn1.backgroundColor = [UIColor whiteColor];
//            firstbtn1.frame = CGRectMake(0, lbsrol.bounds.origin.y + lbsrol.bounds.size.height, screenWidth, 100);
//
//            //scan按钮上添加事件
//            [firstbtn1.lfetBtu addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
//            //预约按钮上添加事件
//            [firstbtn1.rightBtu addTarget:self action:@selector(GoReverse) forControlEvents:UIControlEventTouchUpInside];
//            [firstbtn1 addSubview:firstbtn1.lfetBtu];
//            [firstbtn1 addSubview:firstbtn1.rightBtu];
//            [self.indexscrol addSubview:firstbtn1];
//
//            //添加优惠滑动***************************
//            threeScrollView *firstthreesr = [[threeScrollView alloc]init];
//            firstthreesr.frame = CGRectMake(0, 250, screenWidth, 150);
//            firstthreesr.morebtn.hidden = YES;
//
////            firstthreesr.titlelable.text = [MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_promotion"]; //@"PROMOTION";
//            [firstthreesr addSubview:firstthreesr.titlelable];
//            [firstthreesr addSubview:firstthreesr.morebtn];
//            [self.indexscrol addSubview:firstthreesr];
//            //
//            //SglView *firstsglV = [[SglView alloc]init];
//            CGFloat sglwidth = 4 * screenWidth / 15;
//            CGFloat sglheight = 110;
//            //添加滚动条
//            UIScrollView *fir_scroll = [[UIScrollView alloc]init];
//            fir_scroll.delegate = self;
//            fir_scroll.frame = CGRectMake(15, 30 , screenWidth - 15, sglheight);
//            fir_scroll.contentSize = CGSizeMake(screenWidth, 0);
//            //fir_scroll.backgroundColor = [UIColor greenColor];
//            [firstthreesr addSubview:fir_scroll];
//
//            for(int i = 0 ; i < 3 ; i++){//添加三个优惠
//
//                CGFloat offx = 10 + sglwidth * i + 10 * i;
//                SglView *firstsglV = [[SglView alloc]init];
//                firstsglV.frame = CGRectMake(offx, 0, sglwidth, sglheight);
//                //给按键添加事件
//                firstsglV.thebtn.tag = i;//给每个按钮添加标识，方便添加不同的事件
//                firstsglV.thebtn.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
//                [firstsglV.thebtn addTarget:self action:@selector(thebtnClick1:) forControlEvents:UIControlEventTouchUpInside];
//                [firstsglV.thebtn setBackgroundImage:[UIImage imageNamed:self.firstscrimage[i]] forState:UIControlStateNormal];
//                [firstsglV addSubview:firstsglV.thebtn];
//                firstsglV.thelabel.text = self.firstscrlabel[i];
//                [firstsglV addSubview:firstsglV.thelabel];
//                firstsglV.backgroundColor = [UIColor whiteColor];
//                [fir_scroll addSubview:firstsglV];
//            }
//
//            //添加分类菜馆************************
//            threeScrollView *secondthreesr = [[threeScrollView alloc]init];
//
//            secondthreesr.frame = CGRectMake(0, 400, screenWidth, 150);
//            secondthreesr.titlelable.text = [MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_dishType"];//@"TYPE DE CUSINE";
//            [secondthreesr addSubview:secondthreesr.titlelable];
//            //[secondthreesr addSubview:secondthreesr.morebtn];
//            [self->_indexscrol addSubview:secondthreesr];
//
//            CGFloat sglwidth2 = 3 * screenWidth / 7;
//            CGFloat sglheight2 = 110;
//            UIScrollView *sed_scroll = [[UIScrollView alloc]init];
//            sed_scroll.delegate = self;
//            sed_scroll.frame = CGRectMake(0, 30 , screenWidth, sglheight2);
//            sed_scroll.contentSize = CGSizeMake(33*screenWidth/7 + 10 + 25 + 30, 0);
//            //sed_scroll.backgroundColor = [UIColor greenColor];
//            [secondthreesr addSubview:sed_scroll];
//            for(int i = 0 ; i < 11 ; i++){//添加11个分类
//
//                CGFloat offx = 10 + sglwidth2 * i + 5 * i;
//                SglView *firstsglV = [[SglView alloc]init];
//                firstsglV.frame = CGRectMake(offx, 0, sglwidth2, sglheight2);
//                [firstsglV addSubview:firstsglV.thebtn];
//                firstsglV.thelabel.text = self.secondcrlabel[i];
//                [firstsglV addSubview:firstsglV.thelabel];
//
//                [firstsglV.thebtn setBackgroundImage:[UIImage imageNamed:self.secondscrimage[i]] forState:UIControlStateNormal];
//                //给按键添加事件
//                firstsglV.thebtn.tag = i;//firstscrlabel[i];//给每个按钮添加标识，方便添加不同的事件
//                [firstsglV.thebtn addTarget:self action:@selector(thebtnClick2:) forControlEvents:UIControlEventTouchUpInside];
//
//                firstsglV.backgroundColor = [UIColor whiteColor];
//                [sed_scroll addSubview:firstsglV];
//            }
//            threeScrollView *thirdthreesr = [[threeScrollView alloc]init];
//            thirdthreesr.frame = CGRectMake(0, 550, screenWidth, 150);
//
//            thirdthreesr.titlelable.text = [MyUtils changeLanguage:self.currlanguage strKey:@"indexPage_resturant"];//@"MEILLEURES RESTAURANTS";
//            [thirdthreesr addSubview:thirdthreesr.titlelable];
//            //[thirdthreesr addSubview:thirdthreesr.morebtn];
//            [self.indexscrol addSubview:thirdthreesr];
//            //
//            //SglView *firstsglV = [[SglView alloc]init];
//            CGFloat sglwidth3 = 4 * screenWidth / 15;
//            CGFloat sglheight3 = 110;
//            //添加滚动条
//            UIScrollView *thi_scroll = [[UIScrollView alloc]init];
//            thi_scroll.delegate = self;
//            thi_scroll.frame = CGRectMake(0, 30 , screenWidth, sglheight3);
////            thi_scroll.contentSize = CGSizeMake(screenWidth*3, 0);
//
//            [thirdthreesr addSubview:thi_scroll];
//            CGFloat thescrollWidth;
//            //dispatch_queue_t rest_queue = dispatch_queue_create("get_image", DISPATCH_QUEUE_CONCURRENT);
//            for(int i = 0 ; i < self.thirdscrimage.count ; i++){//添加六个推荐餐馆 这里不一定是6个
//
//                CGFloat offx = 10 + sglwidth3 * i + 10 * i;
//                thescrollWidth = offx;
//                SglView *firstsglV = [[SglView alloc]init];
//                firstsglV.frame = CGRectMake(offx, 0, sglwidth3, sglheight3);
////                [firstsglV.thebtn setBackgroundImage:[UIImage imageNamed:self.thirdscrimage[i]] forState:UIControlStateNormal];
//
////                dispatch_queue_t rest_queue = dispatch_queue_create("get_image", DISPATCH_QUEUE_CONCURRENT);
////                dispatch_async(rest_queue, ^{
////                    NSString * urlString = self.thirdscrimage[i];
////                    NSURL * url = [NSURL URLWithString:urlString];
////                    [firstsglV.thebtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
////                });
//                if([self.thirdscrimage[i] isEqualToString:@""]){
//                    [firstsglV.thebtn setBackgroundImage:[UIImage imageNamed: @"images (4).jpg"] forState:UIControlStateNormal];
//                }else{
//
////                    NSString *theurl = @"http://scanmiam-image.oss-cn-beijing.aliyuncs.com/img/20180926235614_3086.jpg?x-oss-process=style/list";
//                    NSString * urlString = [MyUtils GetImageUrl:self.thirdscrimage[i] imageStyle:@"list"];
//                    NSURL * url = [NSURL URLWithString:urlString];
//                    [firstsglV.thebtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"images (4).jpg"]];
//                }
//
//                if(self.thirdscrimage.count == 0){
//
//                }else{
//                    thi_scroll.contentSize = CGSizeMake(thescrollWidth + sglwidth3 + 10, 0);
//                }
//
////                NSString * urlString = self.thirdscrimage[i];
////                NSURL * url = [NSURL URLWithString:urlString];
////                [firstsglV.thebtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"images (4).jpg"]];
//                //给按键添加事件
//                firstsglV.thebtn.tag = i;//给每个按钮添加标识，方便添加不同的事件
//                [firstsglV.thebtn addTarget:self action:@selector(thebtnClick3:) forControlEvents:UIControlEventTouchUpInside];
//                [firstsglV addSubview:firstsglV.thebtn];
//                firstsglV.thelabel.text = self.thirdcrlabel[i]; //文字
//                [firstsglV addSubview:firstsglV.thelabel];
//                firstsglV.backgroundColor = [UIColor whiteColor];
//                [thi_scroll addSubview:firstsglV];
//            }
//        });
//    }
//    return _indexscrol;
//}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset = self.indexscrol.contentOffset;
    [self.indexscrol setContentOffset:offset animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//可隐藏当前页面的导航栏
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL isShowPage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowPage animated:YES];
}
//-(void)goin{
//
//    self.hidesBottomBarWhenPushed = YES;
//    SearchViewController *search = [[SearchViewController alloc]init];
//    [self.navigationController pushViewController:search animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//}
//
//-(void)thebtnClick1:(UIButton *)sender{//优惠活动点击事件设置
//    int thetag = (int)[sender tag];   //后面会用到，显示的是哪一个h5页面
//    //这里有三种优惠券形式
//    switch (thetag) {
//        case 0:{
//            //团餐
//            self.hidesBottomBarWhenPushed = YES;
//            Tuancan_ViewController * tuancan_vc = [[Tuancan_ViewController alloc]init];
//            [self.navigationController pushViewController:tuancan_vc animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
//            break;
//
//        }
//        case 1:{
//            //优惠券
//            self.hidesBottomBarWhenPushed = YES;
//            Youhuiquan_ViewController * youhuiquan_vc = [[Youhuiquan_ViewController alloc]init];
//            [self.navigationController pushViewController:youhuiquan_vc animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
//            break;
//
//        }
//        default:{
//            //满多少送一
//            self.hidesBottomBarWhenPushed = YES;
//            Mansong_ViewController * mansong_vc = [[Mansong_ViewController alloc]init];
//            [self.navigationController pushViewController:mansong_vc animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
//            break;
//
//        }
//    }
//
//
//    NSLog(@"点击事件按钮：%ld",(long)[sender tag]);
//}
//
//-(void)thebtnClick2:(UIButton *)sender{//餐馆分类点击事件设置
//
//    self.hidesBottomBarWhenPushed = YES;
//    ReListNewViewController *test = [[ReListNewViewController alloc]init];
//    [self.navigationController pushViewController:test animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//
//    NSLog(@"点击事件按钮：%ld",(long)[sender tag]);
//}
//
//-(void)thebtnClick3:(UIButton *)sender{//推荐餐馆点击事件设置
//
//    //这里点击某个按钮应该取得它所对应的id，然后将ID传给其他页面
//
//    int thetag =(int) [sender tag];
//
//    self.hidesBottomBarWhenPushed = YES;
//    Restaurant_DetailViewController * rdvc = [[Restaurant_DetailViewController alloc]init];
//    //在这里获取id ，给下一个页面传id,使用block传值，传给下一个页面
//    id restaurantid = [self.tuijianID objectAtIndex:thetag];
//    rdvc.restaurantID = restaurantid;
//
//
//    [self.navigationController pushViewController:rdvc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//
//    NSLog(@"点击事件按钮：%ld",(long)[sender tag]);
//}
//
//- (void)scan{
//
//    self.hidesBottomBarWhenPushed = YES;
//    ScanCodeViewController * scan = [[ScanCodeViewController alloc]init];
//    [self.navigationController pushViewController:scan animated:YES];
//
//    self.hidesBottomBarWhenPushed = NO;
//}
//
//-(void)location{
//    self.hidesBottomBarWhenPushed = YES;
//    LocationTableViewController * LctVC = [[LocationTableViewController alloc]init];
//    [self.navigationController pushViewController:LctVC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//}
//
//-(void)thebtnClick:(UIButton *)sender{
//    int thetag =(int) [sender tag];
//    //可重写顶部内容
//    self.hidesBottomBarWhenPushed = YES;
//    TestViewController *test = [[TestViewController alloc]init];
//    NSString *string = [NSString stringWithFormat:@"%d",thetag];
//    test.textString = string;
//    [self.navigationController pushViewController:test animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//
//    NSLog(@"点击事件按钮：%ld",(long)[sender tag]);
//
//}
//
//- (void)GoReverse{//跳转到预约点餐页面
//
//
//    self.hidesBottomBarWhenPushed = YES;
//    ReListNewViewController *test = [[ReListNewViewController alloc]init];
//    [self.navigationController pushViewController:test animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//}

@end

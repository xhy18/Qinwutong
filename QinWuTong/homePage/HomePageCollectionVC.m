//
//  HomePageCollectionVC.m
//  QinWuTong
//
//  Created by ltl on 2018/11/21.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "HomePageCollectionVC.h"
#import "SectionACollectionCell.h"
#import "SectionBCollectionCell.h"
#import "SectionCCollectionCell.h"
#import "ScrollTableViewCell.h"
#import "ServiceListVC.h"
#import "SearchPageVC.h"
#import "NavigationPageVC.h"

#import "SecondPage.h"


#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface HomePageCollectionVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    //最初想用一个CollectionView的3个section实现页面；改用3个Collection后沿用了section的命名
    UICollectionView *sectionACV;
    UICollectionView *sectionBCV;
    UICollectionView *sectionCCV;
    
    NSMutableArray *titleInSA;
}
//ScrollView用到的属性
@property(strong, nonatomic) UIScrollView *indexscrol;
@property(nonatomic,retain)NSMutableArray * imageName;
@property(nonatomic,retain)NSMutableArray * tag_array;
//轮播图用到的属性（ScrollView实现）
@property (nonatomic, retain)NSTimer* rotateTimer;  //让视图自动切换
@property (nonatomic, retain)UIPageControl *myPageControl;

//获取用户当前地址的一些属性
//@property (nonatomic, retain)MKMapView *mapView;
@property (nonatomic, retain)CLLocationManager *locaManager;
@property (nonatomic, retain)CLGeocoder *geocoder;
@property(strong, nonatomic) UILabel *addressTxt;
@property (nonatomic) CLLocation *location;



@end

@implementation HomePageCollectionVC
/*
 主页。主要结构为上方的搜索框、文字label等控件，然后是UIScrollView，其中放入轮播图以及3个collectionView，显示3块内容。
 顶部label显示用户当前地址，通过地图的api进行逆地理位置解析获得。由于serviceList页面需要计算服务人员距离，此处将用户经纬度一并读取并传入serviceListvc
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat topOffset = 10;//自顶部向下的偏移量
    self.navigationItem.title = @"首页";
    //如果不在这里加一个修改返回按钮颜色，进入其他tabbar的子页面，返按钮颜色不变。。。。。。。原因我也不知道
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self getTitleInSA];
    CGFloat btnWidth = 30;
    CGFloat btnHeight = 40;//顶部左右侧两个按钮的hw
    CGFloat blankWid = 5;
    
    CGFloat rotateHeight = 150;//轮播图高度

    //############################顶部控件
    UILabel *topBg = [[UILabel alloc]init];//顶部地址、搜索栏的背景label
    topBg.backgroundColor = themeColor;
    topBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2*btnHeight+4*blankWid);
    [self.view addSubview:topBg];

    _addressTxt = [[UILabel alloc]init];
    _addressTxt.frame = CGRectMake(15+btnHeight, 10+topOffset, SCREEN_WIDTH-20-btnHeight, btnHeight);//y起点+8和高度-4是为了盖住searchBar的上框线并保持居中
//    addressTxt.text = @"西安市";//【tag】替换为动态地址数据
    _addressTxt.textAlignment = NSTextAlignmentCenter;
    _addressTxt.textColor = textColorOnBg;
    _addressTxt.font = [UIFont systemFontOfSize:18];
    _addressTxt.backgroundColor = themeColor;
    //    topBg.text = @"1`2";
    //    UIImage *positionImg = [UIImage imageNamed:@"location.png"];
    //    UIImageView *position = [[UIImageView alloc] initWithImage:positionImg];
    //    UIButton *location = [[UIButton alloc] init];
    //    location.imageView = position;


    UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
    location.frame = CGRectMake(10, 10+topOffset, btnHeight, btnHeight);//设置位置和大小
    location.backgroundColor = themeColor;
    [location setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [location setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    location.titleLabel.font = [UIFont systemFontOfSize:15];
//    [location addTarget:self action:@selector(testButtonClick) forControlEvents:UIControlEventTouchUpInside];//点击事件
    //    position.frame = CGRectMake(10, 10+topOffset, btnWidth, btnHeight);
    
    //本来是个searchBar类型，后面改成跳转页面执行搜索功能，索性改成button。为了保证代码的继续运行，对象名称不变
    UIButton *searchBar = [[UIButton alloc]initWithFrame:CGRectMake(blankWid, 2*blankWid+topOffset+btnHeight+2, SCREEN_WIDTH - 2*blankWid, 30)];
    [searchBar setTitle:@"搜一搜：寻找您所需的服务" forState:UIControlStateNormal];
    [searchBar setTitleColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0] forState:UIControlStateNormal];
    searchBar.titleLabel.font = [UIFont systemFontOfSize:18];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 12;
    [searchBar addTarget:self action:@selector(searchServer) forControlEvents:UIControlEventTouchUpInside];//点击事件
    
//    UISearchBar *searchBar = [[UISearchBar alloc] init];
//    searchBar.frame = CGRectMake(blankWid, 2*blankWid+topOffset+btnHeight-2, SCREEN_WIDTH - 2*blankWid, btnHeight+3);//y起点-2高度+3是为了纵向拉伸一点点让scrollview盖住下框线
////    searchBar.backgroundColor = bgColor;
//    searchBar.barStyle = 0;
//    searchBar.barTintColor = themeColor;
//    searchBar.searchBarStyle = UISearchBarStyleProminent;
    [self.view addSubview:searchBar];
    [self.view addSubview:_addressTxt];
    [self.view addSubview:location];
    //############################
    

    
    
    //############################3个CollectionView实现的表格布局
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layoutA = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
//        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layoutA.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    //该方法也可以设置itemSize
    layoutA.itemSize =CGSizeMake(110, 150);
    
    //2.初始化collectionView
    sectionACV = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layoutA];
//    sectionACV.frame = CGRectMake(0, 3*blankWid+topOffset+2*btnHeight, frameWidth,
//                                          frameHeight-3*blankWid-topOffset-2*btnHeight-50);
//    sectionACV.frame = CGRectMake(0, 0, frameWidth, ((frameWidth-60)/5*0.75+25)*2+40);
    sectionACV.frame = CGRectMake(0, rotateHeight, SCREEN_WIDTH,((SCREEN_WIDTH-60)/5+25)*2+40);
//    CGFloat saPointY =3*blankWid+topOffset+2*btnHeight +((frameWidth-60)/5*0.75+25)*2+40;
    CGFloat saPointY =sectionACV.frame.origin.y+sectionACV.frame.size.height;
    [self.view addSubview:sectionACV];
    sectionACV.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [sectionACV registerClass:[SectionACollectionCell class] forCellWithReuseIdentifier:@"cellId"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [sectionACV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    //用于在重写的函数中区分不同的section进行配置
    sectionACV.tag = 1;
    
    //4.设置代理
    sectionACV.delegate = self;
    sectionACV.dataSource = self;
    
    
    //1.初始化layout
    UICollectionViewFlowLayout *layoutB = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layoutB.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    //该方法也可以设置itemSize
    layoutB.itemSize =CGSizeMake(110, 150);
    //2.初始化collectionView
    sectionBCV = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layoutB];
    //    sectionACV.frame = CGRectMake(0, 3*blankWid+topOffset+2*btnHeight, frameWidth,
    //                                          frameHeight-3*blankWid-topOffset-2*btnHeight-50);
    sectionBCV.frame = CGRectMake(0, saPointY+20, SCREEN_WIDTH,
                                  ((SCREEN_WIDTH-40)/2*0.75+25)*2+80);
    CGFloat sbPointY = saPointY+10+((SCREEN_WIDTH-40)/2*0.75+25)*2+80;
    [self.view addSubview:sectionBCV];
    sectionBCV.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [sectionBCV registerClass:[SectionBCollectionCell class] forCellWithReuseIdentifier:@"cellId"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [sectionBCV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    sectionBCV.tag = 2;
    
    //4.设置代理
    sectionBCV.delegate = self;
    sectionBCV.dataSource = self;
    
    
    //1.初始化layout
    UICollectionViewFlowLayout *layoutC = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layoutC.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 15);
    //该方法也可以设置itemSize
    layoutC.itemSize =CGSizeMake(110, 150);
    //2.初始化collectionView
    sectionCCV = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layoutC];
    sectionCCV.frame = CGRectMake(0, sbPointY+10, SCREEN_WIDTH,
                                  ((SCREEN_WIDTH-40)/2+85)*3+100);
    CGFloat scPointY =sbPointY+10+((SCREEN_WIDTH-40)/2+85)*3+100;
    [self.view addSubview:sectionCCV];
    sectionCCV.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [sectionCCV registerClass:[SectionCCollectionCell class] forCellWithReuseIdentifier:@"cellId"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [sectionCCV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    sectionCCV.tag = 3;
    
    //4.设置代理
    sectionCCV.delegate = self;
    sectionCCV.dataSource = self;
    //############################
    
    
    //############################轮播图
    //初始化scrollView 设置大小
    UIScrollView *rotateScrollView = [[UIScrollView alloc] init];
    NSArray *rotateImgArr =[NSArray arrayWithObjects:@"ad1.PNG",@"ad2.PNG",@"ad3.PNG",@"ad4.PNG",@"ad5.PNG",nil];
    rotateScrollView.frame = CGRectMake(0,0, SCREEN_WIDTH, rotateHeight);
    //设置滚动范围
    rotateScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*[rotateImgArr count], 0);
    //设置分页效果
    rotateScrollView.pagingEnabled = YES;
    //水平滚动条隐藏
    rotateScrollView.showsHorizontalScrollIndicator = NO;
    //添加三个子视图  UILabel类型
//    for (int i = 0; i< 3; i++) {
//        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*i, 0, CGRectGetWidth(self.view.frame), rotateHeight)];
//        subLabel.tag = 1000+i;
//        subLabel.text = [NSString stringWithFormat:@"我是第%d个视图",i];
//        [subLabel setFont:[UIFont systemFontOfSize:80]];
//        subLabel.adjustsFontSizeToFitWidth = YES;
//        [subLabel setBackgroundColor:[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0  blue:arc4random()%256/255.0  alpha:1.0]];
//        [rotateScrollView addSubview:subLabel];
//    }
    for (int i = 0; i< [rotateImgArr count]; i++) {
        UIImageView *rotateImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, rotateHeight)];
        rotateImg.image = [UIImage imageNamed:[rotateImgArr objectAtIndex:i]];
//        rotateImg.image =[UIImage imageNamed:@"logo.png"];
        rotateImg.tag = 1000+i;
        [rotateImg setBackgroundColor:[UIColor whiteColor]];
        [rotateScrollView addSubview:rotateImg];
    }
    UIImageView *tempRotateView = [rotateScrollView viewWithTag:1000];
    UIImageView *rotateImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*[rotateImgArr count], 0, SCREEN_WIDTH, rotateHeight)];
    rotateImgView.image = tempRotateView.image;
    rotateImgView.backgroundColor = tempRotateView.backgroundColor;
    [rotateScrollView addSubview:rotateImgView];
    
    
   
    
    rotateScrollView.tag = 1000;
    
    self.myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-50, CGRectGetWidth(self.view.frame), 50)];
    self.myPageControl.numberOfPages = 3;
    self.myPageControl.currentPage = 0;
//    [self.view addSubview:self.myPageControl];
    
    //启动定时器
    self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    //为滚动视图指定代理
    rotateScrollView.delegate = self;
    //############################
    
    
    
    //############################ScrollCView滚动条
    _indexscrol = [[UIScrollView alloc] init];
    
    _indexscrol.frame = CGRectMake(0,2*blankWid+topOffset+2*btnHeight, SCREEN_WIDTH, self.view.bounds.size.height-60);
    _indexscrol.contentSize = CGSizeMake(0, scPointY+5);//设置内部的滚动大小，横向不能滚动，纵向长度是第三个section的底坐标
    _indexscrol.backgroundColor = [UIColor whiteColor];
    _indexscrol.showsVerticalScrollIndicator = NO;
    _indexscrol.showsHorizontalScrollIndicator = NO;
    _indexscrol.delegate = self;
    //加入轮播图
    [self.indexscrol addSubview:rotateScrollView];
    //加入3个表格布局
    [self.indexscrol addSubview:sectionACV];
    [self.indexscrol addSubview:sectionBCV];
    [self.indexscrol addSubview:sectionCCV];
    [self.view addSubview:self.indexscrol];
    //############################
    
    
    //初始化位置管理
    self.locaManager = [[CLLocationManager alloc] init];
    //如果设备在iOS8及以上，得先弹框让用户授权，才能获得定位权限
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [self.locaManager requestWhenInUseAuthorization];
    }
    //设置代理
    self.locaManager.delegate = self;
    //开始定位
    [self.locaManager startUpdatingLocation];
    
    // Do any additional setup after loading the view.
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [_locaManager stopUpdatingLocation];
    //旧址
//    CLLocation *currentLocation = [locations lastObject];
    _location = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",_location.coordinate.latitude,_location.coordinate.longitude);
    
    //反地理编码
    [geoCoder reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *addressToShow = placeMark.locality;
            if (!addressToShow)
                addressToShow = @"无法定位当前城市";
            else
                addressToShow = placeMark.name;
            _addressTxt.text = addressToShow;
//            [_locaManager stopUpdatingHeading];
//            看需求定义一个全局变量来接收赋值
//                        NSLog(@"----%@",placeMark.country);//当前国家
//                        //            NSLog(@"%@",currentCity);//当前的城市
//                        NSLog(@"%@",placeMark.subLocality);//当前的位置
//                        NSLog(@"%@",placeMark.thoroughfare);//当前街道
//                        NSLog(@"%@",placeMark.name);//具体地址
            
        }
    }];
    
}
-(void)getTitleInSA{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        NSString *url = [NSString stringWithFormat:@"%@/qwt/server/Servicer/childskill",baseUrl];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:nil];
        [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/qwt/server/Server/skillone",baseUrl] Dic:dic SuccessBlock:^(id responseObject){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 1){
                //success body
                dict = [dict objectForKey:@"data"];
                self->titleInSA = @[].mutableCopy;
                int i = 0;
                for (NSString *str in dict) {
                    [self->titleInSA addObject:str];
                    if(++i>=9)
                        break;
                }
                [self->titleInSA addObject:@"全部分类"];
                [self->sectionACV reloadData];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取一级目录失败：error:%@",error] method:@"getTitleInSA" vc:self];
            }
        } FailureBlock:^(id error) {
            NSLog(@"\n\n\n【【ERROR in HomePageCollectionVC.m】】\n%@\n\n",error);
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"getTitleInSA" vc:self];
        }];
    });
}
-(void)searchServer{
    SearchPageVC *vc = [[SearchPageVC alloc] init];
    
    [vc setLocation:_location];
    [self.navigationController pushViewController:vc animated:NO];
}
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 1)
        return 10;
    else if(collectionView.tag == 2)
        return 4;
    else
        return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSArray *title3 =[NSArray arrayWithObjects:@"家电维修",@"数码维修",@"开锁换锁",@"物流配送",@"上门洗车",
//                      @"丽人美容",@"洗衣修鞋",@"鲜花绿植",@"清洁换新",@"全部分类", nil];
    if(collectionView.tag == 1){
//        NSArray *title1 =[NSArray arrayWithObjects:@"家电维修",@"数码维修",@"开锁换锁",@"物流配送",@"上门洗车",
//                          @"丽人美容",@"洗衣修鞋",@"鲜花绿植",@"清洁换新",@"全部分类", nil];
        NSArray *img1 =[NSArray arrayWithObjects:@"main_hot1.png",@"main_hot2.png",@"main_hot3.png",@"main_hot4.png", @"main_hot5.png",@"main_hot6.png",@"main_hot7.png",@"main_hot8.png",@"main_hot9.png",@"main_hot10.png",nil];
        SectionACollectionCell *c1 =(SectionACollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        CGFloat width =(self.view.bounds.size.width-60)/5;
        c1.topImage.frame = CGRectMake(0, 0, width, width);
        c1.botlabel.frame = CGRectMake(0, width+5, width, 20);
        c1.botlabel.backgroundColor = [UIColor clearColor];
        c1.botlabel.textColor = [UIColor blackColor];
        c1.topImage.backgroundColor = [UIColor clearColor];
        c1.botlabel.text = [titleInSA objectAtIndex:(long)indexPath.row];
        c1.topImage.image = [UIImage imageNamed:[img1 objectAtIndex:(long)indexPath.row]];
        return c1;
    }
    else if(collectionView.tag == 2){
        NSArray *img2 =[NSArray arrayWithObjects:@"icon_ad1.jpg",@"icon_ad2.jpg",@"icon_ad2.jpg",@"icon_ad1.jpg",nil];
        NSArray *title2 =[NSArray arrayWithObjects:@"清洁换新",@"低价团购",@"清洁换新",@"低价团购", nil];
        NSArray *top2 =[NSArray arrayWithObjects:@"限时折扣",@"天天特价",@"天天特价",@"限时折扣", nil];
        NSArray *subTitle2 =[NSArray arrayWithObjects:@"低至3折",@"58元起",@"低至3折",@"58元起", nil];
        SectionBCollectionCell *c2 =(SectionBCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        CGFloat width =(self.view.bounds.size.width-40)/2;
//        NSLog(@"%f",width);
        c2.top.frame = CGRectMake(0, 0, width, 25);
        c2.top.text = [top2 objectAtIndex:(long)indexPath.row];
        c2.top.backgroundColor = [UIColor greenColor];
        c2.img.frame = CGRectMake(0, 20, width, width*0.75);
        c2.img.image = [UIImage imageNamed:[img2 objectAtIndex:(long)indexPath.row]];
        c2.title.frame = CGRectMake(0, width/2+15, width, 20);
        c2.title.text = [title2 objectAtIndex:(long)indexPath.row];
        c2.title.font = [UIFont systemFontOfSize:16];
        c2.subTitle.frame = CGRectMake(0, width/2+35, width, 15);//c2.title.bounds.origin.y+c2.title.bounds.size.height+2
        c2.subTitle.text = [subTitle2 objectAtIndex:(long)indexPath.row];
        c2.subTitle.font = [UIFont systemFontOfSize:12];
        return c2;
    }
    else{
        NSArray *img3 =[NSArray arrayWithObjects:@"logo.png",@"logo.png",@"logo.png",@"logo.png",@"logo.png",@"logo.png",nil];
        NSArray *name =[NSArray arrayWithObjects:@"秦师傅",@"楚师傅",@"燕师傅",@"赵师傅",@"韩师傅",@"魏师傅",nil];
        NSArray *add =[NSArray arrayWithObjects:@"西安市太白南路2号西安电子科技大学",@"西安市太白南路2号西安电子科技大学",@"西安市太白南路2号西安电子科技大学",
                       @"西安市太白南路2号西安电子科技大学",@"西安市太白南路2号西安电子科技大学",@"西安市太白南路2号西安电子科技大学",nil];
        NSArray *service =[NSArray arrayWithObjects:@"家电维修",@"数码维修",@"开锁换锁",@"物流配送",@"上门洗车",
                       @"丽人美容", nil];
        SectionCCollectionCell *c3 = (SectionCCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        CGFloat width =(self.view.bounds.size.width-40)/2;
        c3.topImg.frame = CGRectMake(0, 0, width, width);
        c3.topImg.image = [UIImage imageNamed:[img3 objectAtIndex:(long)indexPath.row]];
        c3.backgroundColor = [UIColor blackColor];
        c3.name.text = [name objectAtIndex:(long)indexPath.row];
        c3.name.frame = CGRectMake(2, width+8, 100, 20);
        c3.name.font = [UIFont systemFontOfSize:16];
        c3.name.backgroundColor = [UIColor grayColor];
        NSString *inStr = [NSString stringWithFormat: @" %ld%@", (long)arc4random()%12,@"km"];//随机数输入距离
        c3.distance.text = inStr;
        c3.distance.frame = CGRectMake(120, width+8, 45, 20);
        c3.distance.backgroundColor = [UIColor greenColor];
        c3.distance.textColor = [UIColor grayColor];
        c3.distance.font = [UIFont systemFontOfSize:14];
        c3.distance.textAlignment = NSTextAlignmentCenter;//居中显示
        c3.address.frame= CGRectMake(2, width+30, width, 15);
        c3.address.text = [add objectAtIndex:(long)indexPath.row];
        c3.address.font = [UIFont systemFontOfSize:12];
        c3.address.textColor = [UIColor grayColor];
        c3.services.frame = CGRectMake(2, width+50, width, 20);
        c3.services.text = [service objectAtIndex:(long)indexPath.row];
        c3.services.font = [UIFont systemFontOfSize:16];
        c3.services.textColor = [UIColor orangeColor];
        c3.line.frame = CGRectMake(5, width+48, width-10, 1);
//        c3.line.backgroundColor = [UIColor grayColor];
        return c3;
    }
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag == 1)
        return CGSizeMake((self.view.bounds.size.width-60)/5, (self.view.bounds.size.width-60)/5+25);//=width/5*0.75
    if(collectionView.tag == 2)
        return CGSizeMake((self.view.bounds.size.width-40)/2, (self.view.bounds.size.width-40)/2);
    if(collectionView.tag == 3)
        return CGSizeMake((self.view.bounds.size.width-40)/2, (self.view.bounds.size.width-40)/2+85);
    return CGSizeMake(0, 0);
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//header的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    if(collectionView.tag <3){
//        headerView.frame =CGRectMake(0, 0, 0, 10);
        return headerView;
    }
    headerView.backgroundColor =[UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.text = @"——推 荐 服 务——";
    label.font = [UIFont systemFontOfSize:20];
    label.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    return headerView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag == 1){
        if(indexPath.row == 9){//分类导航页面
            NavigationPageVC *vc = [[NavigationPageVC alloc] init];
            [vc setLocation:_location];
            [self.navigationController pushViewController:vc animated:NO];
            return;
        }
        SectionACollectionCell *cell = (SectionACollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSString *msg = cell.botlabel.text;
        if(!msg){
            [MyUtils alertMsg:@"未获取到一级目录数据" method:@"点击item方法" vc:self];
            return;
        }
        NSLog(@"%@",msg);
        
        ServiceListVC *vc = [[ServiceListVC alloc] init];
        [vc setTitle:cell.botlabel.text setLocation:_location];
        [self.navigationController pushViewController:vc animated:NO];
    }
    if(collectionView.tag == 2){
        SectionBCollectionCell *cell = (SectionBCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSString *msg = cell.title.text;
        NSLog(@"%@",msg);
    }
    if(collectionView.tag == 3){
        SectionCCollectionCell *cell = (SectionCCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSString *msg = cell.name.text;
        NSLog(@"%@",msg);
    }
}
#pragma mark -- 滚动视图的代理方法
//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
    [self.rotateTimer setFireDate:[NSDate distantFuture]];
}

//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //视图静止之后，过3秒在开启定时器
    //[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]  返回值为从现在时刻开始 再过3秒的时刻。
    NSLog(@"开启定时器");
    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:3 sinceDate:[NSDate date]]];
}


//定时器的回调方法   切换界面
- (void)changeView{
    //得到scrollView
    UIScrollView *scrollView = [self.view viewWithTag:1000];
    //通过改变contentOffset来切换滚动视图的子界面
    float offset_X = scrollView.contentOffset.x;
    //每次切换一个屏幕
    offset_X += CGRectGetWidth(self.view.frame);
    
    //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
    if (offset_X > CGRectGetWidth(self.view.frame)*3) {
        scrollView.contentOffset = CGPointMake(0, 0);
        
    }
    //说明正在显示的就是最右边的多余视图，最右边的多余视图实际上就是第一个视图。所以pageControl的小白点需要在第一个视图的位置。
    if (offset_X == CGRectGetWidth(self.view.frame)*3) {
        self.myPageControl.currentPage = 0;
    }else{
        self.myPageControl.currentPage = offset_X/CGRectGetWidth(self.view.frame);
    }
    
    //得到最终的偏移量
    CGPoint resultPoint = CGPointMake(offset_X, 0);
    //切换视图时带动画效果
    //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
    if (offset_X >CGRectGetWidth(self.view.frame)*3) {
        self.myPageControl.currentPage = 1;
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:YES];
    }else{
        [scrollView setContentOffset:resultPoint animated:YES];
    }
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//进入页面时隐藏顶部导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;//显示底部tabBar
    self.navigationController.navigationBarHidden = YES;//隐藏顶部导航栏
}
//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//    self.tabBarController.tabBar.hidden=YES;//显示底部tabBar
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

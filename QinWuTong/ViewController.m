//
//  ViewController.m
//  QinWuTong
//
//  Created by ltl on 2018/11/19.
//  Copyright © 2018 ltl. All rights reserved.
//  首页控制

#import "ViewController.h"
#import "Constants.h"
#import "SecondPage.h"
#import "homePage/HomePageCollectionVC.h"
#import "nearPage/NearServerVC.h"
//#import "orderPage/OrderPageVC.h"
#import "orderManager/OrderManagerVC.h"
#import "PersonalCenterVC.h"

#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
//    CGFloat frameWidth = self.view.bounds.size.width;
//    UIImage *positionImg = [UIImage imageNamed:@"location.png"];
//    UIImageView *position = [[UIImageView alloc] initWithImage:positionImg];
//    position.frame = CGRectMake(10, 20, 48, 48);
//
//    UILabel *addressTxt =[[UILabel alloc] init];
//    addressTxt.text = @"西安市";
//    addressTxt.contentMode = UIViewContentModeCenter;
//    addressTxt.frame =CGRectMake(60, 20, 200, 48);d
//    [self.view addSubview:addressTxt];
//    [self.view addSubview:position];
//    // Do any additional setup after loading the view, typically from a nib.
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    [AppDelegate setViewController:self];
    //[self.navigationController setNavigationBarHidden:YES animated:	YES];
     
//    HomePageVC * homePage =[[HomePageVC alloc] init];
    HomePageCollectionVC * homePage =[[HomePageCollectionVC alloc] init];
    [self setTabBarItem:homePage.tabBarItem
                  title:@"首页"
              titleSize:20.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"main_red_small.png"
     selectedTitleColor:themeColor
            normalImage:@"main_black_small.png"
       normalTitleColor:[UIColor blackColor]];
    NearServerVC * near = [[NearServerVC alloc]init];
    [self setTabBarItem:near.tabBarItem
                  title:@"附近"
              titleSize:13.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"near_red_small.png"
     selectedTitleColor:themeColor
            normalImage:@"near_black_small.png"
       normalTitleColor:[UIColor blackColor]];
    OrderManagerVC * order = [[OrderManagerVC alloc]init];
    [self setTabBarItem:order.tabBarItem
                  title:@"订单"
              titleSize:13.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"order_red_small.png"
     selectedTitleColor:themeColor
            normalImage:@"order_black_small.png"
       normalTitleColor:[UIColor blackColor]];
    PersonalCenterVC * person = [[PersonalCenterVC alloc]init];
    [self setTabBarItem:person.tabBarItem
                  title:@"我的"
              titleSize:13.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"me_red_small.png"
     selectedTitleColor:themeColor
            normalImage:@"me_black_small.png"
       normalTitleColor:[UIColor blackColor]];
//    SecondPage * testPage = [[SecondPage alloc]init];
//    [self setTabBarItem:testPage.tabBarItem
//                  title:@"测试页"
//              titleSize:13.0
//          titleFontName:@"HeiTi SC"
//          selectedImage:@"me_red_small.png"
//     selectedTitleColor:themeColor
//            normalImage:@"me_black_small.png"
//       normalTitleColor:[UIColor blackColor]];
    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:homePage];
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:near];
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:order];
    UINavigationController * nav4 = [[UINavigationController alloc]initWithRootViewController:person];
//    UINavigationController * nav5 = [[UINavigationController alloc]initWithRootViewController:testPage];
    
    self.viewControllers= [NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nil];
    
    
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor
{
    UIImage * selected = [UIImage imageNamed:selectedImage];
    selected = [selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage * normal = [UIImage imageNamed:unselectedImage];
    normal = [normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置图片
    //   tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tabbarItem = [tabbarItem initWithTitle:title image:normal selectedImage:selected];//取消系统蓝色渲染imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal
    
    
    
    // S未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
    //选中图片
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

@end

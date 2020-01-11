//
//  OrderPageVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/10.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "OrderPageVC.h"
#import "UIParameter.h"
#import "HJTPagerView.h"
#import "Constants.h"

@interface OrderPageVC ()

@end

@implementation OrderPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    self.navigationController.navigationBar.translucent = NO;
    
    NSArray *titleArray = @[@"进行中",@"已完成",@"未完成",];
    
    NSArray *vcsArray = @[@"OrderOnGoingVC",@"OrderUnfinishedVC",@"OrderFinishedVC"];
    
    NSArray *colorArray = @[
                            themeColor, /**< 选中的标题颜色 Title SelectColor  **/
                            [UIColor grayColor], /**< 未选中的标题颜色  Title UnselectColor **/
                            themeColor, /**< 下划线颜色 Underline Color   **/
                            ];
    
    HJTPagerView *hjtPagerView = [[HJTPagerView alloc] initWithTitles:titleArray WithVCs:vcsArray WithColorArrays:colorArray];
    [self.view addSubview:hjtPagerView];
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

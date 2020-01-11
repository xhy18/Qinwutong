//
//  OrderManagerVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/26.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "OrderManagerVC.h"

#import "Constants.h"
#import "MyUtils.h"

@interface OrderManagerVC ()

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray *btnName;
@property (nonatomic, strong) NSArray *vcName;
@property (nonatomic) NSMutableArray *btns;
@property (nonatomic) NSMutableArray *lines;
@end

@implementation OrderManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    _btnName = [NSArray arrayWithObjects:@"待接单",@"待付款",@"进行中",@"已完成",@"已取消", nil];
    _vcName = [NSArray arrayWithObjects:@"OrderWaitingCheckVC",@"OrderWithoutPayVC",@"OrderUnfinishedVC",@"OrderFinishedVC", @"OrderCanceledVC", nil];
//    _btns = [NSArray arrayWithObjects:[UIButton new],[UIButton new],[UIButton new],[UIButton new], nil];
    [self initScrollViewAndBtn];
}

- (void)initScrollViewAndBtn{
    
    CGFloat topOffset = statusBarFrame.size.height+navigationHeight;//自顶部向下的偏移量
    //背景ScrollView
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 58 -50)];
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * [_btnName count], 0);
//    self.contentScrollView.pagingEnabled = YES;
    [self.view addSubview:self.contentScrollView];
    
    double btnWid = SCREEN_WIDTH / [_btnName count];
    float btnHei = 40;
    UILabel *btnBgLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, btnHei)];
    btnBgLbl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnBgLbl];
    _btns =  @[].mutableCopy;
    _lines =  @[].mutableCopy;
    for(int i=0;i<[_btnName count];i++){
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWid, 0, btnWid, btnHei)];
        titleBtn.backgroundColor = [UIColor clearColor];
        [titleBtn setTitle:[_btnName objectAtIndex:i] forState:UIControlStateNormal];
        [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:themeColor forState:UIControlStateSelected];
        [titleBtn addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTag:i];
        if(i==0)
            [titleBtn setSelected:YES];
        else
            [titleBtn setSelected:NO];
        [_btns addObject:titleBtn];
        [self.view addSubview:titleBtn];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(titleBtn.frame.origin.x, titleBtn.frame.origin.y+titleBtn.frame.size.height-2, btnWid, 2)];
        line.tag = i;
        line.backgroundColor = themeColor;
        if(i==0)
            line.hidden = NO;
        else
            line.hidden = YES;
        [_lines addObject:line];
        [self.view addSubview:line];
        
        NSString *className = [_vcName objectAtIndex:i];
        Class class = NSClassFromString(className);
        if (class) {
            UITableViewController *ctrl = [[class alloc]init];
            ctrl.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50);
            ctrl.tableView.frame = CGRectMake(SCREEN_WIDTH * i, 40, SCREEN_WIDTH, SCREEN_HEIGHT-btnHei-50-topOffset);
            [self.contentScrollView addSubview:ctrl.tableView];
            [self addChildViewController:ctrl];
        }
    }
}

- (void)changeVC:(UIButton *)btn{
//    NSLog(@"%d",btn.tag);
    [self.contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * btn.tag, 0) animated:YES];
    //因为触发滑动后会再次调整按键被选中状态，此处不需要调整
//    for(int i=0;i<[_btns count];i++){
//        UIButton *button = (UIButton *)[_btns objectAtIndex:i];
//        [button setSelected:NO];
//    }
//    for(int i=0;i<[_lines count];i++){
//        UILabel *line = (UILabel *)[_lines objectAtIndex:i];
//        if(line.tag == btn.tag)
//            line.hidden = NO;
//        else
//            line.hidden = YES;
//    }
    [btn setSelected:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger curBtn = (self.contentScrollView.contentOffset.x + SCREEN_WIDTH / 2) / SCREEN_WIDTH;
//    NSLog(@"\n%.4f\n%d",self.contentScrollView.contentOffset.x,curBtn);
    for(NSInteger i = 0; i < [_btns count]; ++i){
//        UIButton *btn = (UIButton *)[[scrollView superview]viewWithTag:i];
        UIButton *btn = (UIButton *)[_btns objectAtIndex:i];
        if(btn.tag == curBtn){
            [btn setSelected:YES];
            for(int i=0;i<[_lines count];i++){
                UILabel *line = (UILabel *)[_lines objectAtIndex:i];
                if(line.tag == btn.tag)
                    line.hidden = NO;
                else
                    line.hidden = YES;
            }
            //            [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
            [UIView animateWithDuration:0.3 animations:^{
                btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }];
        }else{
            [btn setSelected:NO];
            //            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [UIView animateWithDuration:0.3 animations:^{
                btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }
        //        [UIView animateWithDuration:0.5 animations:^{
        //            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        //        }];
    }
}

//进入页面时隐藏顶部导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;//显示底部tabBar
    self.navigationController.navigationBarHidden = NO;//隐藏顶部导航栏
}
//-(void)viewWillDisappear:(BOOL)animated{
////    self.navigationController.navigationBarHidden = NO;
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

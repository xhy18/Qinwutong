//
//  HomePageVC.m
//  QinWuTong
//
//  Created by ltl on 2018/11/20.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "HomePageVC.h"
#import "HPViewController.h"
#import "ScrollTableViewCell.h"
#import "HomePageCollectionVC.h"
#import "CollectionViewCell.h"

@interface HomePageVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *collection;
}
@property(strong, nonatomic) UIScrollView *indexscrol;
@property(nonatomic,retain)NSMutableArray * imageName;
@property(nonatomic,retain)NSMutableArray * tag_array;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBarHidden = YES;
    
    UIColor *bgColor =[UIColor colorWithRed:216/255.0 green:30/255.0 blue:6/255.0 alpha:1.0];//主色调D81E06
    CGFloat topOffset = 10;//自顶部向下的偏移量
    CGFloat frameWidth = self.view.bounds.size.width;
    CGFloat frameHeight = self.view.bounds.size.height;
    CGFloat btnWidth = 30;
    CGFloat btnHeight = 40;//顶部左右侧两个按钮的hw
    CGFloat blankWid = 5;
    
    UILabel *topBg = [[UILabel alloc]init];//顶部地址、搜索栏的背景label
    topBg.backgroundColor = bgColor;
    topBg.frame = CGRectMake(0, 0, frameWidth, 2*btnHeight+4*blankWid);
    [self.view addSubview:topBg];
    
    UILabel *addressTxt = [[UILabel alloc]init];
    addressTxt.frame = CGRectMake(2*blankWid+btnWidth, blankWid+topOffset, frameWidth - 2*btnWidth-4*blankWid, btnHeight);
    addressTxt.text = @"西安市";//【tag】替换为动态地址数据
    addressTxt.contentMode = UIViewContentModeCenter;
    addressTxt.textColor = [UIColor whiteColor];
    [self.view addSubview:addressTxt];
//    topBg.text = @"1`2";
//    UIImage *positionImg = [UIImage imageNamed:@"location.png"];
//    UIImageView *position = [[UIImageView alloc] initWithImage:positionImg];
//    UIButton *location = [[UIButton alloc] init];
//    location.imageView = position;
    

    UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
    location.frame = CGRectMake(10, 10+topOffset, btnWidth, btnHeight);//设置位置和大小
    location.backgroundColor = bgColor;
    [location setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [location setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    location.titleLabel.font = [UIFont systemFontOfSize:15];
    [location addTarget:self action:@selector(testButtonClick) forControlEvents:UIControlEventTouchUpInside];//点击事件
    //将button添加到父self.view上来做显示
    [self.view addSubview:location];
//    position.frame = CGRectMake(10, 10+topOffset, btnWidth, btnHeight);
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(blankWid, 2*blankWid+topOffset+btnHeight, frameWidth - 2*blankWid, btnHeight);
    searchBar.backgroundColor = bgColor;
    searchBar.barStyle = 0;
    searchBar.barTintColor = bgColor;
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    [self.view addSubview:searchBar];
//    UIScrollView scrollView = [[UIScrollView alloc]init];
//    scrollView.frame = CGRectMake(blankWid, 3*blankWid+topOffset+2*btnHeight, frameWidth, frameHeight-3*blankWid+topOffset+2*btnHeight-60);
//    scrollView.backgroundColor = [UIColor blackColor];

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _indexscrol = [[UIScrollView alloc] init];

    _indexscrol.frame = CGRectMake(0,3*blankWid+topOffset+2*btnHeight, frameWidth, self.view.bounds.size.height);
    _indexscrol.contentSize = CGSizeMake(0, 1850 - 60 );
    _indexscrol.backgroundColor = [UIColor whiteColor];
    _indexscrol.showsVerticalScrollIndicator = NO;
    _indexscrol.showsHorizontalScrollIndicator = NO;
    _indexscrol.delegate = self;
//    _indexscrol.scrollEnabled = YES;
//    _indexscrol.userInteractionEnabled = YES;
//    _indexscrol.contentSize = CGSizeMake(frameWidth, 100);

//    dispatch_group_notify(group,dispatch_get_main_queue(), ^{
//        NSLog(@"end");
//        // 在a、b、c、d异步执行完成后，会回调这里
        ScrollTableViewCell *lbsrol = [[ScrollTableViewCell alloc]init];
//        if(self.imageName.count > 0){
            //                ScrollTableViewCell *lbsrol = [[ScrollTableViewCell alloc]init];
            lbsrol.imageName = self.imageName;
            lbsrol.tag_array = self.tag_array;
            lbsrol.frame = CGRectMake(0, 300, screenWidth,170);
            [lbsrol addSubview:lbsrol.firstscroll];
            [lbsrol addSubview:lbsrol.mypageControl];
    
    int originY = 0;
    for(CGFloat i = 0;i<10;i++)
    {
        //创建一个视图
        UIImageView *pImageView = [[UIImageView alloc]init];
        //设置视图的背景色
        pImageView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
        //设置imageView的背景图
        [pImageView setImage:[UIImage imageNamed:@"logo.png"]];
        //给imageView设置区域
        CGRect rect = self.indexscrol.frame;
        rect.origin.x = 0;
        rect.origin.y = originY;
        rect.size.width = self.indexscrol.frame.size.width;
        rect.size.height = self.indexscrol.frame.size.height;
        pImageView.frame = rect;
        //设置图片内容的显示模式(自适应模式)
        pImageView.contentMode = UIViewContentModeScaleAspectFill;
        //把视图添加到当前的滚动视图中
        [self.indexscrol addSubview:pImageView];
        //下一张视图的x坐标:offset为:self.scrollView.frame.size.width.
        originY += self.indexscrol.frame.size.width;
        //记录scrollView内imageView的个数
//        pages++;
    }
//
//
////    1.初始化layout
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    //设置collectionView滚动方向
//    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    //设置headerView的尺寸大小
//    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
//    //该方法也可以设置itemSize
//    layout.itemSize =CGSizeMake(110, 150);
//
//
//    //2.初始化collectionView
//    collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    [self.indexscrol addSubview:collection];
//    collection.backgroundColor = [UIColor clearColor];
//
//    //3.注册collectionViewCell
//    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
//    [collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
//
//    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
//    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
//
//    //4.设置代理
//    collection.delegate = self.indexscrol;
//    collection.dataSource = self.indexscrol;
//    collection.frame = CGRectMake(0, 0, frameWidth, frameHeight);
////    HomePageCollectionVC *collection = [[HomePageCollectionVC alloc] init];
//
//    [self.indexscrol addSubview:collection];
    
//                            lbsrol.tapAction = ^(UIViewController * viewController,id rest_id){
//                                viewController.hidesBottomBarWhenPushed = YES;
//                                if(rest_id == nil){
//                                    [self.navigationController pushViewController:viewController animated:YES];
//                                }else{
//
//                                Restaurant_DetailViewController * rest = [[Restaurant_DetailViewController alloc]init];
//                                rest.hidesBottomBarWhenPushed= YES;
//                                rest.restaurantID = rest_id;
//                                [self.navigationController pushViewController:rest animated:YES];
//                            }
//                            };

            [self->_indexscrol addSubview:lbsrol];
            [lbsrol.indextimer fire];
            [lbsrol initTimerFunction];
    [self.view addSubview:self.indexscrol];
    
    
    // Do any additional setup after loading the view.
}
//---------------------------ScrollTable的点击响应函数----------------------
-(void)setupButton{
}

-(void)testButtonClick{
    NSLog(@"点啦点啦");
}
//---------------------------ScrollTable的点击响应函数----------------------
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//-------------------------Collection相关-----------------------------
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.botlabel.text = [NSString stringWithFormat:@"{%ld,%ld}",(long)indexPath.section,(long)indexPath.row];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(90, 130);
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
    headerView.backgroundColor =[UIColor grayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.text = @"这是collectionView的头部";
    label.font = [UIFont systemFontOfSize:20];
    [headerView addSubview:label];
    return headerView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *msg = cell.botlabel.text;
    NSLog(@"%@",msg);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-------------------------Collection相关-----------------------------



-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

@end

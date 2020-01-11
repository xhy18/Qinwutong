//
//  NavigationPageVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/10.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "NavigationPageVC.h"
#import "ServiceListVC.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface NavigationPageVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)NSMutableArray *firstTitle;
@property(nonatomic,retain)NSMutableArray *secondTitle;
@property(nonatomic,retain)NSMutableArray *thirdTitle;

@property(strong, nonatomic) UICollectionView *leftCollectView;
@property(strong, nonatomic) UICollectionView *rightCollectView;
//@property(strong, nonatomic) NSString *firstStr;
@property(nonatomic) int firstIndex;

@property(nonatomic) int leftWid;
@property(nonatomic) int rightWid;
@property(nonatomic) int firstFont;
@property(nonatomic) int secondFont;
@property(nonatomic) int thirdFont;

@property (nonatomic) CLLocation *location;
@end

@implementation NavigationPageVC
/*
 导航页，首页分类只有9个，第10个为导航页
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"服务分类";
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    int topOffset = statusBarFrame.size.height+navigationHeight;
    
    _leftWid = 100;
    _rightWid = SCREEN_WIDTH - _leftWid;
    _firstFont = 18;
    _secondFont = 16;
    _thirdFont = 14;
    
    [self getFirstTitles];
    
    UICollectionViewFlowLayout *layoutA = [[UICollectionViewFlowLayout alloc] init];
    layoutA.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    _leftCollectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layoutA];
    _leftCollectView.frame = CGRectMake(0, 0, _leftWid,SCREEN_HEIGHT-topOffset);
    [self.view addSubview:_leftCollectView];
    _leftCollectView.backgroundColor = [UIColor whiteColor];
    [_leftCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_leftCollectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    _leftCollectView.tag = 1;
    _leftCollectView.delegate = self;
    _leftCollectView.dataSource = self;
    
    UICollectionViewFlowLayout *layoutB = [[UICollectionViewFlowLayout alloc] init];
    layoutB.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    _rightCollectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layoutB];
    _rightCollectView.frame = CGRectMake(_leftWid, 0,SCREEN_WIDTH - _leftWid,SCREEN_HEIGHT-topOffset);
    [self.view addSubview:_rightCollectView];
    _rightCollectView.backgroundColor = grayBgColor;
    [_rightCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_rightCollectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    _rightCollectView.tag = 2;
    _rightCollectView.delegate = self;
    _rightCollectView.dataSource = self;
    
}

-(void)getFirstTitles{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:nil];
        [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/qwt/server/Server/skillone",baseUrl] Dic:dic SuccessBlock:^(id responseObject){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 1){
                dict = [dict objectForKey:@"data"];
                _firstTitle = @[].mutableCopy;
                int i = 0;
                for (NSString *str in dict) {
                    [_firstTitle addObject:str];
                }
                [_leftCollectView reloadData];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取一级目录失败：error:%@",error] method:@"getFirstTitles" vc:self];
            }
        } FailureBlock:^(id error) {
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"getFirstTitles" vc:self];
        }];
    });
}
//获取某个一级分类下的所有子目录
-(void)getSubTitle:(NSString *)firstTitle{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *res = @[].mutableCopy;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:firstTitle,@"skill",nil];
        [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/qwt/server/Server/showAllSkill",baseUrl] Dic:dic SuccessBlock:^(id responseObject){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 1){
                dict = [dict objectForKey:@"data"];
                dict = [dict objectForKey:@"child"];
                _secondTitle = @[].mutableCopy;
                _thirdTitle = @[].mutableCopy;
                int i = 0;
                for (NSDictionary *nav in dict) {
                    NSString *t2 = [nav objectForKey:@"name"];
                    NSArray *t3 = [nav objectForKey:@"childName"];
//                    [MyUtils debugMsg:t3 vc:self];
                    [_secondTitle addObject:t2];
                    [_thirdTitle addObject:t3];
                }
                [_rightCollectView clearsContextBeforeDrawing];
                [_rightCollectView reloadData];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取一级目录失败：error:%@",error] method:@"getFirstTitles" vc:self];
            }
        } FailureBlock:^(id error) {
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"getFirstTitles" vc:self];
        }];
    });
}

-(void)getChillTitle:(NSString *)fatherTitle{
    NSMutableArray *res = @[].mutableCopy;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:fatherTitle,@"skill",nil];
    [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/qwt/server/Server/childskill",baseUrl] Dic:dic SuccessBlock:^(id responseObject){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        int res = [[dict objectForKey:@"code"]integerValue];
        if(res == 1){
            dict = [dict objectForKey:@"data"];
            _firstTitle = @[].mutableCopy;
            int i = 0;
            for (NSString *str in dict) {
                [_firstTitle addObject:str];
            }
            [_firstTitle addObject:@"全部分类"];
            //                [self->sectionACV reloadData];
        }
        else{
            NSString *error = [dict objectForKey:@"error"];
            [MyUtils alertMsg:[NSString stringWithFormat:@"获取一级目录失败：error:%@",error] method:@"getFirstTitles" vc:self];
        }
    } FailureBlock:^(id error) {
        [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"getFirstTitles" vc:self];
    }];
}
-(void)setLocation:(CLLocation *)location{
    _location = location;
}
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(collectionView.tag == 1)
        return 1;
    else
        return [_secondTitle count];
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 1)
        return [_firstTitle count];
    else
        return [[_thirdTitle objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag == 1){
        UICollectionViewCell *c =(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        UILabel *lbl = [[UILabel alloc]init];
        lbl.frame = CGRectMake(3, 0, _leftWid-6, 40);
//        lbl.text = @"test";
        lbl.text = [_firstTitle objectAtIndex:indexPath.row];
        if(lbl.text.length >5){
            lbl.font = [UIFont systemFontOfSize:_firstFont-4];
            lbl.numberOfLines = 2;
        }
        else
            lbl.font = [UIFont systemFontOfSize:_firstFont];
        lbl.textAlignment = NSTextAlignmentCenter;
        c.tag = indexPath.row;
        [c.contentView addSubview:lbl];
        //---默认选中第一个一级目录
        if(indexPath.row == 0){
            _firstIndex = 0;
//            _firstStr = lbl.text;
            c.backgroundColor = grayBgColor;
            [self getSubTitle:[_firstTitle objectAtIndex:0]];
            
        }
        return c;
    }
    else{
        UICollectionViewCell *c =(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        for (UIView *view in [c.contentView subviews]){
            [view removeFromSuperview];
        }
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, _rightWid/2.2, 16)];
//        lbl.frame = CGRectMake(3, 3, _leftWid-6, 40);
        //        lbl.text = @"test";
        lbl.text = [[_thirdTitle objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if(lbl.text.length >10)
            lbl.font = [UIFont systemFontOfSize:_thirdFont-2];
        else
            lbl.font = [UIFont systemFontOfSize:_thirdFont];
        [c.contentView addSubview:lbl];
        return c;
    }
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag == 1)
        return CGSizeMake(_leftWid, 40);
    if(collectionView.tag == 2)
        return CGSizeMake(_rightWid/2.2, 20);
    return CGSizeMake(0, 0);
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(collectionView.tag == 2)
        return CGSizeMake(10, 20);
    else
        return CGSizeMake(0, 0);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(collectionView.tag == 2)
        return UIEdgeInsetsMake(10, 10, 10, 10);
    else
        return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if(collectionView.tag == 1)
        return 5;
    else
        return 2;
}


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    if(collectionView.tag == 1){
        return headerView;
    }
    for (UIView *view in [headerView subviews]){
        [view removeFromSuperview];
    }
    headerView.backgroundColor =[UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.text = [NSString stringWithFormat:@"%@ >>",[_secondTitle objectAtIndex:indexPath.section]];
//    label.font = [UIFont systemFontOfSize:_secondFont];
    [label setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:_secondFont]];
    label.frame = CGRectMake(5, 0, _rightWid, 20);
//    label.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:label];
    return headerView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag == 1){
//        _firstStr = ;
        _firstIndex = indexPath.row;
        [self getSubTitle:[_firstTitle objectAtIndex:indexPath.row]];
//        NSArray *cells = _leftCollectView.visibleCells;
//        NSLog(@"array count = %d",[cells count]);
//        for (UICollectionViewCell *cell in cells) {
//            NSLog(@"%d",cell.tag);
//        }
        for (UICollectionViewCell *cell in _leftCollectView.visibleCells) {
//            NSLog(@"%d",cell.tag);
            if(cell.tag == indexPath.row)
                cell.backgroundColor = grayBgColor;
            else
                cell.backgroundColor = [UIColor whiteColor];
        }
    }
    if(collectionView.tag == 2){
        UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSString *msg = [[_thirdTitle objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//        if(!msg){
//            [MyUtils alertMsg:@"未获取到一级目录数据" method:@"点击item方法" vc:self];
//            return;
//        }
        NSLog(@"%@",msg);
        
        ServiceListVC *vc = [[ServiceListVC alloc] init];
//        [vc setTitle:msg setLocation:_location];
        [vc setTitles:[_firstTitle objectAtIndex:_firstIndex] second:[_secondTitle objectAtIndex:indexPath.section] third:msg setLocation:_location];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
//当左collectionview滑到底部的时候，遍历collectionViewCell居然拿不到第一个（已经滑出屏幕），只好在滚动事件中去修改他的选中颜色
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (UICollectionViewCell *cell in _leftCollectView.visibleCells) {
        if(cell.tag == _firstIndex)
            cell.backgroundColor = grayBgColor;
        else
            cell.backgroundColor = [UIColor whiteColor];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
}
@end

//
//  ScrollTableViewCell.m
//  MyProject2
//
//  Created by macbook for test on 2018/6/18.
//  Copyright © 2018年 JackPanda8. All rights reserved.
//

#import "ScrollTableViewCell.h"
//#import "DIYAFNetworking.h"
//#import "UIImageView+WebCache.h"
//#import "Youhuiquan_ViewController.h"
//#import "Tuancan_ViewController.h"
//#import "Mansong_ViewController.h"
//#import "Restaurant_DetailViewController.h"
//#import "UIImageView+WebCache.h"
//#import "MJExtension.h"
//#import "MyUtils.h"
@implementation ScrollTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//下面的点
//-(UIPageControl *)mypageControl{
//    if(!_mypageControl){
//        _mypageControl = [[UIPageControl alloc] init];
//        _mypageControl.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2, 130, 100, 10);
//        //_mypageControl.backgroundColor = [UIColor purpleColor];
//        _mypageControl.numberOfPages = self.imageName.count;   //图片个数不一定
//        _mypageControl.pageIndicatorTintColor = [UIColor whiteColor];
//        UIColor *textColor = [UIColor colorWithRed:80.0/255.0 green:227.0/255.0 blue:194/255.0 alpha:1.0];
//        _mypageControl.currentPageIndicatorTintColor = textColor;
//        _mypageControl.currentPage = 0;
//    }
//    return _mypageControl;
//}
////首页广告位
//-(UIScrollView *)firstscroll{
//
//    if(!_firstscroll){
//        _firstscroll = [[UIScrollView alloc] init];
//        _firstscroll.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170);
//        _firstscroll.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)*self.imageName.count, 180);
//        //_firstscroll.backgroundColor = [UIColor grayColor];
//        _firstscroll.showsVerticalScrollIndicator = NO;
//        _firstscroll.showsHorizontalScrollIndicator = NO;
//        _firstscroll.pagingEnabled = YES;
//        _firstscroll.delegate = self;
//
//        for(int i=0;i<self.imageName.count;i++){
//            CGFloat lbimagex = i * [UIScreen mainScreen].bounds.size.width;
//            UIImageView *imageV = [[UIImageView alloc] init];
//            imageV.tag = i;
//            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//            imageV.userInteractionEnabled = YES;
//            [imageV addGestureRecognizer:tap];
//
//            imageV.frame = CGRectMake(lbimagex, 0, [UIScreen mainScreen].bounds.size.width, 168);
//            //imageV.backgroundColor = [UIColor redColor];
//            NSString * imageName = [MyUtils GetImageUrl:self.imageName[i] imageStyle:@"detail"];
//            NSLog(@"imglunb:%@",imageName);
//            [imageV sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"德餐2.jpg"]];
//            [_firstscroll addSubview:imageV];
//            [_firstscroll addSubview:self.mypageControl];
//        }/**/
//    }
//    return _firstscroll;
//}
////首页广告位
//-(void)tapAction:(UITapGestureRecognizer *)tap{
//
//    int i = _firstscroll.contentOffset.x/_firstscroll.frame.size.width;
//
//    if (self.tapAction) {
//        if ([self.tag_array[i] isEqual:@"满送"]) {
//            Mansong_ViewController * mansong = [[Mansong_ViewController alloc]init];
//            self.tapAction(mansong,nil);
//        }else if ([self.tag_array[i] isEqual:@"优惠券"]){
//            Youhuiquan_ViewController * youhui = [[Youhuiquan_ViewController alloc]init];
//            self.tapAction(youhui,nil);
//        }else if ([self.tag_array[i] isEqual:@"团餐"]){
//            Tuancan_ViewController * tuancan = [[Tuancan_ViewController alloc]init];
//            self.tapAction(tuancan,nil);
//        }else{
//            Restaurant_DetailViewController * rest = [[Restaurant_DetailViewController alloc]init];
//            self.tapAction(rest,self.tag_array[i]);
//        }
//
//
//    }
//
//}
////餐馆主页
-(UIPageControl *)mypageControl_1{
    if(!_mypageControl_1){
//        NSDictionary * dic =self.img_model.mj_keyValues;
//        NSArray * key_array = [dic allKeys];
//        NSInteger count =[key_array count];

          NSInteger count =[self.img_array count];
        _mypageControl_1 = [[UIPageControl alloc] init];
        _mypageControl_1.frame = CGRectMake(30,130, 100, 10);
        _mypageControl_1.numberOfPages = count;   //图片个数不一定
        _mypageControl_1.pageIndicatorTintColor = [UIColor whiteColor]; //设置指示器默认的颜色
        UIColor *textColor = [UIColor colorWithRed:80.0/255.0 green:227.0/255.0 blue:194/255.0 alpha:1.0];
        _mypageControl_1.currentPageIndicatorTintColor = textColor; //当前选中的颜色
        _mypageControl_1.currentPage = 0;   //设置当前默认显示位置
    }
    return _mypageControl_1;
}
//餐馆主页上的scrollerview
-(UIScrollView *)firstscroll_1{

    if(!_firstscroll_1){
//        NSMutableArray * imageName = [[NSMutableArray alloc]initWithCapacity:1];
//        NSDictionary * dic =self.img_model.mj_keyValues;
//        NSArray * key_array = [dic allKeys];
//        NSInteger count =[key_array count];
//        for (int i=1; i<=count; i++) {
//            NSString * str=[NSString stringWithFormat:@"img%d",i];
//            [imageName addObject:[dic objectForKey:str]];
//        }

        NSInteger count =self.img_array.count;
        _firstscroll_1 = [[UIScrollView alloc] init];
        //        _firstscroll.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
        _firstscroll_1.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width/2-15, 150);
        _firstscroll_1.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width/2-15)*count, 150);
        //滚动视图的大小
        _firstscroll_1.showsVerticalScrollIndicator = NO;
        _firstscroll_1.showsHorizontalScrollIndicator = NO;
        //是否显示水平滚动标示
        _firstscroll_1.pagingEnabled = YES;
        //是否支持翻页
        _firstscroll_1.delegate = self;
        //委托对象
        //添加图片

        for(int i=0;i<self.img_array.count;i++){

            CGFloat lbimagex = i * ([UIScreen mainScreen].bounds.size.width/2-15);  //每张图片的位置
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.frame = CGRectMake(lbimagex, 0,([UIScreen mainScreen].bounds.size.width/2-15), 150);

//            [imageV sd_setImageWithURL:[NSURL URLWithString:imageName[i]]];
//            NSString *thestrurl = [MyUtils GetImageUrl:self.img_array[i] imageStyle:@"detail"];
//            [imageV sd_setImageWithURL:[NSURL URLWithString:thestrurl] placeholderImage:[UIImage imageNamed:@"德餐2.jpg"]];

            [_firstscroll_1 addSubview:imageV];
            [_firstscroll_1 addSubview:self.mypageControl_1];
        }/**/
    }
    return _firstscroll_1;
}
-(void)initTimerFunction{
    //创建计时器
    NSTimer *thetimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoSelectPage) userInfo:nil repeats:YES];
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    [mainLoop addTimer:thetimer forMode:NSRunLoopCommonModes];
    self.indextimer = thetimer;
}

-(void)autoSelectPage{
    CGPoint offset1 = self.firstscroll.contentOffset;
    NSInteger currentPage = self.mypageControl.currentPage;
    if(currentPage == self.imageName.count - 1){
        currentPage = 0;
        offset1 = CGPointZero;
        //更新offset
        [self.firstscroll setContentOffset:offset1 animated:NO];
    }else{
        currentPage++;
        offset1.x += [UIScreen mainScreen].bounds.size.width;
        [self.firstscroll setContentOffset:offset1 animated:YES];
    }
    self.mypageControl.currentPage = currentPage;
}
-(void)initTimerFunction_1{
    //创建计时器
    NSTimer *thetimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoSelectPage_1) userInfo:nil repeats:YES];
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    [mainLoop addTimer:thetimer forMode:NSRunLoopCommonModes];
    self.indextimer = thetimer;
}

-(void)autoSelectPage_1{
//    NSDictionary * dic =self.img_model.mj_keyValues;
//    NSArray * key_array = [dic allKeys];
//    NSInteger count =[key_array count];
    NSInteger count =self.img_array.count;
    //取出当前的偏移量
    CGPoint offset1 = self.firstscroll_1.contentOffset;
    //设置当前的设置显示的page的展示
    NSInteger currentPage = self.mypageControl_1.currentPage;
    
    if(currentPage == count-1){
        //设置为初始值
        currentPage = 0;
        offset1 = CGPointZero;
        //更新offset
        [self.firstscroll_1 setContentOffset:offset1 animated:NO];
    }else{
        currentPage++;
        offset1.x += [UIScreen mainScreen].bounds.size.width/2-15;
        [self.firstscroll_1 setContentOffset:offset1 animated:YES];
    }
    //更新pageController显示
    self.mypageControl_1.currentPage = currentPage;
}

#pragma mark - UIScrollViewDelegate
//缓慢结束，当手势滑动scrollview的时候停止定时器任务，滑动结束的时候开启定时任务
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.indextimer invalidate];   //取消定时器任务
}
//当滑动停止时启动定时器任务
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.indextimer fire];
    if(scrollView == self.firstscroll){
        [self initTimerFunction];
    }else{
         [self initTimerFunction_1];
    }
}
//当滑动停止时调用的方法，对应的小圆点同时切换
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView == self.firstscroll){
    CGFloat indexoffset = self.firstscroll.contentOffset.x;   //获取当前scrollview的x轴方向的偏移量
    //每个图片页面的宽度
    CGFloat indexpageWi = [UIScreen mainScreen].bounds.size.width;
    self.mypageControl.currentPage = indexoffset / indexpageWi;
    }else{
            CGFloat indexoffset = self.firstscroll_1.contentOffset.x;   //获取当前scrollview的x轴方向的偏移量
            //每个图片页面的宽度
            CGFloat indexpageWi = [UIScreen mainScreen].bounds.size.width/2-15;
            //设置当前显示的位置
            self.mypageControl_1.currentPage = indexoffset / indexpageWi;
    }
}


@end

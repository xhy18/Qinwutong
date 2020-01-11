//
//  ScrollTableViewCell.h
//  MyProject2
//
//  Created by macbook for test on 2018/6/18.
//  Copyright © 2018年 JackPanda8. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "IMG_model.h"
typedef void(^ScrollTableViewCellBlock)(UIViewController * viewController,id rest_id);
@interface ScrollTableViewCell : UIView<UIScrollViewDelegate>


    @property(nonatomic, strong) UIScrollView *firstscroll;
    @property(nonatomic, strong) UIScrollView *firstscroll_1;
@property(nonatomic, strong) UIImageView *thedeaufultimg;

    @property(nonatomic, strong) UIPageControl *mypageControl;
    @property(nonatomic, strong) UIPageControl *mypageControl_1;


@property(nonatomic, strong) NSTimer *indextimer;

@property(nonatomic,copy)NSMutableArray * imageName;
@property(nonatomic,copy)NSMutableArray * tag_array;
@property(nonatomic,copy)NSMutableArray * image_array;  //餐馆的轮播图

//@property(nonatomic,strong)IMG_model * img_model ;  //餐厅主页的轮播图
@property(nonatomic,strong)NSArray * img_array ;
@property (nonatomic, copy) ScrollTableViewCellBlock tapAction;

-(void) initTimerFunction;
-(void) initTimerFunction_1;

@end

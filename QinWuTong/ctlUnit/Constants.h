//
//  Constants.h
//  QinWuTong
//
//  Created by ltl on 2018/11/29.
//  Copyright © 2018 ltl. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#endif 

static BOOL const debugMode = true;

static NSString * const TABLELEAVETOP = @"tableLeaveTop";
static NSString * const TABLETOP = @"tableTop";

static CGFloat const KTopBarHeight = 60.;   //状态栏
static CGFloat const KBottomBarHeight = 0;    //底部高度
static CGFloat const kTabTitleViewHeight = 45.;
static int const titleFontSize = 20;
static NSString * baseUrl = @"http://132.232.225.239:8080";
#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]


#define QHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QHSearchhistories.plist"]

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define statusBarFrame [[UIApplication sharedApplication] statusBarFrame]//获取顶部状态栏信息,它的长和高
#define navigationHeight self.navigationController.navigationBar.frame.size.height
#define ToolBarHeight self.navigationController.toolbar.frame.size.height
#define mainWindowHeight = [[UIScreen mainScreen] bounds].size.width-self.navigationController.toolbar.frame.size.height-statusBarFrame.size.height-self.navigationController.navigationBar.frame.size.height-5

#define KColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define themeColor  [UIColor colorWithRed:216/255.0 green:30/255.0 blue:6/255.0 alpha:1.0]  //主色调D81E06
#define grayBgColor  [UIColor colorWithRed:238/255.0 green:242/255.0 blue:243/255.0 alpha:1.0]  //灰色背景
#define labelBgGreen  [UIColor colorWithRed:34/255.0 green:176/255.0 blue:76/255.0 alpha:1.0]  //灰色背景
#define textColorOnBg  [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]  //主色背景上的文字颜色
#define textColorBlue  [UIColor colorWithRed:30/255.0 green:128/255.0 blue:184/255.0 alpha:1.0] //部分页面上蓝色字颜色
#define textColorGray  [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0]
#define tfBgColor   [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];

#define coupon_Color [UIColor colorWithRed:250.0/255.0 green:235.0/255.0 blue:140.0/255.0 alpha:1.0]
#define Manjian_Color [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1.0]
#define Location_backView_Color [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0]
//定位头视图上面的颜色
#define Location_title_Color [UIColor colorWithRed:204.0/255.0 green:97.0/255.0 blue:34.0/255.0 alpha:1.0]
#define search_back_Color [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]
#define search_back_title_Color [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0]
#define coupon_back_color [UIColor colorWithRed:255.0/255.0 green:106.0/255.0 blue:0.0/255.0 alpha:1]  //优惠券按钮上的图片
#define unuse_color [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0]  //优惠券按钮上的图片

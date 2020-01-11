//
//  AppDelegate.h
//  QinWuTong
//
//  Created by ltl on 2018/11/19.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign)BOOL allowRotation;//选择是否支持屏幕旋转（横屏）
+(void)setViewController:(UIViewController *)vc;
@end


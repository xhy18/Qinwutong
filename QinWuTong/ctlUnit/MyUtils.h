//
//  ErrorAlterVC.h
//  QinWuTong
//
//  Created by ltl on 2018/12/24.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyUtils : UIViewController
+(void)alertMsg:(NSString *)str method:(NSString *)pageName vc:(UIViewController *)vc;
+(void)debugMsg:(NSString *)str vc:(UIViewController *)vc;
+(void)testUrl:(NSDictionary *)dic;
+(bool)isBlankString:(NSString *)aStr;
+(NSString *)checkAndGetStr:(NSString *)str;
@end

NS_ASSUME_NONNULL_END

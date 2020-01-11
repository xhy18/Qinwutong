//
//  ErrorAlterVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/24.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "MyUtils.h"
#import "Constants.h"

#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface MyUtils ()

@end

@implementation MyUtils
/*
 写一些通用的静态方法。由于alert还是需要继承UIViewController的类。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+(void)debugMsg:(NSString *)str vc:(UIViewController *)vc{
    NSLog(@"\n%@,\n提示发生于\"%@\"",str,vc.class);
}
//用来判断是否是个空串。但是写的晚了很多类中都没有直接使用这个函数而是手写函数体
+(bool)isBlankString:(NSString *)aStr{
    if (!aStr || [aStr isKindOfClass:[NSNull class]]) {
        return true;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return true;
    }
    return false;
}
+(NSString *)checkAndGetStr:(NSString *)str{
    NSString *t;
    if([MyUtils isBlankString:str])
        t = @"";
    else
        t = str;
    return t;
}
//这是向一个测试用的api发送请求，结果必定成功，返回的data中为后台收到的字符串
+(void)testUrl:(NSDictionary *)dic{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appOrder/test", baseUrl] isJson:TRUE Dic:dic SuccessBlock:^(id responseObject){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"jason:%@",responseObject);
            NSLog(@"\n%@",[dict objectForKey:@"data"]);
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误error:%@",error] method:@"testUrl" vc:self];
        }
         ];
    });
}

//定义一个静态方法，用于传入error的提示信息
+(void)alertMsg:(NSString *)str method:(NSString *)methodName vc:(UIViewController *)vc{
    MyUtils *alert = [MyUtils alloc];
    [alert alert:vc error:str];
    NSLog(@"\n%@,\n错误发生于\"%@\" in %@",str,methodName,vc.class);//error位置仅显示在控制台
}
//根据提示信息，弹出提示框
-(void)alert:(UIViewController *)vc error:(NSString *)error{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sureAction];
    [vc presentViewController:alert animated:YES completion:nil];
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

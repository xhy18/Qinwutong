//
//  DIYAFNetworking.m
//  Scan Miam
//
//  Created by 秦焕 on 2018/7/3.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "DIYAFNetworking.h"
#import "AFNetworking.h"
@implementation DIYAFNetworking
+(void)PostHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock {
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",@"image/png", nil];
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (successBlock) {
            dispatch_semaphore_signal(sema);    //计数加一操作
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            dispatch_semaphore_signal(sema);    //计数加一操作
            failureBlock(error);
            
        }
        
    } ];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

+(void)GetHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock{
    
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];//    manager.requestSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",nil];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",nil];
    
    // 设置超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 6.f;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (successBlock) {
            dispatch_semaphore_signal(sema);    //计数加一操作
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            dispatch_semaphore_signal(sema);    //计数加一操作
            failureBlock(error);
            
        }
        
    } ];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

+(void)GetHttpImageDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock{
    
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"application/txt",@"text/html",nil];
    [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (successBlock) {
            dispatch_semaphore_signal(sema);    //计数加一操作
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            dispatch_semaphore_signal(sema);    //计数加一操作
            failureBlock(error);
            
        }
        
    } ];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
@end

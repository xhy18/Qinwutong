//
//  OrderObj.h
//  QinWuTong
//
//  Created by ltl on 2018/12/27.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderObj : NSObject
@property(strong , nonatomic)NSString *servicerName;
@property(strong , nonatomic)NSString *servicerId;
@property(strong , nonatomic)NSString *servicerContent;
//@property(strong , nonatomic)NSString *total;
@property(strong , nonatomic)NSString *address;
@property(strong , nonatomic)NSString *id;
@property(strong , nonatomic)NSString *orderId;
//@property(strong , nonatomic)NSString *homeFee;
@property(strong , nonatomic)NSString *dateExpected;
@property(strong , nonatomic)NSString *createTime;
@property(strong , nonatomic)NSString *servicePayBy;
@property(strong , nonatomic)NSString *servicePayTime;
@property(strong , nonatomic)NSString *serviceTradeNo;
@property(strong , nonatomic)NSString *homePayBy;
@property(strong , nonatomic)NSString *homePayTime;
@property(strong , nonatomic)NSString *homeTradeNo;
@property (nonatomic) NSMutableArray *skillsList;
@property(nonatomic, assign) float homeFee;
@property(nonatomic, assign) float total;
@property(nonatomic, assign) int state;

+(NSString *)getOrderStateInStr:(int )state;
+(NSMutableArray *)getOrderListFromDB:(NSArray *)stateList tableNeedReload:(UITableView *)tableView vc:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END

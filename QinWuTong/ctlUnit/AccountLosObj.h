//
//  AccountLosObj.h
//  QinWuTong
//
//  Created by ltl on 2019/1/17.
//  Copyright © 2019 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountLosObj : NSObject

@property(strong, nonatomic) NSString *losId;
@property(strong, nonatomic) NSString *orderId;
@property(nonatomic) float money;
@property(strong, nonatomic) NSString *createTime;
@property(nonatomic) int flag;
@end

NS_ASSUME_NONNULL_END

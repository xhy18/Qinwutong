//
//  JobObj.h
//  QinWuTong
//
//  Created by ltl on 2019/1/12.
//  Copyright © 2019 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JobObj : NSObject

@property(strong, nonatomic) NSString *positionTitle;
@property(strong, nonatomic) NSString *duties;
@property(strong, nonatomic) NSString *claim;
@property(nonatomic) int *number;
@property(strong, nonatomic) NSString *salary;
@property(strong, nonatomic) NSString *deadline;
@property(strong, nonatomic) NSString *officialWebsite;
@property(strong, nonatomic) NSString *email;
@property(nonatomic) int *jobId;
@property(strong, nonatomic) NSString *phone;
@end

NS_ASSUME_NONNULL_END

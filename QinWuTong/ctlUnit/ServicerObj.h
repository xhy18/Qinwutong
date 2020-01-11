//
//  ServicerObj.h
//  QinWuTong
//
//  Created by ltl on 2018/12/11.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServicerObj : NSObject
@property(strong , nonatomic)NSString *name;
@property(strong , nonatomic)NSString *servicerId;
@property(strong , nonatomic)NSString *phone;
@property(strong , nonatomic)NSString *sourse;
@property(strong , nonatomic)NSString *score;
@property(strong , nonatomic)NSString *distance;
@property(strong , nonatomic)NSString *skillToShow;

@property(nonatomic,retain)NSMutableArray *skills;

@property(strong , nonatomic)NSString *lat;
@property(strong , nonatomic)NSString *lon;
@end

NS_ASSUME_NONNULL_END

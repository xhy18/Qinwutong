//
//  SkillObj.h
//  QinWuTong
//
//  Created by ltl on 2018/12/4.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SkillObj : NSObject

@property(strong , nonatomic)NSString *lv1;
@property(strong , nonatomic)NSString *lv2;
@property(strong , nonatomic)NSString *lv3;//存储三级分类
@property(strong , nonatomic)NSString *unit;//规格
@property(strong , nonatomic)NSString *remark;
@property(strong , nonatomic)NSString *comments;
@property(strong , nonatomic)NSString *reply;
@property(strong , nonatomic)NSString *additionalComments;

@property(nonatomic, assign) float price;
@property(nonatomic, assign) int skillId;
@property(nonatomic, assign) int num;
@property(nonatomic, assign) float score;

@end

NS_ASSUME_NONNULL_END

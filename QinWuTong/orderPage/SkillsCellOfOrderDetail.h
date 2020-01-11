//
//  SkillsCellOfOrderDetail.h
//  QinWuTong
//
//  Created by ltl on 2019/1/3.
//  Copyright © 2019 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SkillsCellOfOrderDetail : UITableViewCell


@property(nonatomic,strong) UILabel *content;
@property(nonatomic,strong) UILabel *price;
@property(nonatomic,strong) UILabel *num;
@property(nonatomic,strong) UILabel *total;
@property(nonatomic,strong) UILabel *line;
@property(nonatomic,strong) UIButton *btn1;
@property(nonatomic,strong) UIButton *btn2;
//@property(nonatomic,strong) UILabel *state;
//@property (nonatomic, retain)NSString *orderId;

@end

NS_ASSUME_NONNULL_END

//
//  OrderCell.h
//  QinWuTong
//
//  Created by ltl on 2018/12/26.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderCell : UITableViewCell


@property(nonatomic,strong) UILabel *content;
@property(nonatomic,strong) UILabel *servicerName;
@property(nonatomic,strong) UILabel *phone;
@property(nonatomic,strong) UILabel *time;
@property(nonatomic,strong) UILabel *price;
@property(nonatomic,strong) UILabel *address;
@property(nonatomic,strong) UIImageView *img;
@property(nonatomic,strong) UIButton *btn;
@property(nonatomic,strong) UILabel *state;
@property (nonatomic, retain)NSString *orderId;
@end

NS_ASSUME_NONNULL_END

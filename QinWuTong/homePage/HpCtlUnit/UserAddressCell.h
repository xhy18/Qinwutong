//
//  UserAddressCell.h
//  QinWuTong
//
//  Created by ltl on 2018/12/26.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserAddressCell : UITableViewCell


@property(nonatomic,strong) UILabel * address;
@property(nonatomic,strong) UILabel * name;
@property(nonatomic,strong) UILabel * tel;
@property(nonatomic,strong) UIButton * edit;
@property(nonatomic,strong) UIButton * choose;

@end

NS_ASSUME_NONNULL_END

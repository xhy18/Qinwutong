//
//  PersonalCenterCellTableViewCell.h
//  QinWuTong
//
//  Created by ltl on 2018/12/31.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalCenterCell : UITableViewCell

@property(strong, nonatomic) UIImageView *icon;
@property(strong, nonatomic) UILabel *title;
@property(strong, nonatomic) UIButton *moreInfo;

@end

NS_ASSUME_NONNULL_END

//
//  ServiceSkillCell.h
//  QinWuTong
//
//  Created by ltl on 2018/12/13.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceSkillCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *skill;
@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UILabel *unit;
@property (strong, nonatomic) UILabel *score;
@property (strong, nonatomic) UIButton *sendOrder;


@property (strong, nonatomic) UILabel *num;
@property (strong, nonatomic) UIButton *add;
@property (strong, nonatomic) UIButton *cut;

@property(strong, nonatomic) UITextField *remark;
@property (strong, nonatomic) UILabel *remarkLbl;

@end

NS_ASSUME_NONNULL_END

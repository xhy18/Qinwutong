//
//  SectionCCollectionCell.h
//  QinWuTong
//
//  Created by ltl on 2018/11/23.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SectionCCollectionCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *topImg;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *distance;
@property (strong, nonatomic) UILabel *address;
@property (strong, nonatomic) UILabel *services;
@property (strong, nonatomic) UILabel *line;

@end

NS_ASSUME_NONNULL_END

//
//  ServiceListCell.h
//  QinWuTong
//
//  Created by ltl on 2018/11/30.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDZStarsControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServiceListCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *tel;
@property (strong, nonatomic) UILabel *distance;
@property (strong, nonatomic) UILabel *address;
@property (strong, nonatomic) UILabel *services;
@property (strong, nonatomic) UILabel *line;
@property (strong, nonatomic) UILabel *bgLabel;
@property (nonatomic , strong)CDZStarsControl *starsControl;

@property (strong, nonatomic) NSString *servicerId;

@property (nonatomic) float *score;

@end

NS_ASSUME_NONNULL_END

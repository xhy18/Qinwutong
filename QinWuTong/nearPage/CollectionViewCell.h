//
//  CollectionViewCell.h
//  QinWuTong
//
//  Created by ltl on 2018/11/27.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *tel;
@property (strong, nonatomic) UILabel *distance;
@property (strong, nonatomic) UILabel *address;
@property (strong, nonatomic) UILabel *services;
@property (strong, nonatomic) UILabel *line;
@property (strong, nonatomic) UILabel *bgLabel;

@end

NS_ASSUME_NONNULL_END

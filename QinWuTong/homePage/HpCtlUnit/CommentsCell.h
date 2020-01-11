//
//  appraiseCell.h
//  QinWuTong
//
//  Created by ltl on 2018/12/17.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentsCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *grade;
@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *content;
@property (strong, nonatomic) UILabel *replyContent;
@property (strong, nonatomic) UILabel *appendContent;
@property (strong, nonatomic) UILabel *serverName;
@property (strong, nonatomic) UILabel *serverContent;
//@property (strong, nonatomic) UIButton *sendOrder;

//根据字体大小获得标签的宽度
+(CGSize)theStr:(NSString *)str theFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END

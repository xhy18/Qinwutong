//
//  JobsCellTableViewCell.h
//  QinWuTong
//
//  Created by ltl on 2019/1/12.
//  Copyright © 2019 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JobsCell : UITableViewCell
@property(nonatomic,strong) UILabel *positionTitle;
@property(nonatomic,strong) UILabel *deadline;
@property(nonatomic,strong) UILabel *number;
@end

NS_ASSUME_NONNULL_END

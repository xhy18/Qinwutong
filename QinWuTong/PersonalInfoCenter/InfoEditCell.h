//
//  InfoEditCell.h
//  QinWuTong
//
//  Created by ltl on 2019/1/11.
//  Copyright © 2019 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoEditCell :  UITableViewCell

//@property(strong, nonatomic) UILabel *content;
@property(strong, nonatomic) UILabel *title;
@property(strong, nonatomic) UITextField *content;
//@property(strong, nonatomic) NSString *titleStr;
//
@property(nonatomic) int index;

-(void)setStyle:(bool)editable;
@end

NS_ASSUME_NONNULL_END

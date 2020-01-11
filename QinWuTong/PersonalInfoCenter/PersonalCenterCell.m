//
//  PersonalCenterCellTableViewCell.m
//  QinWuTong
//
//  Created by ltl on 2018/12/31.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "PersonalCenterCell.h"

#import "Constants.h"

@implementation PersonalCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat imgWid = 30;
        CGFloat labelFontsize = 20;
        CGFloat topBlank = 12;
        
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, topBlank, imgWid, imgWid)];
        [self.contentView addSubview:_icon];
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(5+_icon.frame.origin.x+_icon.frame.size.width, 0, 100, 54)];
        _title.font = [UIFont systemFontOfSize:labelFontsize];
        [self.contentView addSubview:_title];
        _moreInfo = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-5-30, topBlank, 30, 30)];
        _moreInfo.backgroundColor = [UIColor clearColor];
        [_moreInfo setImage:[UIImage imageNamed:@"icon_right1.png"] forState:UIControlStateNormal];
        //        [launch addTarget:self action:@selector(launchClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_moreInfo];
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5, _title.frame.origin.y+_title.frame.size.height+3, SCREEN_WIDTH-10, 1)];
//        line.backgroundColor = grayBgColor;
//        [self.contentView addSubview:line];
        //        NSLog(@"输出当前cell的高度：%d",5+_price.frame.origin.y+_price.frame.size.height);
        //        _address = [[UILabel alloc]init];
        //        [self.contentView addSubview:_address];
        
        
    }
    
    return self;
}
@end

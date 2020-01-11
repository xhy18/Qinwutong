//
//  SkillsCellOfOrderDetail.m
//  QinWuTong
//
//  Created by ltl on 2019/1/3.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "SkillsCellOfOrderDetail.h"
#import "Constants.h"

@interface SkillsCellOfOrderDetail ()

@end

@implementation SkillsCellOfOrderDetail

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
        CGFloat labelHei = 16;
        CGFloat labelFontsize = 14;
        _content = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-10, labelHei+2)];
        _content.font = [UIFont systemFontOfSize:labelFontsize+2];
        [self.contentView addSubview:_content];
        _price = [[UILabel alloc]initWithFrame:CGRectMake(5, 5+_content.frame.origin.y+_content.frame.size.height, 150, labelHei)];
        _price.font = [UIFont systemFontOfSize:labelFontsize];
        [self.contentView addSubview:_price];
        _num = [[UILabel alloc]initWithFrame:CGRectMake(155, _price.frame.origin.y, 100, labelHei)];
        _num.font = [UIFont systemFontOfSize:labelFontsize];
        [self.contentView addSubview:_num];
        _total = [[UILabel alloc]initWithFrame:CGRectMake(260, _price.frame.origin.y, SCREEN_WIDTH-260, labelHei)];
        _total.font = [UIFont systemFontOfSize:labelFontsize];
        _total.textColor = themeColor;
        [self.contentView addSubview:_total];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(5, _price.frame.origin.y+_price.frame.size.height+3, SCREEN_WIDTH-10, 1)];
        _line.backgroundColor = grayBgColor;
        [self.contentView addSubview:_line];
        CGFloat btnWid = 60;
        _btn1 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-5-btnWid, _line.frame.origin.y+6, btnWid, 28)];
        //        [launch setTitle:@"登 陆" forState:UIControlStateNormal];
        _btn1.titleLabel.textColor = textColorOnBg;
        _btn1.titleLabel.font = [UIFont systemFontOfSize:labelFontsize];
        _btn1.backgroundColor = themeColor;
        _btn1.layer.cornerRadius = 4;
        //        [launch addTarget:self action:@selector(launchClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn1];
        
        _btn2 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-2*btnWid, _line.frame.origin.y+6, btnWid, 28)];
        //        [launch setTitle:@"登 陆" forState:UIControlStateNormal];
        _btn2.titleLabel.textColor = textColorOnBg;
        _btn2.titleLabel.font = [UIFont systemFontOfSize:labelFontsize];
        _btn2.backgroundColor = themeColor;
        _btn2.layer.cornerRadius = 4;
        //        [launch addTarget:self action:@selector(launchClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn2];
    }
    
    return self;
}
@end

//
//  OrderCell.m
//  QinWuTong
//
//  Created by ltl on 2018/12/26.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "OrderCell.h"
#import "Constants.h"

@interface OrderCell ()

@end

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.content = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, self.frame.size.width, 25)];
//        self.content.backgroundColor = [UIColor redColor];
//        [self.content setFont:[UIFont boldSystemFontOfSize:20]];
//        [self.content setTextColor:[UIColor whiteColor]];
//        [self.contentView addSubview:self.content];
//        NSLog(@"%f", frame.size.width);
//    }
//
//    return self;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //@property(nonatomic,strong) UILabel * content;
//        @property(nonatomic,strong) UILabel * name;
//        @property(nonatomic,strong) UILabel * phone;
//        @property(nonatomic,strong) UILabel * time;
//        @property(nonatomic,strong) UILabel * price;
//        @property(nonatomic,strong) UILabel * address;
        CGFloat imgWid = 60;
        CGFloat btnWid = 65;
        UIColor *grayTextColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1.0];
        CGFloat labelHei = 16;
        CGFloat labelFontsize = 14;
        CGFloat labelBlank = 3;
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, imgWid, imgWid)];
        [self.contentView addSubview:_img];
        
        _servicerName = [[UILabel alloc]initWithFrame:CGRectMake(5+_img.frame.origin.x+_img.frame.size.width, 5, SCREEN_WIDTH-imgWid-btnWid-20, labelHei+2)];
        _servicerName.font = [UIFont systemFontOfSize:labelFontsize+2];
        [self.contentView addSubview:_servicerName];
        _time = [[UILabel alloc]initWithFrame:CGRectMake(5+_img.frame.origin.x+_img.frame.size.width, labelBlank+_servicerName.frame.origin.y+_servicerName.frame.size.height, SCREEN_WIDTH-imgWid-btnWid-20, labelHei)];
        _time.font = [UIFont systemFontOfSize:labelFontsize];
        _time.textColor = grayTextColor;
        [self.contentView addSubview:_time];
        _content = [[UILabel alloc]initWithFrame:CGRectMake(5+_img.frame.origin.x+_img.frame.size.width, labelBlank+_time.frame.origin.y+_time.frame.size.height, SCREEN_WIDTH-imgWid-btnWid-20, labelHei)];
        _content.font = [UIFont systemFontOfSize:labelFontsize];
        _content.textColor = grayTextColor;
        [self.contentView addSubview:_content];
//        _phone = [[UILabel alloc]init];
//        [self.contentView addSubview:_phone];
//        _time = [[UILabel alloc]initWithFrame:CGRectMake(5+_img.frame.origin.x+_img.frame.size.width, labelBlank+_content.frame.origin.y+_content.frame.size.height, SCREEN_WIDTH-imgWid-btnWid-20, labelHei)];
//        _time.font = [UIFont systemFontOfSize:labelFontsize];
//        _time.textColor = grayTextColor;
        [self.contentView addSubview:_time];
        _price = [[UILabel alloc]initWithFrame:CGRectMake(5+_img.frame.origin.x+_img.frame.size.width, labelBlank+_content.frame.origin.y+_content.frame.size.height, SCREEN_WIDTH-imgWid-btnWid-20, labelHei)];
        _price.font = [UIFont systemFontOfSize:labelFontsize];
        _price.textColor = grayTextColor;
        [self.contentView addSubview:_price];
        _btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-5-btnWid-(90-btnWid)/2, 42, btnWid, 35)];
//        [launch setTitle:@"登 陆" forState:UIControlStateNormal];
        _btn.titleLabel.textColor = textColorOnBg;
        _btn.titleLabel.font = [UIFont systemFontOfSize:labelFontsize+4];
        _btn.backgroundColor = themeColor;
        _btn.layer.cornerRadius = 4;
//        [launch addTarget:self action:@selector(launchClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn];
        _state = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-5-90, 5, 90, labelHei+2)];
        _state.font = [UIFont systemFontOfSize:labelFontsize+2];
        _state.textColor = textColorBlue;
        _state.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_state];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5, _price.frame.origin.y+_price.frame.size.height+3, SCREEN_WIDTH-10, 1)];
        line.backgroundColor = grayBgColor;
        [self.contentView addSubview:line];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSLog(@"输出当前cell的高度：%d",5+_price.frame.origin.y+_price.frame.size.height);
//        _address = [[UILabel alloc]init];
//        [self.contentView addSubview:_address];
        
        
    }
    
    return self;
}


@end

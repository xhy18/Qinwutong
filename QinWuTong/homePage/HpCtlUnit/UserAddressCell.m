//
//  UserAddressCell.m
//  QinWuTong
//
//  Created by ltl on 2018/12/26.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "UserAddressCell.h"
#import "Constants.h"

@interface UserAddressCell ()

@end

@implementation UserAddressCell

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

        CGFloat editBtnWid = 30;
        _choose = [[UIButton alloc]initWithFrame:CGRectMake(5, 14, 16, 16)];
        [_choose setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        _choose.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_choose];
        _address = [[UILabel alloc]initWithFrame:CGRectMake(_choose.frame.origin.x+_choose.frame.size.width+7, 3, SCREEN_WIDTH-20-editBtnWid-28, 20)];
        _address.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_address];
        _tel = [[UILabel alloc]initWithFrame:CGRectMake(_choose.frame.origin.x+_choose.frame.size.width+7, 28, 200, 16)];
        _tel.font = [UIFont systemFontOfSize:16];
        _tel.textColor = textColorGray;
        [self.contentView addSubview:_tel];
        _name = [[UILabel alloc]initWithFrame:CGRectMake(_tel.frame.origin.x+_tel.frame.size.width, 30, 200, 16)];
        _name.font = [UIFont systemFontOfSize:16];
        _name.textColor = textColorGray;
        [self.contentView addSubview:_name];
        _edit = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-5-editBtnWid, 7, editBtnWid, editBtnWid)];
        [_edit setImage:[UIImage imageNamed:@"icon_edit.png"] forState:UIControlStateNormal];
        _edit.backgroundColor = [UIColor clearColor];
//        [_edit setTitle:@"编辑" forState:UIControlStateNormal];
//        _edit.titleLabel.textColor = textColorOnBg;
//        _edit.layer.cornerRadius = 2;
//        _edit.titleLabel.font = [UIFont systemFontOfSize:24];
//        _edit.hidden = NO;
        [self.contentView addSubview:_edit];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5, _name.frame.origin.y+_name.frame.size.height+3, SCREEN_WIDTH-10, 1)];
        line.backgroundColor = grayBgColor;
        [self.contentView addSubview:line];
        
        
    }
    
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  JobsCellTableViewCell.m
//  QinWuTong
//
//  Created by ltl on 2019/1/12.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "JobsCell.h"
#import "Constants.h"

@implementation JobsCell

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
        
        _number = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150, 5, 140, 24)];
        _number.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_number];
        
        _positionTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-_number.frame.origin.x-15, 24)];
        _positionTitle.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_positionTitle];
        
        _deadline = [[UILabel alloc]initWithFrame:CGRectMake(5, _positionTitle.frame.origin.y+_positionTitle.frame.size.height+3, SCREEN_WIDTH-10, 24)];
        _deadline.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_deadline];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5, _deadline.frame.origin.y+_deadline.frame.size.height+3, SCREEN_WIDTH-10, 1)];
        line.backgroundColor = grayBgColor;
        [self.contentView addSubview:line];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}

@end

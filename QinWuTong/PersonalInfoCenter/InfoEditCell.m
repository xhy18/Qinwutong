//
//  InfoEditCell.m
//  QinWuTong
//
//  Created by ltl on 2019/1/11.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "InfoEditCell.h"
#import "Constants.h"

@interface InfoEditCell ()

@end

@implementation InfoEditCell

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
        _title = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 40)];
        _title.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_title];
        _content = [[UITextField alloc]initWithFrame:CGRectMake(110, 2, SCREEN_WIDTH-130, 36)];
        _content.font = [UIFont systemFontOfSize:20];
        _content.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_content];
        
    }
    
    return self;
}
-(void)setStyle:(bool)editable{
    if(editable){
        _content.backgroundColor = tfBgColor;
        _content.enabled = YES;
        _content.borderStyle = UITextBorderStyleRoundedRect;
        if([_content.text isEqualToString:@"(未填写)"])
            _content.text = @"";
    }
    else{
        _content.backgroundColor = [UIColor whiteColor];
        _content.enabled = NO;
        _content.borderStyle = UITextBorderStyleNone;
        if([_content.text isEqualToString:@""])
            _content.text = @"(未填写)";
    }
}
@end

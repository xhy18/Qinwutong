//
//  appraiseCell.m
//  QinWuTong
//
//  Created by ltl on 2018/12/17.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "CommentsCell.h"

@interface CommentsCell ()

@end

@implementation CommentsCell

- (void)viewDidLoad {
    //    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _name =[[UILabel alloc] init];
        [self.contentView addSubview:_name];
        _price =[[UILabel alloc] init];
        [self.contentView addSubview:_price];
        _content =[[UILabel alloc] init];
        _content.numberOfLines = 0;
//        [_content drawTextInRect:<#(CGRect)#>]
        [self.contentView addSubview:_content];
        _replyContent =[[UILabel alloc] init];
        [self.contentView addSubview:_replyContent];
        _appendContent =[[UILabel alloc] init];
        [self.contentView addSubview:_appendContent];
        _grade =[[UILabel alloc] init];
        [self.contentView addSubview:_grade];
        _time =[[UILabel alloc] init];
        [self.contentView addSubview:_time];
        
        
        _photo  = [[UIImageView alloc] init];
//        _topImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_photo];
    }
    return self;
}
+(CGSize)theStr:(NSString *)str theFont:(UIFont *)font{
    return [str sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:font.fontName size:font.pointSize]}];
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

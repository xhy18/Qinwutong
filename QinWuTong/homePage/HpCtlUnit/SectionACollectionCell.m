//
//  SectionACollectionCell.m
//  QinWuTong
//
//  Created by ltl on 2018/11/22.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "SectionACollectionCell.h"

@interface SectionACollectionCell ()

@end

@implementation SectionACollectionCell

- (void)viewDidLoad {
    //    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _topImage  = [[UIImageView alloc] init];
        _topImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_topImage];
        
        _botlabel = [[UILabel alloc] init];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor blackColor];
        _botlabel.font = [UIFont systemFontOfSize:10];
        _botlabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_botlabel];
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

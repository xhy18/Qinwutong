//
//  onGoingCell.m
//  QinWuTong
//
//  Created by ltl on 2018/12/20.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "onGoingCell.h"

@implementation onGoingCell

- (void)viewDidLoad {
    //    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _botlabel = [[UILabel alloc] init];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor blackColor];
        _botlabel.font = [UIFont systemFontOfSize:10];
        _botlabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_botlabel];
    }
    
    return self;
}
@end

//
//  BtnForOrderDetail.m
//  QinWuTong
//
//  Created by ltl on 2019/1/15.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "BtnForOrderDetail.h"

@implementation BtnForOrderDetail
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    
    
//    imageF.origin.x = 0;
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
//    titleF.origin.x = CGRectGetMaxX(imageF) + 10;
    self.titleLabel.frame = CGRectMake(self.frame.size.height+10, 0, self.frame.size.width - self.frame.size.height-10, self.frame.size.height);;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

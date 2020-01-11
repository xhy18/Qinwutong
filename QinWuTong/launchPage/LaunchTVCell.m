//
//  LaunchTVCell.m
//  QinWuTong
//
//  Created by ltl on 2018/11/28.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "LaunchTVCell.h"

@interface LaunchTVCell ()

@end

@implementation LaunchTVCell

- (void)viewDidLoad {
    //    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _input = [[UITextField alloc]init];
        _input.borderStyle = UITextBorderStyleBezel;
//        _username.frame = CGRectMake(80, 2, 400, 40);
//        _input.text = @"user";
//        _input.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_input];
        _label = [[UILabel alloc]init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.cornerRadius = 5;
        _label.layer.masksToBounds = YES;
//        _label.backgroundColor = [UIColor purpleColor];
//        _label.layer.borderColor = [UIColor grayColor];
        _label.layer.borderWidth = 1;
        [self.contentView addSubview:_label];
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

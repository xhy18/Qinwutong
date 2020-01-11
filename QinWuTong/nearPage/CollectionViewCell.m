//
//  CollectionViewCell.m
//  QinWuTong
//
//  Created by ltl on 2018/11/27.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@end

@implementation CollectionViewCell

- (void)viewDidLoad {
    //    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _bgLabel =[[UILabel alloc] init];
        _bgLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgLabel];
        _photo =[[UIImageView alloc] init];
        [self.contentView addSubview:_photo];
        _name =[[UILabel alloc] init];
        [self.contentView addSubview:_name];
        _tel =[[UILabel alloc] init];
        [self.contentView addSubview:_tel];
        _distance =[[UILabel alloc] init];
        [self.contentView addSubview:_distance];
        _address =[[UILabel alloc] init];
        [self.contentView addSubview:_address];
        _services =[[UILabel alloc] init];
        [self.contentView addSubview:_services];
        _line =[[UILabel alloc] init];
        _line.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_line];
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

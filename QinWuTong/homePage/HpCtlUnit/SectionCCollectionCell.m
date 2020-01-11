//
//  SectionCCollectionCell.m
//  QinWuTong
//
//  Created by ltl on 2018/11/23.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "SectionCCollectionCell.h"

@interface SectionCCollectionCell ()

@end

@implementation SectionCCollectionCell

- (void)viewDidLoad {
    //    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _topImg =[[UIImageView alloc] init];
        [self.contentView addSubview:_topImg];
        _name =[[UILabel alloc] init];
        [self.contentView addSubview:_name];
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

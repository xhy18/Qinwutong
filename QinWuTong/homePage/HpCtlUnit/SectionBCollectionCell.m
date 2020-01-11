//
//  SectionBCollectionCell.m
//  QinWuTong
//
//  Created by ltl on 2018/11/23.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "SectionBCollectionCell.h"

@interface SectionBCollectionCell ()

@end

@implementation SectionBCollectionCell

- (void)viewDidLoad {
    //    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _top = [[UILabel alloc] init];
        _top.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_top];
        _img = [[UIImageView alloc] init];
        [self.contentView addSubview:_img];
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor blackColor];
        _title.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_title];
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor blackColor];
        _subTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_subTitle];
        
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

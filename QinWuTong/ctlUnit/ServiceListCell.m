//
//  ServiceListCell.m
//  QinWuTong
//
//  Created by ltl on 2018/11/30.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "ServiceListCell.h"
#import "CDZStarsControl.h"
#import "Constants.h"

@interface ServiceListCell ()
@end

@implementation ServiceListCell

- (void)viewDidLoad {
    //    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        CGFloat photoWid = 0;
        
        _photo =[[UIImageView alloc] init];
        _photo.frame = CGRectMake(5, 5, photoWid, photoWid);
        _name =[[UILabel alloc] init];
        _name.frame = CGRectMake(photoWid+10, 5, 100, 20);
        //    _name.text = [name objectAtIndex:(long)indexPath.row];
        _name.font = [UIFont systemFontOfSize:22];
//        NSString *inStr = [NSString stringWithFormat: @" %ld%@", (long)arc4random()%12,@"km"];//随机数输入距离
        //    _distance.text = inStr;
        _distance =[[UILabel alloc] init];
        _distance.frame = CGRectMake(SCREEN_WIDTH-65, 5, 45, 20);
        _distance.backgroundColor = labelBgGreen;
        _distance.textColor = [UIColor whiteColor];
        _distance.font = [UIFont systemFontOfSize:14];
        _distance.textAlignment = NSTextAlignmentCenter;//居中显示
        _tel =[[UILabel alloc] init];
        _tel.textColor = [UIColor blueColor];
        //    _tel.text = [telNum objectAtIndex:(long)indexPath.row];
        _tel.frame = CGRectMake(photoWid+10, 30, SCREEN_WIDTH-photoWid, 16);
        _starsControl = [CDZStarsControl.alloc initWithFrame:CGRectMake(photoWid+10,  _tel.frame.origin.y+_tel.frame.size.height+3, 80, 12) stars:5 starSize:CGSizeMake(12, 12) noramlStarImage:[UIImage imageNamed:@"star_normal"] highlightedStarImage:[UIImage imageNamed:@"star_highlighted"]];
//        _starsControl.frame = CGRectMake(photoWid+10,  _tel.frame.origin.y+_tel.frame.size.height+3, 80, 12);
        _starsControl.userInteractionEnabled = NO;
        _starsControl.allowFraction = YES;
        _starsControl.score = 3.6f;//初始化分数
        _address =[[UILabel alloc] init];
        _address.frame= CGRectMake(10+photoWid, 65, SCREEN_WIDTH-photoWid, 15);
        _address.text = @"西安市太白南路2号西安电子科技大学";
        _address.font = [UIFont systemFontOfSize:12];
        _address.textColor = [UIColor grayColor];
        _services =[[UILabel alloc] init];
        _services.frame = CGRectMake(photoWid+10, 85, SCREEN_WIDTH-photoWid-15, 20);
        //    _services.text = [service objectAtIndex:(long)indexPath.row];
        _services.font = [UIFont systemFontOfSize:16];
        _services.textColor = [UIColor orangeColor];
        _line =[[UILabel alloc] init];
        _line.backgroundColor = [UIColor grayColor];
        _line.frame = CGRectMake(photoWid+12, 83, SCREEN_WIDTH-25-photoWid, 1);
        _bgLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
        _bgLabel =[[UILabel alloc] init];
        _bgLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgLabel];
        
        
        [self.contentView addSubview:_photo];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_tel];
        [self.contentView addSubview:_distance];
        [self.contentView addSubview:_address];
        [self.contentView addSubview:_services];
        [self.contentView addSubview:_line];
        [self.contentView addSubview:_starsControl];
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

//
//  ServiceSkillCell.m
//  QinWuTong
//
//  Created by ltl on 2018/12/13.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "ServiceSkillCell.h"
#import "Constants.h"
#import "MyUtils.h"

@interface ServiceSkillCell ()

@end

@implementation ServiceSkillCell

- (void)viewDidLoad {
//    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _skill =[[UILabel alloc] init];
        [self.contentView addSubview:_skill];
        _price =[[UILabel alloc] init];
        [self.contentView addSubview:_price];
        _unit =[[UILabel alloc] init];
        [self.contentView addSubview:_unit];
        _score =[[UILabel alloc] init];
        [self.contentView addSubview:_score];
        
        _sendOrder = [[UIButton alloc]init];
//        [_sendOrder addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sendOrder setTitle:@"预订" forState:UIControlStateNormal];
        [self.contentView addSubview:_sendOrder];
        
        _num =[[UILabel alloc] init];
        _num.text = @"0";
        _num.textColor = [UIColor blackColor];
        _num.layer.borderWidth=1;
        _num.textAlignment = NSTextAlignmentCenter;
        _num.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor blackColor]);
        _num.hidden = YES;
        [self.contentView addSubview:_num];
        _add = [[UIButton alloc]init];
        [_add setTitle:@"+" forState:UIControlStateNormal];
        _add.backgroundColor = themeColor;
        _add.layer.borderColor = (__bridge CGColorRef _Nullable)(themeColor);
        _add.layer.borderWidth = 1.0f;
        [_add addTarget:self action:@selector(addNum:) forControlEvents:UIControlEventTouchUpInside];
        _add.hidden = YES;
        [self.contentView addSubview:_add];
        _cut = [[UIButton alloc]init];
        [_cut setTitle:@"-" forState:UIControlStateNormal];
        _cut.backgroundColor = themeColor;
        _cut.layer.borderColor = (__bridge CGColorRef _Nullable)(themeColor);
        _cut.layer.borderWidth = 1.0f;
        [_cut addTarget:self action:@selector(cutNum:) forControlEvents:UIControlEventTouchUpInside];
        _cut.hidden = YES;
        //        _cut.layer.cornerRadius = 4.0f;
        [self.contentView addSubview:_cut];
        
        _remark = [[UITextField alloc]init];
        _remark.hidden = YES;
        _remark.borderStyle = UITextBorderStyleRoundedRect;
        [self.contentView addSubview:_remark];
        _remarkLbl = [[UILabel alloc]init];
        _remarkLbl.text = @"备注";
        _remarkLbl.hidden = YES;
        [self.contentView addSubview:_remarkLbl];
        
    }
    return self;
}
-(void)addNum:(UIButton *)btn{
//    NSLog(@"按键+1计数");
    NSString *str = _num.text;
    int num =[str intValue];
    _num.text = [NSString stringWithFormat:@"%d",++num];
}
-(void)cutNum:(UIButton *)btn{
    NSString *str = _num.text;
    int num =[str intValue];
    if(num <= 0){
        [MyUtils alertMsg:[NSString stringWithFormat:@"当前值为%d,不能再减少",num] method:@"cutNum" vc:nil];
//        NSLog(@"当前值为%d,不能再减少",num);
    }
    else
        _num.text = [NSString stringWithFormat:@"%d",--num];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
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

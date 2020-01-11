//
//  SubmitCommentVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/4.
//  Copyright © 2019 ltl. All rights reserved.
//

#import "SubmitCommentVC.h"
#import "OrderObj.h"
#import "SkillObj.h"
#import "CDZStarsControl.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface SubmitCommentVC ()<CDZStarsControlDelegate>
@property(strong, nonatomic) UILabel *scoreLbl;
@property(strong, nonatomic) OrderObj *order;
@property(strong, nonatomic) SkillObj *skill;
@property (nonatomic , strong)CDZStarsControl *starsControl;
@property(strong, nonatomic) UITextField *commentContent;
@end

@implementation SubmitCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评 价";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    // Do any additional setup after loading the view.
}

-(void)initFrameWithData:(OrderObj *)order skill:(SkillObj *)skill{
    _order = order;
    _skill = skill;
    int titleFontSize = 24;
    UILabel *servicerName = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-10, 24)];
    servicerName.text = order.servicerName;
    servicerName.font = [UIFont systemFontOfSize:titleFontSize];
    [self.view addSubview:servicerName];
    UILabel *skillName = [[UILabel alloc]initWithFrame:CGRectMake(5, servicerName.frame.origin.y+servicerName.frame.size.height+5, SCREEN_WIDTH-10, 24)];
    skillName.text = skill.lv3;
    skillName.font = [UIFont systemFontOfSize:titleFontSize];
    [self.view addSubview:skillName];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(5, skillName.frame.origin.y+skillName.frame.size.height+3, SCREEN_WIDTH, 1)];
    line1.backgroundColor = grayBgColor;
    [self.view addSubview:line1];
    
    UILabel *starsLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, line1.frame.origin.y+12, 135, 24)];
    starsLbl.text = @"请为服务评分:";
    [self.view addSubview:starsLbl];
    _starsControl = [CDZStarsControl.alloc initWithFrame:CGRectMake(starsLbl.frame.origin.x+starsLbl.frame.size.width+5,  line1.frame.origin.y+6, 170, 36) stars:5 starSize:CGSizeMake(32, 32) noramlStarImage:[UIImage imageNamed:@"star_normal"] highlightedStarImage:[UIImage imageNamed:@"star_highlighted"]];
    //        _starsControl.frame = CGRectMake(photoWid+10,  _tel.frame.origin.y+_tel.frame.size.height+3, 80, 12);
    _starsControl.userInteractionEnabled = YES;
//    _starsControl.allowFraction = YES;
    _starsControl.score = 0;//初始化分数
    _starsControl.delegate = self;
    [self.view addSubview:_starsControl];
    _scoreLbl = [[UILabel alloc]initWithFrame:CGRectMake(_starsControl.frame.origin.x+_starsControl.frame.size.width+15, line1.frame.origin.y+12, 40, 24)];
    _scoreLbl.textColor = [UIColor orangeColor];
//    scoreLbl.text = @"请为服务评分:";
    [self.view addSubview:_scoreLbl];
    
    
    UILabel *commentLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, _starsControl.frame.origin.y+_starsControl.frame.size.height+5, SCREEN_WIDTH-10, 24)];
    commentLbl.text = @"请填写服务评价:";
    [self.view addSubview:commentLbl];
    _commentContent = [[UITextField alloc]initWithFrame:CGRectMake(5, commentLbl.frame.origin.y+commentLbl.frame.size.height+5, SCREEN_WIDTH-10, 28*7)];//默认7行的高度
    _commentContent.backgroundColor = tfBgColor;
    _commentContent.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [self.view addSubview:_commentContent];
    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(10, _commentContent.frame.origin.y+_commentContent.frame.size.height+5, SCREEN_WIDTH-20, 40)];
    [submit setTitle:@"提  交" forState:UIControlStateNormal];
    submit.titleLabel.textColor = textColorOnBg;
    submit.titleLabel.font = [UIFont systemFontOfSize:28];
    submit.backgroundColor = themeColor;
    submit.layer.cornerRadius = 4;
    [submit addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
}
- (void)starsControl:(CDZStarsControl *)starsControl didChangeScore:(CGFloat)score{
    _scoreLbl.text = [NSString stringWithFormat:@"%.1f",score];
}
//在textfield中输入弹出键盘后，点击背景收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(void)submitClick{
    if([MyUtils isBlankString:_scoreLbl.text]){
        [MyUtils alertMsg:@"请为服务打分" method:@"submitClick" vc:self];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *content = self.commentContent.text;
        if([MyUtils isBlankString:content])
            content = @"";
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%@",_order.orderId],@"orderId",
                             [NSString stringWithFormat:@"%d",_skill.skillId],@"id",
                             content,@"comments",_scoreLbl.text,@"score",
                             nil];
        
        [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appGoods/comment", baseUrl] Dic:dic SuccessBlock:^(id responseObject){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 0){
                NSLog(@"评价提交成功jason:%@",responseObject);
//                [self.navigationController popToRootViewControllerAnimated:YES];
//                self.tabBarController.selectedIndex = 2;
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"评价提交失败：error:%@",error] method:@"submitClick" vc:self];
            }
        } FailureBlock:^(id error){
            //                NSLog(@"订单提交失败error:%@",error);
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误error:%@",error] method:@"submitClick" vc:self];
        }
         ];
    });
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

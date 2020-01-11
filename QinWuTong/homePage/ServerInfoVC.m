//
//  ServerInfoVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/17.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "ServerInfoVC.h"
#import "ScrollTableViewCell.h"
#import "Constants.h"
#import "ServiceSkillCell.h"

#import "SkillObj.h"

#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface ServerInfoVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic) UIScrollView *indexscrol;
@property(nonatomic,retain)NSMutableArray * imageName;
@property(nonatomic,retain)NSMutableArray * tag_array;

@property(strong, nonatomic) UILabel *nameLbl;
@property(strong, nonatomic) UILabel *distanceLbl;
@property(strong, nonatomic) UILabel *addressLbl;
@property(strong, nonatomic) UILabel *servicerContentLbl;
@property(strong, nonatomic) UILabel *orderCntLbl;
//@property(strong, nonatomic) UIImageView *photo;


@property(strong , nonatomic)UICollectionView *serverList;
@property(strong , nonatomic)UICollectionView *appraiseList;

@property (nonatomic) NSMutableArray *skills;

@property (strong, nonatomic) NSString *servicerId;
@property (strong, nonatomic) NSString *servicerName;
@end

@implementation ServerInfoVC

- (void)initFrames {
    CGFloat photoWid = 100;
    CGFloat topOffset = statusBarFrame.size.height+navigationHeight;
    UIColor *lineColor = grayBgColor;
    UIColor *bgColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
    
    CGFloat leftBlank = 10;
    CGFloat topBlank = 10;
    CGFloat splitHei = 8;
    int titleFontSize = 22;
    _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank, topBlank, SCREEN_WIDTH-40, 30)];
    //    _nameLbl.textColor = [UIColor blackColor];
    _nameLbl.text = @"121243213452";
    //    _nameLbl.text = _servicerName;
    _nameLbl.font = [UIFont systemFontOfSize:24];
    CGFloat gradeHeight = 25;
    UILabel *grade = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank, _nameLbl.frame.origin.y+_nameLbl.frame.size.height, 120, gradeHeight)];
    grade.text = @"%%%%%";
    grade.backgroundColor = [UIColor purpleColor];
    grade.font = [UIFont systemFontOfSize:20];
    
    
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, topBlank+30+gradeHeight+3, SCREEN_WIDTH-2*leftBlank-6, 1)];
    line1.backgroundColor = lineColor;
    CGFloat callBtnWid = 40;
    _addressLbl = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank, line1.frame.origin.y+1+3, SCREEN_WIDTH-2*leftBlank-callBtnWid, 18)];
    _addressLbl.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
    _distanceLbl = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank, line1.frame.origin.y+1+6+18, SCREEN_WIDTH-2*leftBlank-callBtnWid, 18)];
    _distanceLbl.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
    _addressLbl.text = @"asl;kdfjhgkljsdhfgk";
    _distanceLbl.text = @"dsfese";
    //--------------------------------
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-leftBlank-callBtnWid-4, topBlank+30+gradeHeight+9, 1, callBtnWid-6)];
    line2.backgroundColor = lineColor;
    UIButton * callBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-leftBlank-callBtnWid, line1.frame.origin.y+1+3, callBtnWid, callBtnWid)];
    [callBtn setImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
    callBtn.backgroundColor = [UIColor greenColor];
    UILabel *split1 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, callBtn.frame.origin.y+callBtn.frame.size.height+3, SCREEN_WIDTH, splitHei)];
    split1.backgroundColor = bgColor;
    //--------------------------------
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank, split1.frame.origin.y+splitHei+3, 200, 25)];
    title1.text = @"商户简介";
    title1.font = [UIFont systemFontOfSize:titleFontSize];
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, title1.frame.origin.y+title1.frame.size.height+3, SCREEN_WIDTH-2*leftBlank-6, 1)];
    line3.backgroundColor = lineColor;
    _servicerContentLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    _servicerContentLbl.numberOfLines = 0;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],};
    NSString *str = @"abcdefg你上课可是你的拿单方事故是的法规和的方式更好地方规划局法国红酒法国红酒到了";
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-2*leftBlank, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
    [_servicerContentLbl setFrame:CGRectMake(leftBlank, line3.frame.origin.y+4, textSize.width, textSize.height)];
    _servicerContentLbl.text = str;
    [_servicerContentLbl sizeToFit];
    UILabel *split2 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, _servicerContentLbl.frame.origin.y+_servicerContentLbl.frame.size.height+3, SCREEN_WIDTH-2*leftBlank-6, splitHei)];
    split2.backgroundColor = bgColor;
    //--------------------------------
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank, split2.frame.origin.y+splitHei+3, 200, 25)];
    title2.text = @"在线预订";
    title2.font = [UIFont systemFontOfSize:titleFontSize];
    UILabel *line4 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, title2.frame.origin.y+title2.frame.size.height+3, SCREEN_WIDTH-2*leftBlank-6, 1)];
    line4.backgroundColor = lineColor;
    _orderCntLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-leftBlank-200, split2.frame.origin.y+splitHei+3, 200, 25)];
    _orderCntLbl.text = @"完成xx单";
    _orderCntLbl.textColor = [UIColor greenColor];
    _orderCntLbl.font = [UIFont systemFontOfSize:titleFontSize-6];
    _orderCntLbl.textAlignment = NSTextAlignmentRight;


    UICollectionViewFlowLayout *layoutA = [[UICollectionViewFlowLayout alloc] init];
    layoutA.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    self.serverList = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layoutA];
//    self.serverList.frame = CGRectMake(0, line4.frame.origin.y-2, SCREEN_WIDTH,3*30+2*5);
    self.serverList.frame = CGRectMake(0, line4.frame.origin.y-2, SCREEN_WIDTH,[self.skills count]*30+([self.skills count]-1)*5);
    [self.view addSubview:self.serverList];
    self.serverList.backgroundColor = [UIColor whiteColor];
    [self.serverList registerClass:[ServiceSkillCell class] forCellWithReuseIdentifier:@"serviceCell"];
    [self.serverList registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    self.serverList.delegate = self;
    self.serverList.dataSource = self;
    UILabel *split3 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, self.serverList.frame.origin.y+self.serverList.frame.size.height-10, SCREEN_WIDTH-2*leftBlank-6, splitHei)];
    split3.backgroundColor = bgColor;
//    //--------------------------------
    
    
    //############################ScrollCView滚动条
    _indexscrol = [[UIScrollView alloc] init];
    
    _indexscrol.frame = CGRectMake(0,50, SCREEN_WIDTH, SCREEN_HEIGHT-topOffset-50);
    _indexscrol.contentSize = CGSizeMake(0, self.view.bounds.size.height-120);//设置内部的滚动大小，横向不能滚动，纵向长度是第三个section的底坐标
    _indexscrol.backgroundColor = [UIColor whiteColor];
    _indexscrol.showsVerticalScrollIndicator = NO;
    _indexscrol.showsHorizontalScrollIndicator = NO;
    _indexscrol.delegate = self;
    
    [self.indexscrol addSubview:_nameLbl];
    [self.indexscrol addSubview:_addressLbl];
    [self.indexscrol addSubview:_distanceLbl];
    [self.indexscrol addSubview:line1];
    [self.indexscrol addSubview:line2];
    [self.indexscrol addSubview:callBtn];
    [self.indexscrol addSubview:split1];

    [self.indexscrol addSubview:title1];//简介
    [self.indexscrol addSubview:line3];
    [self.indexscrol addSubview:_servicerContentLbl];
    [self.indexscrol addSubview:split2];

//    [self.indexscrol addSubview:_serverList];
    [self.indexscrol addSubview:title2];//在线预订
    [self.indexscrol addSubview:line4];
    [self.indexscrol addSubview:_orderCntLbl];
    [self.indexscrol addSubview:split3];
    
//        [self.indexscrol addSubview:_nameLbl];
//        [self.indexscrol addSubview:_nameLbl];
    
    
    [self.indexscrol addSubview:grade];
    
    [self.view addSubview:self.indexscrol];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.servicerId = @"100001";
    self.navigationItem.title = @"服务人员";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    
    [self getSkillByServicerId];
    // Do any additional setup after loading the view.
}
-(void)getSkillByServicerId{
    //    self.servicerId = servicerId;
    self.servicerId = @"100001";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@/qwt/server/Server/skill",baseUrl];
        NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.servicerId,@"userId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
            //            NSLog(@"\n\n\n\n:%@",responseObject);
            //            NSData *jsondata = [responseObject];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            dict = [dict objectForKey:@"data"];
            self.skills = @[].mutableCopy;
            int num =[[dict objectForKey:@"count"] intValue]/2;
            for(int i=1;i<=num;i++){
                SkillObj *so = [SkillObj new];
                NSString *tmp = [NSString stringWithFormat:@"skill%d",i];
                so.lv1 = [dict objectForKey:[NSString stringWithFormat:@"%@1",tmp]];
                so.lv2 = [dict objectForKey:[NSString stringWithFormat:@"%@2",tmp]];
                so.lv3 = [dict objectForKey:[NSString stringWithFormat:@"%@3",tmp]];
                so.price = [[dict objectForKey:[NSString stringWithFormat:@"price%d",i]] floatValue];
                so.unit = [dict objectForKey:[NSString stringWithFormat:@"unit%d",i]];
                [_skills addObject:so];
            }
            [self.serverList reloadData];
            
            [self initFrames];
        } FailureBlock:^(id error) {
            NSLog(@"\n\n\n【【ERROR in ServiceDetailVC.m】】\n%@\n\n",error);
        }];
    });
    //    [self initFrames];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.skills count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ServiceSkillCell *c =(ServiceSkillCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"serviceCell" forIndexPath:indexPath];
    CGFloat blank = 5;//距离两侧的边距
    c.skill.frame = CGRectMake(blank, 5, 400, 28);
    c.skill.font = [UIFont systemFontOfSize:24];
    c.sendOrder.frame = CGRectMake(SCREEN_WIDTH-2*blank-60-10, 5, 60, 28);
    c.price.frame = CGRectMake(c.sendOrder.frame.origin.x-210, 7, 200, 24);
    //    [c.sendOrder setTitle:@"登陆" forState:UIControlStateNormal];
    c.sendOrder.backgroundColor = themeColor;
    c.skill.text = @"skill";
    c.skill.textColor = [UIColor blueColor];
    c.price.text = @"price";
    c.price.textAlignment = NSTextAlignmentRight;
    c.price.textColor = [UIColor colorWithRed:30/255.0 green:128/255.0 blue:184/255.0 alpha:1.0];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, c.sendOrder.frame.origin.y+c.sendOrder.frame.size.height+2, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = grayBgColor;
    [c.contentView addSubview:line];
    return c;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH-20, 30);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
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

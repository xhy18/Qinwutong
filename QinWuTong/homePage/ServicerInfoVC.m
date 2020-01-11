//
//  ServicerInfoVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/13.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "ServicerInfoVC.h"
#import "ServiceSkillCell.h"
#import "CommentsCell.h"
#import "SubmitOrderVC.h"
#import "CDZStarsControl.h"
#import "SkillObj.h"
#import "CommentsObj.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface ServicerInfoVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic) UIScrollView *indexscrol;
@property(nonatomic,retain)NSMutableArray * imageName;
@property(nonatomic,retain)NSMutableArray * tag_array;

@property(strong, nonatomic) UILabel *nameLbl;
@property(strong, nonatomic) UILabel *distanceLbl;
@property(strong, nonatomic) NSString *homeFeeNum;
@property(strong, nonatomic) UILabel *homeFee;
@property(strong, nonatomic) UILabel *addressLbl;
@property(strong, nonatomic) UILabel *introductionLbl;
@property(strong, nonatomic) UILabel *orderCntLbl;
@property(strong, nonatomic) UIButton *toOrderPage;
@property(strong, nonatomic) UIImageView *photo;

@property(strong, nonatomic) NSString *serverTel;
@property(strong, nonatomic) NSString *score;
@property(nonatomic) long *scoreLong;
@property(strong, nonatomic) NSString *introduction;
@property (nonatomic , strong)CDZStarsControl *starsControl;
//@property(strong, nonatomic) UILabel *orderCntLbl;

@property(strong , nonatomic)UICollectionView *serverList;
@property(strong , nonatomic)UICollectionView *commentsList;

@property(nonatomic) NSMutableArray *skills;
@property(nonatomic) NSMutableArray *comments;
@property(nonatomic) BOOL *hadInitCtl;
@property(nonatomic) BOOL *hadGetServerData;
//@property(nonatomic) BOOL *gettingServerData;
@property(nonatomic) NSMutableArray *commentsCellHeight;
//@property(nonatomic) NSArray *title2;


@property (strong, nonatomic) NSString *servicerId;
@property (strong, nonatomic) NSString *servicerName;

@property (nonatomic) double lat;
@property (nonatomic) double lon;

@end
#define photoWid 30;
#define appraiseLblWid    [[UIScreen mainScreen] bounds].size.width - 65;
@implementation ServicerInfoVC

- (void)initFrames {
//    CGFloat photoWid = 100;
//    CGFloat topOffset = 0;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGFloat topOffset = statusBarFrame.size.height+navigationHeight;
    UIColor *lineColor = grayBgColor;
    UIColor *bgColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    
    CGFloat leftBlank = 10;
    CGFloat topBlank = 0;
    CGFloat splitHei = 8;
    int titleFontSize = 22;
    if(!_hadInitCtl)
        [self initCtl];
    _nameLbl.frame = CGRectMake(leftBlank, topBlank, SCREEN_WIDTH-40, 30);
    //    _nameLbl.textColor = [UIColor blackColor];
//    _nameLbl.text = @"121243213452";
    //    _nameLbl.text = _servicerName;
    _nameLbl.font = [UIFont systemFontOfSize:24];
    _homeFee.frame = CGRectMake(SCREEN_WIDTH-200, topBlank+12, 190, 30);
    _homeFee.textAlignment = NSTextAlignmentRight;
    _homeFee.textColor = themeColor;
    _homeFee.font = [UIFont systemFontOfSize:20];
    CGFloat starsHei = 18;
    _starsControl = [CDZStarsControl.alloc initWithFrame:CGRectMake(leftBlank, _nameLbl.frame.origin.y+_nameLbl.frame.size.height, 80, starsHei) stars:5 starSize:CGSizeMake(15, 15) noramlStarImage:[UIImage imageNamed:@"star_normal"] highlightedStarImage:[UIImage imageNamed:@"star_highlighted"]];
    //        _starsControl.frame = CGRectMake(photoWid+10,  _tel.frame.origin.y+_tel.frame.size.height+3, 80, 12);
    _starsControl.userInteractionEnabled = NO;
    _starsControl.allowFraction = YES;
    _starsControl.score = [_score floatValue];
//    NSLog(@"%@",_score);
//    [self reflashStarsControl];
//    _starsControl.score = 2;//初始化分数
    
    
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, topBlank+30+starsHei+3, SCREEN_WIDTH-2*leftBlank-6, 1)];
    line1.backgroundColor = lineColor;
    CGFloat callBtnWid = 40;
    _addressLbl.frame = CGRectMake(leftBlank, line1.frame.origin.y+1+3, SCREEN_WIDTH-2*leftBlank-callBtnWid, 18);
    _addressLbl.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
    [self getAddressByLat:_lat lon:_lon];
    _distanceLbl.frame = CGRectMake(leftBlank, line1.frame.origin.y+1+6+18, SCREEN_WIDTH-2*leftBlank-callBtnWid, 18);
    _distanceLbl.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
//    _addressLbl.text = @"asl;kdfjhgkljsdhfgk";
//    _distanceLbl.text = @"dsfese";
    //--------------------------------
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-leftBlank-callBtnWid-4, topBlank+30+starsHei+9, 1, callBtnWid-6)];
    line2.backgroundColor = lineColor;
    UIButton * callBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-leftBlank-callBtnWid, line1.frame.origin.y+1+3, callBtnWid, callBtnWid)];
    [callBtn setImage:[UIImage imageNamed:@"icon_phone.png"] forState:UIControlStateNormal];
//    callBtn.backgroundColor = [UIColor greenColor];
//    callBtn.titleLabel.text = @"13012345678";
    [callBtn addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    UILabel *split1 = [[UILabel alloc]initWithFrame:CGRectMake(0, callBtn.frame.origin.y+callBtn.frame.size.height+3, SCREEN_WIDTH, splitHei)];
    split1.backgroundColor = bgColor;
    //--------------------------------
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank, split1.frame.origin.y+splitHei+3, 200, 25)];
    title1.text = @"商户简介";
    title1.font = [UIFont systemFontOfSize:titleFontSize];
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, title1.frame.origin.y+title1.frame.size.height+3, SCREEN_WIDTH-2*leftBlank-6, 1)];
    line3.backgroundColor = lineColor;
    _introductionLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    _introductionLbl.numberOfLines = 0;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],};
//    NSString *str = @"abcdefg你上课可是你的拿单方事故是的法规和的方式更好地方规划局法国红酒法国红酒到了";
    CGSize textSize = [_introduction boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-2*leftBlank, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//    if(textSize.height <=10){
//        NSLog(@"servicerInfoVC:initFrame textSize<10");
//    }
    [_introductionLbl setFrame:CGRectMake(leftBlank, line3.frame.origin.y+4, textSize.width, textSize.height)];
    _introductionLbl.text = _introduction;
    [_introductionLbl sizeToFit];
    
    UILabel *split2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _introductionLbl.frame.origin.y+_introductionLbl.frame.size.height+3, SCREEN_WIDTH, splitHei)];
    split2.backgroundColor = bgColor;
    //--------------------------------
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank, split2.frame.origin.y+splitHei+3, 200, 25)];
    title2.text = @"在线预订";
    title2.font = [UIFont systemFontOfSize:titleFontSize];
    UILabel *line4 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, title2.frame.origin.y+title2.frame.size.height+3, SCREEN_WIDTH-2*leftBlank-6, 1)];
    line4.backgroundColor = lineColor;
    _toOrderPage = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-leftBlank-30, split2.frame.origin.y+splitHei+3, 30, 25)];
//    [_toOrderPage setTitle:@">" forState:UIControlStateNormal];
    [_toOrderPage setImage:[UIImage imageNamed:@"icon_right1.png"] forState:UIControlStateNormal];
    [_toOrderPage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_toOrderPage addTarget:self action:@selector(orderPage) forControlEvents:UIControlEventTouchUpInside];
//    _order.backgroundColor = [UIColor purpleColor];
//    _order.titleLabel.textColor = [UIColor blackColor];
    _orderCntLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-leftBlank-200, split2.frame.origin.y+splitHei+3, 200, 25)];
    _orderCntLbl.text = @"完成xx单";
    _orderCntLbl.textColor = [UIColor greenColor];
    _orderCntLbl.font = [UIFont systemFontOfSize:titleFontSize-6];
    _orderCntLbl.textAlignment = NSTextAlignmentRight;
    
    
    UICollectionViewFlowLayout *layoutA = [[UICollectionViewFlowLayout alloc] init];
    layoutA.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    
    _serverList = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layoutA];
//    _serverList.frame = CGRectMake(0, line4.frame.origin.y-2, SCREEN_WIDTH,3*40+2*5);
    _serverList.frame = CGRectMake(0, line4.frame.origin.y-8, SCREEN_WIDTH,[_skills count]*30+([_skills count]-1)*5+25);//+40是为了撑够高度不允许滚动
    [self.view addSubview:_serverList];
    _serverList.backgroundColor = [UIColor whiteColor];
    [_serverList registerClass:[ServiceSkillCell class] forCellWithReuseIdentifier:@"serviceCell"];
    [_serverList registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    _serverList.tag = 0;
    _serverList.delegate = self;
    _serverList.dataSource = self;
    UILabel *split3 = [[UILabel alloc]initWithFrame:CGRectMake(0, _serverList.frame.origin.y+_serverList.frame.size.height-5, SCREEN_WIDTH, splitHei)];
    split3.backgroundColor = bgColor;
    //--------------------------------
    
    
    //--------------------------------
    UILabel *title3 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank, split3.frame.origin.y+splitHei+3, 200, 25)];
    title3.text = @"用户评论";
    title3.font = [UIFont systemFontOfSize:titleFontSize];
    UILabel *line5 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, title3.frame.origin.y+title3.frame.size.height+3, SCREEN_WIDTH-2*leftBlank-6, 1)];
    line5.backgroundColor = lineColor;
    
    UICollectionViewFlowLayout *layoutB = [[UICollectionViewFlowLayout alloc] init];
    layoutB.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    _commentsList = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layoutB];
    //    _serverList.frame = CGRectMake(0, line4.frame.origin.y-2, SCREEN_WIDTH,3*40+2*5);
    CGFloat commentsCellHeightSum = 0;
    for(int i=0;i<[self.commentsCellHeight count];i++){
        commentsCellHeightSum += [[self.commentsCellHeight objectAtIndex:i] floatValue];
    }

    _commentsList.frame = CGRectMake(0, line5.frame.origin.y-8, SCREEN_WIDTH,commentsCellHeightSum+20+[_commentsCellHeight count]*(5+8));//+20是为了撑够高度不允许滚动;(5+8)中的5是cell间距，8是设置每个cell高度时加的常量
    [self.view addSubview:_commentsList];
    _commentsList.backgroundColor = [UIColor whiteColor];
    [_commentsList registerClass:[CommentsCell class] forCellWithReuseIdentifier:@"appraiseCell"];
    [_commentsList registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    _commentsList.tag = 1;
    _commentsList.delegate = self;
    _commentsList.dataSource = self;
    CGFloat originNoComments = _commentsList.frame.origin.y+_commentsList.frame.size.height-5;
    if(commentsCellHeightSum == 0)
        originNoComments =_commentsList.frame.origin.y + 5;
    UILabel *noComments = [[UILabel alloc]initWithFrame:CGRectMake(20, originNoComments, SCREEN_WIDTH-40, 30)];
    noComments.text = @"没有更多评论了";
    noComments.textAlignment = NSTextAlignmentCenter;
    noComments.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    UILabel *split4 = [[UILabel alloc]initWithFrame:CGRectMake(0, noComments.frame.origin.y+noComments.frame.size.height-5, SCREEN_WIDTH, splitHei)];
    split4.backgroundColor = bgColor;
    
    
    //############################ScrollCView滚动条
    _indexscrol = [[UIScrollView alloc] init];
    
    _indexscrol.frame = CGRectMake(0,topOffset, SCREEN_WIDTH, SCREEN_HEIGHT-topOffset);
//    _indexscrol.contentSize = CGSizeMake(0, line5.frame.origin.y+[_skills count]*120+([_skills count]-1)*5+25);//设置内部的滚动大小，横向不能滚动，纵向长度是第三个section的底坐标
    _indexscrol.contentSize = CGSizeMake(0, split4.frame.origin.y+split4.frame.size.height);//设置内部的滚动大小，横向不能滚动，纵向长度是第三个section的底坐标
    _indexscrol.backgroundColor = [UIColor whiteColor];
    _indexscrol.showsVerticalScrollIndicator = NO;
    _indexscrol.showsHorizontalScrollIndicator = NO;
    _indexscrol.delegate = self;
    
    [self.indexscrol addSubview:_nameLbl];
    [self.indexscrol addSubview:_homeFee];
    [self.indexscrol addSubview:_starsControl];
    [self.indexscrol addSubview:_addressLbl];
    [self.indexscrol addSubview:_distanceLbl];
    [self.indexscrol addSubview:line1];
    [self.indexscrol addSubview:line2];
    [self.indexscrol addSubview:callBtn];
    [self.indexscrol addSubview:split1];
    
    [self.indexscrol addSubview:title1];//简介
    [self.indexscrol addSubview:line3];
    [self.indexscrol addSubview:_introductionLbl];
    [self.indexscrol addSubview:split2];
    
    [self.indexscrol addSubview:_serverList];
    [self.indexscrol addSubview:title2];//在线预订
    [self.indexscrol addSubview:line4];
    [self.indexscrol addSubview:_toOrderPage];
    [self.indexscrol addSubview:split3];
    
    
    [self.indexscrol addSubview:_commentsList];
    [self.indexscrol addSubview:title3];//用户评论
    [self.indexscrol addSubview:line5];
    [self.indexscrol addSubview:noComments];
    [self.indexscrol addSubview:split4];
    //    [self.indexscrol addSubview:_nameLbl];
    //    [self.indexscrol addSubview:_nameLbl];
    
    
//    [self.indexscrol addSubview:grade];
    
    [self.view addSubview:self.indexscrol];
    if(_nameLbl.text)
        NSLog(_nameLbl.text);
    if(_nameLbl.text.length==0){
//        NSLog(@"你好好看看数据是不是没出来！");
//        if(!_gettingServerData){
//            [self getSkillByServicerId];
////            NSLog(@"好好好我再去拿。。。");
//        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.servicerId = @"100001";
    self.navigationItem.title = @"服务人员";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
//    [self initFrames];
//    _gettingServerData = false;
//    _hadGetServerData = false;
    [self getSkillByServicerId];
    self.commentsCellHeight = @[].mutableCopy;
//    [self initFrames];
    // Do any additional setup after loading the view.
}


-(void)getAddressByLat:(double)lat lon:(double)lon{
    if(lat == 0||lon == 0){
        _addressLbl.text = @"(未获取到服务人员位置信息)";
        return;
    }
    CLLocation *location = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    NSLog(@"%f,%f",location.coordinate.latitude,location.coordinate.longitude);
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *addressToShow = placeMark.locality;
            if (!addressToShow)
                addressToShow = @"无法定位当前城市";
            else
                addressToShow = placeMark.name;
            _addressLbl.text = addressToShow;
        }
    }];
}

-(void)getSkillByServicerId{
    if(!_servicerId ){
        [MyUtils alertMsg:@"获取服务人员id异常" method:@"getSkillByServicerId" vc:self];
        return;
    }
    if(!_hadInitCtl)
        [self initCtl];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        _gettingServerData = true;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@/qwt/server/Server/showServer",baseUrl];
        NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.servicerId,@"serverId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
            //            NSLog(@"\n\n\n\n:%@",responseObject);
            //            NSData *jsondata = [responseObject];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//            NSLog(jsonData);
//            dict = [dict objectForKey:@"data"];
            int res = [[dict objectForKey:@"code"]integerValue];
            if(res == 1){
                //success body
                NSArray *rowsArr = dict[@"data"];
                if([rowsArr count]==0){
                    [MyUtils alertMsg:@"data数组为空，请重试" method:@"getSkillByServicerId" vc:self];
                    return;
                }
                dict = [rowsArr objectAtIndex:0];
                self.skills = @[].mutableCopy;
                //            int num =[[dict objectForKey:@"count"] intValue]/2;
                for(int i=1;i<=5;i++){
                    SkillObj *so = [SkillObj new];
                    NSString *tmp = [NSString stringWithFormat:@"skill%d",i];
                    so.lv1 = nil;
                    so.lv2 = nil;
                    so.lv3 = [dict objectForKey:[NSString stringWithFormat:@"%@3",tmp]];
                    so.price = [[dict objectForKey:[NSString stringWithFormat:@"price%d",i]] floatValue];
//                    NSLog(@"%@",[dict objectForKey:[NSString stringWithFormat:@"price%d",i]]);
//                    NSLog(@"%.2f",[[dict objectForKey:[NSString stringWithFormat:@"price%d",i]] floatValue]);
                    so.unit = [dict objectForKey:[NSString stringWithFormat:@"unit%d",i]];
                    if([so.unit isKindOfClass:[NSNull class]])
                        so.unit = @"";
//                    so.price = 0;
                    if ([so.lv3 isKindOfClass:[NSNull class]])
                        continue;
                    [_skills addObject:so];
                }
                _introduction = [dict objectForKey:@"introduction"];
                if([_introduction isKindOfClass:[NSNull class]])
                    _introduction = @"（暂未填写相关信息）";
                _nameLbl.text = [dict objectForKey:@"realname"];
                _serverTel = [dict objectForKey:@"phoneNum"];
                _homeFeeNum = [dict objectForKey:@"homeFee"];
                _homeFee.text = [NSString stringWithFormat:@"上门费:￥%.2f",[_homeFeeNum floatValue]];
                _score = [dict objectForKey:@"avgScore"];
                _photo.image = [UIImage imageNamed:@"checked.png"];
                _starsControl.score = [_score floatValue];
                [self.serverList reloadData];
                [self getCommentsByServicerId];//原本想在viewDidLoad中同时开启两个请求的线程，但是在大约15%的概率下，竟然会将请求评论的response返回给请求技能的线程，一脸懵逼，于是在一个解析完后再开启另一个，与刷新信息并行执行。
                //            _hadGetServerData = true;
                [self initFrames];
            }
            else{
                NSString *error = [dict objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取服务人员详细信息失败：error:%@",error] method:@"getSkillByServicerId" vc:self];
            }
//            _gettingServerData = false;
        } FailureBlock:^(id error) {
            [MyUtils alertMsg:@"请求错误" method:@"getSkillByServicerId" vc:self];
//            _gettingServerData = false;
        }];
    });
}
- (float)calcLblHei:(int)fontSize str:(NSString *)str labelWid:(CGFloat)labelWid{
    if(str.length == 0)
        str = @" ";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],};
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(labelWid, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    t.numberOfLines = 0;
    [t setFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    t.text = str;
    [t sizeToFit];
//    NSLog(@"\nservicerInfoVC： 判断lbl高度：\n输入：%@，输出：%f",str,t.frame.size.height);
    return t.frame.size.height;
}

- (void)calcCommentsCellHei:(CommentsObj *)co {
    CGFloat contentWid = appraiseLblWid;
    CGFloat contentHeight;
    NSDictionary * attributes;
    CGSize textSize;
//    [self calcLblHei:16 str:co.comments labelWid:contentWid];
    contentHeight = [self calcLblHei:16 str:co.comments labelWid:contentWid]+40;
    if(co.addComments && ![co.addComments isKindOfClass:[NSNull class]])
        contentHeight += [self calcLblHei:16 str:co.addComments labelWid:contentWid];
    if(co.reply && ![co.reply isKindOfClass:[NSNull class]])
        contentHeight += [self calcLblHei:16 str:co.reply labelWid:contentWid];
    
    [self.commentsCellHeight addObject:[NSNumber numberWithFloat:contentHeight]];
}

-(void)getCommentsByServicerId{
    if(!_servicerId ){
        [MyUtils alertMsg:@"获取服务人员id失败，无法获取评论数据" method:@"getCommentsByServicerId" vc:self];
        return;
    }
    
    if(!_hadInitCtl)
        [self initCtl];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@/qwt/server/Server/showServerComments",baseUrl];
        NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.servicerId,@"serverId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
            //            NSLog(@"\n\n\n\n:%@",responseObject);
            //            NSData *jsondata = [responseObject];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //            NSLog(jsonData);
            //            dict = [dict objectForKey:@"data"];
            NSArray *rowsArr = dict[@"data"];
//            dict = [rowsArr objectAtIndex:0];
            self.comments = @[].mutableCopy;
            for(NSDictionary *dict in rowsArr){
                //            dict = [rowsArr objectAtIndex:0];
                //            int num =[[dict objectForKey:@"count"] intValue]/2;
                CommentsObj *co  = [CommentsObj new];
                co.comments = [dict objectForKey:@"comments"];
                if(!co.comments)
                    continue;
                if ([co.comments isKindOfClass:[NSNull class]])
                    continue;
                co.userName = [dict objectForKey:@"userName"];
                co.serviceContent = [dict objectForKey:@"content"];
//                co.reply = [NSString stringWithFormat:@"回复：%@",[dict objectForKey:@"reply"]];
//                co.addComments = [NSString stringWithFormat:@"追评：%@",[dict objectForKey:@"addComments"]];
                co.reply = [dict objectForKey:@"reply"];
                co.addComments = [dict objectForKey:@"addComments"];
                if(co.addComments && ![co.addComments isKindOfClass:[NSNull class]])
                    co.addComments = [NSString stringWithFormat:@"追评：%@",co.addComments];
                
                if(co.reply && ![co.reply isKindOfClass:[NSNull class]])
                    co.reply = [NSString stringWithFormat:@"回复：%@",co.reply];
                
//                co.reply = [NSString stringWithFormat:@"回复：",[dict objectForKey:@"reply"]];
//                co.addComments = [NSString stringWithFormat:@"追评：",[dict objectForKey:@"addComments"]];
                co.date = [dict objectForKey:@"date"];
                co.score = [dict objectForKey:@"score"];
                co.commentId = [dict objectForKey:@"id"];
                
                //计算评论的总高度
                [self calcCommentsCellHei:co];
                [_comments addObject:co];
            }
            [self.serverList reloadData];
            if([_comments count]>0)
                [self initFrames];
        } FailureBlock:^(id error) {
            [MyUtils alertMsg:@"获取评论数据失败" method:@"getCommentsByServicerId" vc:self];
            //这里没有健壮性处理
        }];
    });
}
-(void)initCtl{
    if(_hadInitCtl)
        return;
    _hadInitCtl = true;
    _photo = [[UIImageView alloc]init];
    _nameLbl = [[UILabel alloc]init];
    _distanceLbl = [[UILabel alloc]init];
//    _tel = [[UILabel alloc]init];
    _addressLbl = [[UILabel alloc]init];
    _homeFee = [[UILabel alloc]init];
}
//-(void)setServicerName:(NSString *)name setTel:(NSString *)tel setAddress:(NSString *)address
//                setDis:(NSString *)distance setPhoto:(UIImage *)photo{
//    if(!_hadInitCtl)
//        [self initCtl];
//    //    NSLog(@"ServiceDetail:setServicerName:::%@",name);
//    _nameLbl.text = name;
//    _distanceLbl.text = distance;
//    _serverTel = [NSString stringWithFormat: @"联系电话：%@", tel];
//    _addressLbl.text = address;
////    _photo.image = photo;
//}
-(void)setServicerId:(NSString *)servicerId setLat:(double)lat setLon:(double)lon{
    _servicerId = servicerId;
    _lat = lat;
    _lon = lon;
}

-(void)orderPage{
    if(_nameLbl.text.length == 0 || [_nameLbl.text isKindOfClass:NSNull.class] || !_nameLbl){
        [MyUtils alertMsg:@"数据异常请重试" method:@"orderPage" vc:self];
    }
    SubmitOrderVC *so = [[SubmitOrderVC alloc]init];
    [so setServicerName:_nameLbl.text setTel:_serverTel setAddress:@"西安市" setPhoto:_photo.image setSkills:_skills setServicerId:self.servicerId  setHomeFee:_homeFeeNum];
    [self.navigationController pushViewController:so animated:NO];
//    SubmitOrderTmp *so = [[SubmitOrderTmp alloc]init];
//    [so setServicerName:_nameLbl.text setTel:_serverTel setAddress:@"西安市" setDis:@"123" setSkills:_skills setServicerId:self.servicerId];
//    [self.navigationController pushViewController:so animated:NO];
}
-(void)makeCall{
        NSString *str= [NSString stringWithFormat:@"tel:%@",self.serverTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",btn.titleLabel.text];
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [self.view addSubview:callWebview];
//    [callWebview release];
//    [str release];
}
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 0)
        return [_skills count];
    else
        return [_comments count];//评论数量
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag == 0){
        ServiceSkillCell *c =(ServiceSkillCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"serviceCell" forIndexPath:indexPath];
        if([_skills count]==0){
            [MyUtils alertMsg:@"服务数据为空" method:@"设置collectionCell" vc:self];
            [self getSkillByServicerId];
            NSLog(@"ServicerIngoVC:尝试重新获取数据");
            return c;
        }
        
        SkillObj *so = self.skills[indexPath.row];
        CGFloat blank = 5;//距离两侧的边距
        c.skill.frame = CGRectMake(blank, 5, 400, 28);
        c.skill.font = [UIFont systemFontOfSize:20];
        CGFloat scoreLbl = 0;
        c.score.frame = CGRectMake(SCREEN_WIDTH-scoreLbl-20, 7, scoreLbl, 24);
//        c.score.textColor = themeColor;
//        c.score.text = @"3.2分";
        c.price.frame = CGRectMake(c.score.frame.origin.x-155, 7, 150, 24);
        c.skill.text = [NSString stringWithFormat:@"%@", so.lv3];
        c.price.text = [NSString stringWithFormat:@"￥%.2f/%@", so.price, so.unit];
        c.price.font = [UIFont systemFontOfSize:18];
        c.price.textAlignment = NSTextAlignmentRight;
        c.price.textColor = [UIColor colorWithRed:30/255.0 green:128/255.0 blue:184/255.0 alpha:1.0];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, c.skill.frame.origin.y+c.skill.frame.size.height+2, SCREEN_WIDTH-20, 1)];
        line.backgroundColor = grayBgColor;
        [c.contentView addSubview:line];
        return c;
    }
    else{
        CommentsCell *c =(CommentsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"appraiseCell" forIndexPath:indexPath];
        if([_comments count]==0)
            return c;
        CGFloat blank = 5;//距离两侧的边距
//        CGFloat photoWid = 30;
        CGFloat pw = photoWid;
        CommentsObj *co = [_comments objectAtIndex:indexPath.row];
        if(!co.comments && ![co.comments isKindOfClass:[NSNull class]])
            return c;
        c.photo.frame = CGRectMake(blank, 5, pw, pw);
        c.photo.image = [UIImage imageNamed:@"default.png"];
        c.photo.backgroundColor = [UIColor purpleColor];
        c.name.frame = CGRectMake(2*blank+pw, 5, 400, 16);
        c.name.font = [UIFont systemFontOfSize:16];
        c.name.text = co.userName;
        c.grade.frame = CGRectMake(2*blank+pw, c.name.frame.origin.y+c.name.frame.size.height+2, 40, 14);
        c.grade.backgroundColor = [UIColor greenColor];
//        c.grade.text = co.score;
        c.price.frame = CGRectMake(c.grade.frame.origin.x+c.grade.frame.size.width+5, c.name.frame.origin.y+c.name.frame.size.height, 200, 14);
        c.price.text = @"price";//写死的
        c.price.textAlignment = NSTextAlignmentRight;
        c.price.textColor = [UIColor colorWithRed:30/255.0 green:128/255.0 blue:184/255.0 alpha:1.0];
        
        CGFloat contentWid = appraiseLblWid;
////        c.content.frame = CGRectMake(2*blank+photoWid, c.grade.frame.origin.y+c.grade.frame.size.height+3,contentWid,20);
//        NSString *str = co.comments;
//        CGSize contentSize  =[CommentsCell theStr:str theFont:c.content.font];
//        CGFloat contentHeight =((int)(contentSize.width/contentWid)+1)*contentSize.height;
//        c.content.frame = CGRectMake(2*blank+pw, c.grade.frame.origin.y+c.grade.frame.size.height+3,SCREEN_WIDTH-25-2*blank-pw, contentHeight);
////        NSLog(@"servicerInfoVC:\n【print:c.content.frame.origin.y】:%f",c.content.frame.origin.y);
//        c.content.text = str;
//        c.content.font = [UIFont systemFontOfSize:16];
        
        c.content.text = co.comments;
        c.content.frame = CGRectMake(2*blank+pw, c.grade.frame.origin.y+c.grade.frame.size.height+3, contentWid, [self calcLblHei:16 str:co.comments labelWid:contentWid]);
        c.content.font = [UIFont systemFontOfSize:16];
        
        if(co.addComments && ![co.addComments isKindOfClass:[NSNull class]]){
            c.appendContent.text = co.addComments;
            c.appendContent.frame = CGRectMake(2*blank+pw, c.content.frame.origin.y+c.content.frame.size.height+5, contentWid, [self calcLblHei:16 str:co.addComments labelWid:contentWid]);
            c.appendContent.font = [UIFont systemFontOfSize:16];
        }
        else
            c.appendContent.frame = CGRectMake(2*blank+pw, c.content.frame.origin.y+c.content.frame.size.height+5, contentWid, 0);
        if(co.reply && ![co.reply isKindOfClass:[NSNull class]]){
            c.replyContent.text = co.reply;
            c.replyContent.frame = CGRectMake(2*blank+pw, c.appendContent.frame.origin.y+c.appendContent.frame.size.height+5, contentWid, [self calcLblHei:16 str:co.reply labelWid:contentWid]);
            c.replyContent.font = [UIFont systemFontOfSize:16];
        }
        else
            c.replyContent.frame = CGRectMake(2*blank+pw, c.appendContent.frame.origin.y+c.appendContent.frame.size.height+5, contentWid, 0);
        
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, c.replyContent.frame.origin.y+c.replyContent.frame.size.height+3, SCREEN_WIDTH-2*blank, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        [c.contentView addSubview:line];
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],};
//        NSString *str = @"abcdefg你上课可是你的拿单方事故是的法规和的方式更好地方规划局法国红酒法国红酒到了";
//        CGSize theLblSize  =[appraiseCell theStr:str theFont:c.content.font];
//        CGSize textSize = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-2*blank-photoWid, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//        c.content.textColor =[UIColor blackColor];
//        c.content.backgroundColor = [UIColor blueColor];
//        c.content.frame =CGRectMake(2*blank+photoWid, c.grade.frame.origin.y+c.grade.frame.size.height+3, theLblSize.width, theLblSize.height);
////        [c.content setFrame:CGRectMake(2*blank+photoWid, c.grade.frame.origin.y+c.grade.frame.size.height+3, theLblSize.width, theLblSize.height)];
//        c.content.text = str;
//        [c.content sizeToFit];
//        c.content.frame = CGRectMake(2*blank+photoWid, c.grade.frame.origin.y+c.grade.frame.size.height+3, SCREEN_WIDTH, 60);
//        c.content = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
//        c.content.numberOfLines = 0;
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],};
//        NSString *str = @"abcdefg你上课可是你的拿单方事故是的法规和的方式更好地方规划局法国红酒法国红酒到了";
//        CGSize textSize = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-2*blank-photoWid, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//        [c.content setFrame:CGRectMake(2*blank+photoWid, c.grade.frame.origin.y+c.grade.frame.size.height+3, textSize.width, textSize.height)];
//        c.content.text = str;
//        [c.content sizeToFit];
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, c.sendOrder.frame.origin.y+c.sendOrder.frame.size.height+2, SCREEN_WIDTH-20, 1)];
//        line.backgroundColor = grayBgColor;
//        [c.contentView addSubview:line];
        return c;
    }
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag ==0)
        return CGSizeMake(SCREEN_WIDTH-20, 30);
    else{
        CGFloat height = [[self.commentsCellHeight objectAtIndex:indexPath.row] floatValue]+8;
        NSLog(@"\nServicerInfoVC:设置cell高度为:%.2f",height);
        return CGSizeMake(SCREEN_WIDTH-20, height);
    }
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


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
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

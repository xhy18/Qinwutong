//
//  SubmitOrderVC.m
//  QinWuTong
//
//  Created by ltl on 2018/12/20.
//  Copyright © 2018 ltl. All rights reserved.
//

#import "SubmitOrderVC.h"
#import "ServiceSkillCell.h"
#import "SkillObj.h"
#import "UserAddressInfoObj.h"
#import "PayOrderVC.h"
#import "AddressManagerVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface SubmitOrderVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property(strong, nonatomic) UIScrollView *indexscrol;
@property(nonatomic,retain)NSMutableArray * imageName;
@property(nonatomic,retain)NSMutableArray * tag_array;

@property(strong, nonatomic) UILabel *nameLbl;
@property(strong, nonatomic) UILabel *addressLbl;
@property(strong, nonatomic) UILabel *homeFee;
@property(strong, nonatomic) NSString *homeFeeNum;
@property(strong, nonatomic) UILabel *workAddressContent;
@property(strong, nonatomic) UILabel *workTelLbl;
@property(strong, nonatomic) UILabel *workUserNameLbl;
@property(strong, nonatomic) UILabel *total;
@property(strong, nonatomic) UIImageView *photo;
@property(strong, nonatomic) UIDatePicker *datePicker;
@property(nonatomic) NSMutableArray *skills;
@property(nonatomic) NSMutableArray *addressArr;
@property(nonatomic) BOOL *hadInitCtl;
@property(nonatomic) BOOL *hadGetAddress;
@property(nonatomic) float totalNum;
@property(nonatomic) float serviceFeeNum;


@property(strong , nonatomic)UICollectionView *serverList;
@property (strong, nonatomic) NSString *servicerId;
@property (strong, nonatomic) NSString *servicerName;
@end

@implementation SubmitOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预约服务";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    
    _hadGetAddress = false;
    [self getAddress];
    CGFloat topOffset = 10;
//    CGFloat topOffset = statusBarFrame.size.height+navigationHeight+8;
    UIColor *lineColor = grayBgColor;
    UIColor *bgColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
    
    CGFloat leftBlank = 10;
    CGFloat topBlank = 10;
    CGFloat splitHei = 8;
    int titleFontSize = 22;
    if(!_hadInitCtl)
        [self initCtl];
    _nameLbl.frame = CGRectMake(leftBlank, 0, SCREEN_WIDTH-40, 20);
    _nameLbl.font = [UIFont systemFontOfSize:24];
    _homeFee.frame = CGRectMake(SCREEN_WIDTH-200, topBlank+5, 190, 30);
    _homeFee.textAlignment = NSTextAlignmentRight;
    _homeFee.textColor = themeColor;
    _homeFee.font = [UIFont systemFontOfSize:18];
    _addressLbl.frame = CGRectMake(leftBlank, _nameLbl.frame.origin.y+_nameLbl.frame.size.height+3, SCREEN_WIDTH-2*leftBlank, 18);
    _addressLbl.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, _addressLbl.frame.origin.y+_addressLbl.frame.size.height+3, SCREEN_WIDTH-2*leftBlank-6, 1)];
    line1.backgroundColor = lineColor;
    
    
    UICollectionViewFlowLayout *layoutA = [[UICollectionViewFlowLayout alloc] init];
    layoutA.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    _serverList = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layoutA];
    //    _serverList.frame = CGRectMake(0, line4.frame.origin.y-2, SCREEN_WIDTH,3*40+2*5);
    _serverList.frame = CGRectMake(0, line1.frame.origin.y-8, SCREEN_WIDTH,[_skills count]*65+([_skills count]-1)*5+25);//+15是为了撑够高度不允许滚动
    _serverList.backgroundColor = [UIColor whiteColor];
    [_serverList registerClass:[ServiceSkillCell class] forCellWithReuseIdentifier:@"serviceCell"];
    [_serverList registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    _serverList.tag = 0;
    _serverList.delegate = self;
    _serverList.dataSource = self;
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(leftBlank+3, _serverList.frame.origin.y+_serverList.frame.size.height, SCREEN_WIDTH-2*leftBlank-6, 1)];
    line2.backgroundColor = lineColor;
    int fontSizeOfTitle = 22;
    UIColor *textColorOfTitle = themeColor;
    UILabel *dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, line2.frame.origin.y+6, SCREEN_WIDTH, 24)];
    dateLbl.text = @"服务时间";
    dateLbl.textAlignment = NSTextAlignmentCenter;
    dateLbl.font = [UIFont systemFontOfSize:fontSizeOfTitle];
    dateLbl.textColor = textColorOfTitle;
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(2*leftBlank, dateLbl.frame.origin.y+dateLbl.frame.size.height-3, SCREEN_WIDTH-4*leftBlank, 60)];
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [self.datePicker setCalendar:[NSCalendar currentCalendar]];
//    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    
    UILabel *workAddressLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, _datePicker.frame.origin.y+_datePicker.frame.size.height-3, SCREEN_WIDTH, 24)];
    workAddressLbl.text = @"服务信息";
    workAddressLbl.textAlignment = NSTextAlignmentCenter;
    workAddressLbl.font = [UIFont systemFontOfSize:fontSizeOfTitle];
    workAddressLbl.textColor = textColorOfTitle;
    _workAddressContent = [[UILabel alloc]initWithFrame:CGRectMake(2*leftBlank, workAddressLbl.frame.origin.y+workAddressLbl.frame.size.height+3, SCREEN_WIDTH-4*leftBlank-60, 24)];
//    _workAddressContent.text = @"毫无用处的一条数据";
    _workTelLbl = [[UILabel alloc]initWithFrame:CGRectMake(2*leftBlank, _workAddressContent.frame.origin.y+_workAddressContent.frame.size.height+3, 120, 24)];
    _workTelLbl.textColor = textColorBlue;
    _workUserNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(_workTelLbl.frame.origin.x+_workTelLbl.frame.size.width+5, _workAddressContent.frame.origin.y+_workAddressContent.frame.size.height+3, SCREEN_WIDTH-4*leftBlank-60-120, 24)];
//    _workUserNameLbl.textColor = textColorBlue;
    UIButton *changeAddress = [[UIButton alloc]initWithFrame:CGRectMake(_workAddressContent.frame.origin.x+_workAddressContent.frame.size.width+5, _workAddressContent.frame.origin.y+4, 50, 40)];
    [changeAddress setTitle:@"更换" forState:UIControlStateNormal];
    changeAddress.backgroundColor = themeColor;
    changeAddress.layer.cornerRadius = 2;
    [changeAddress addTarget:self action:@selector(toChangeAddressPage) forControlEvents:UIControlEventTouchUpInside];
    
    _total = [[UILabel alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT-45, SCREEN_WIDTH/2-20, 40)];
    _total.textColor = themeColor;
    _total.text = [NSString stringWithFormat:@"合计:￥%@",_homeFeeNum];
    _total.font = [UIFont systemFontOfSize:24];

    
    UIButton *submitOrder = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/3+10, SCREEN_HEIGHT-45, SCREEN_WIDTH/3-10*2, 40)];
    submitOrder.titleLabel.textColor = textColorOnBg;
    submitOrder.backgroundColor = themeColor;
    submitOrder.layer.cornerRadius = 4;
    [submitOrder setTitle:@"提交订单" forState:UIControlStateNormal];
    submitOrder.titleLabel.font = [UIFont systemFontOfSize:24];
    [submitOrder addTarget:self action:@selector(sendOrder) forControlEvents:UIControlEventTouchUpInside];
    
    //############################ScrollCView滚动条
    _indexscrol = [[UIScrollView alloc] init];
    
    _indexscrol.frame = CGRectMake(0,topOffset, SCREEN_WIDTH, SCREEN_HEIGHT-topOffset-50);
    _indexscrol.contentSize = CGSizeMake(0, _workTelLbl.frame.origin.y+_workTelLbl.frame.size.height+5);//设置内部的滚动大小，横向不能滚动，纵向长度是第三个section的底坐标
    _indexscrol.backgroundColor = [UIColor whiteColor];
    _indexscrol.showsVerticalScrollIndicator = NO;
    _indexscrol.showsHorizontalScrollIndicator = NO;
    _indexscrol.delegate = self;
    
    
    [self.indexscrol addSubview:_serverList];
    [self.indexscrol addSubview:_nameLbl];
    [self.indexscrol addSubview:_homeFee];
    [self.indexscrol addSubview:_addressLbl];
    [self.indexscrol addSubview:line1];
    
    [self.indexscrol addSubview:line2];
    
    [self.indexscrol addSubview:dateLbl];
    [self.indexscrol addSubview:_datePicker];
    [self.indexscrol addSubview:workAddressLbl];
    
    [self.indexscrol addSubview:_workAddressContent];
    [self.indexscrol addSubview:_workUserNameLbl];
    [self.indexscrol addSubview:_workTelLbl];
    [self.indexscrol addSubview:changeAddress];
    
    [self.view addSubview:self.indexscrol];
    [self.view addSubview:submitOrder];
    [self.view addSubview:_total];
    
    //给indexscrol添加点击事件，用于将键盘收起
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing:)];
    tap.delegate = self;
    [self.indexscrol addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
//收起键盘的操作
- (void)endEditing:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    // 假设为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"tableViewCell"]) {
//        return NO;
//    }
//    return  YES;
//}
//修改单个服务数量后刷新总价
-(void)reflashTotal:(UIButton *)btn{
    [self reflashTotal];
}
-(void)reflashTotal{
    float sum = 0;
    for (ServiceSkillCell *cell in self.serverList.visibleCells) {
        if(![cell.num.text isEqualToString:@"0"]){
            SkillObj *so = [self.skills objectAtIndex:cell.tag];
            so.num =[cell.num.text intValue];
            sum += so.price * so.num;
        }
    }
    _serviceFeeNum = sum;
    sum += [_homeFeeNum floatValue];
    _totalNum = sum;
    _total.text = [NSString stringWithFormat:@"合计:￥%.2f",sum];
}
//刷新服务地址
-(void)showAddress:(UserAddressInfoObj *)ao{
    _workUserNameLbl.text = ao.name;
    _workTelLbl.text = ao.tel;
    _workAddressContent.text = ao.address;
}
-(void)updateAddressArr:(NSMutableArray *)arr{
    _addressArr = arr;
}

-(void)getAddress{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appAddress/", baseUrl]Dic:dic SuccessBlock:^(id responseObject){
            NSLog(@"获取用户地址信息成功jason:%@",responseObject);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //            NSLog(jsonData);
            NSArray *rowsArr = d[@"data"];
            self.addressArr = @[].mutableCopy;
            int tag = -1;
            for(NSDictionary *dict in rowsArr){
                UserAddressInfoObj *ao = [UserAddressInfoObj new];
                ao.name = [dict objectForKey:@"name"];
                ao.tel = [dict objectForKey:@"phone"];
                ao.address = [dict objectForKey:@"address"];
                ao.id = [dict objectForKey:@"id"];
                NSString *tmp =[dict objectForKey:@"flag"];//获取默认地址，1是默认，其他为0
                if([tmp integerValue] == 1){//如果是1，此时记录下arr的count，就是要显示的地址；如果从未有记录，tag == -1，显示第一个地址
                    tag = [_addressArr count];
                    ao.isdefault = true;
                }
                else
                    ao.isdefault = false;
                [_addressArr addObject:ao];
            }
            if([_addressArr count]<1){
                UserAddressInfoObj *ao = [UserAddressInfoObj new];
                ao.address = @"暂未写入地址";
                [MyUtils alertMsg:@"尚未填写地址信息，请点击“更换”按钮填写" method:@"getAddress" vc:self];
                [self showAddress:ao];
                _hadGetAddress = true;
            }
            else{
                if(tag < 0)
                    [self showAddress:[_addressArr objectAtIndex:0]];
                else
                    [self showAddress:[_addressArr objectAtIndex:tag]];
            }
//            if([_addressArr count]==0)
//                [ErrorAlertVC showError:@"尚未填写地址信息，请填写" method:@"getAddress" vc:self];
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"获取用户地址失败:%@",error] method:@"getAddress" vc:self];
        }];
    });
}

-(void)sendOrder{
//    if(debugMode){
//        PayOrderVC *so = [[PayOrderVC alloc]init];
//        [self.navigationController pushViewController:so animated:NO];
//        return;
//    }
    float sum = [_homeFeeNum floatValue];
    int count = 0;
    BOOL hadChoosed = false;
    NSMutableArray *inOrder =@[].mutableCopy;
    for (ServiceSkillCell *c in self.serverList.visibleCells) {
        SkillObj *so = [self.skills objectAtIndex:c.tag];
        so.num =[c.num.text intValue];
        NSString *t = c.remark.text;
        NSLog(t);
        if (!c.remark.text || [c.remark.text isKindOfClass:[NSNull class]] || c.remark.text.length == 0)
            so.remark = @"";
        else{
//            NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//            NSString *trimmedStr = [c.remark.text stringByTrimmingCharactersInSet:set];
//            if (!trimmedStr.length)
//                so.remark = @"";
//            else
                so.remark = c.remark.text;
        }
        count += so.num;
        sum += so.price * so.num;
        [inOrder addObject:so];
        hadChoosed = true;
    }
    if(count == 0)
        [MyUtils alertMsg:@"未选中服务无法预约" method:@"sendOrder" vc:self];
    else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSLog([defaults stringForKey:@"userId"]);
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableArray *goodsList = [[NSMutableArray alloc]init];
            for(SkillObj *so in self.skills){
                if(so.num == 0)
                    continue;
                NSDictionary *temp = [[NSDictionary alloc]init];
                temp = @{@"serverId":self.servicerId,
//                         @"content":[NSString stringWithFormat:@"%@#%@#%@", so.lv1, so.lv2, so.lv3],
                         @"content":[NSString stringWithFormat:@"%@", so.lv3],
                         @"unitPrice":[NSString stringWithFormat:@"%f",so.price],
                         @"times":[NSString stringWithFormat:@"%d",so.num],
                         @"remarks":so.remark
                         };
//                if([temp isEqual:nil])
//                    NSLog(@"error");
                [goodsList addObject:temp];
            }
            //        NSData *data = [NSJSONSerialization dataWithJSONObject:goodsList options:nil error:nil];
            //        NSString *jasonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //        NSString *jasonStr = @"[{\"serverId\":\"100001\",\"content\":\"保洁服务#消杀除虫#暂无三级分类\"},{\"serverId\":\"100001\",\"content\":\"保洁服务#玻璃保洁#暂无三级分类\"}]";
            //        NSString *strUrl = [jasonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//            NSArray *arr = [_total.text componentsSeparatedByString:@"￥"];
            NSString *addressInfo = [NSString stringWithFormat:@"%@&%@&%@",_workUserNameLbl.text,_workTelLbl.text,_workAddressContent.text];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",
                                 [NSNumber numberWithInt:[_servicerId integerValue]],@"serverId",
                                 addressInfo,@"address",
                                 [NSNumber numberWithFloat:[_homeFeeNum floatValue]],@"homeFee",
                                 [NSNumber numberWithFloat:_serviceFeeNum],@"serviceFee",
                                 [NSNumber numberWithFloat:_totalNum],@"total",
                                 [self dateChange:_datePicker],@"dateExpected",
                                 goodsList, @"goodsList",
                                 nil];
            
            [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appOrder/", baseUrl] isJson:TRUE Dic:dic SuccessBlock:^(id responseObject){

                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                int res = [[dict objectForKey:@"code"]integerValue];
                if(res == 0){
                    //success body
                    NSLog(@"订单提交成功jason:%@",responseObject);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    self.tabBarController.selectedIndex = 2;
//                    PayOrderVC *so = [[PayOrderVC alloc]init];
//                    [self.navigationController pushViewController:so animated:NO];
                }
                else{
                    NSString *error = [dict objectForKey:@"error"];
                    [MyUtils alertMsg:[NSString stringWithFormat:@"订单提交失败：error:%@",error] method:@"sendOrder" vc:self];
                }
                } FailureBlock:^(id error){
        //                NSLog(@"订单提交失败error:%@",error);
                    [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误error:%@",error] method:@"sendOrder" vc:self];
                }
             ];
        });
    }
}
-(void)toChangeAddressPage{
    if(!_hadInitCtl){
        [MyUtils alertMsg:@"尚未获取到用户地址信息，请稍后再试" method:@"toChangeAddressPage" vc:self];
        return;
    }
    AddressManagerVC *vc = [[AddressManagerVC alloc]init];
    [vc initVC:self];
    [self.navigationController pushViewController:vc animated:NO];
}
- (NSString *)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置时间格式@"2018-12-11T16:38:12.00+0000"
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.000+0000";
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
//    NSLog(datePicker.date);
//    NSString *strUrl = [dateStr stringByReplacingOccurrencesOfString:@" " withString:@"T"];
//    NSLog(strUrl);
    return dateStr;
//    self.timeTextField.text = dateStr;
}
-(void)initCtl{
    if(_hadInitCtl)
        return;
    _hadInitCtl = true;
    _nameLbl = [[UILabel alloc]init];
    _addressLbl = [[UILabel alloc]init];
    _homeFee = [[UILabel alloc]init];
}
-(void)setServicerName:(NSString *)name setTel:(NSString *)tel setAddress:(NSString *)address setPhoto:(UIImage *)photo setSkills:(NSMutableArray *)skillsArr setServicerId:(NSString *)servicerId setHomeFee:(NSString *)homeFeeNum{
    if(!_hadInitCtl)
        [self initCtl];
    _nameLbl.text = name;
    _addressLbl.text = address;
    _photo.image = photo;
    _skills = skillsArr;
    _servicerId = servicerId;
    _homeFeeNum = homeFeeNum;
    _homeFee.text = [NSString stringWithFormat:@"上门费:￥%.2f",[_homeFeeNum floatValue]];
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
        return [_skills count];//评论数量
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ServiceSkillCell *c =(ServiceSkillCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"serviceCell" forIndexPath:indexPath];
    CGFloat blank = 5;//距离两侧的边距
//    if(debugMode){
//        c.num.text = [NSString stringWithFormat:@"%d", 4-indexPath.row];
//        [self reflashTotal];
//    }
    CGFloat btnWid = 25;
    SkillObj *so = self.skills[indexPath.row];
    c.tag = indexPath.row;
    c.skill.frame = CGRectMake(blank, 5, 150, 28);
    c.skill.font = [UIFont systemFontOfSize:20];
    c.skill.text = [NSString stringWithFormat:@"%@", so.lv3];
    c.cut.frame = CGRectMake(SCREEN_WIDTH-blank-3*btnWid-5-10, 5, btnWid, btnWid);
    [c.cut addTarget:self action:@selector(reflashTotal:) forControlEvents:UIControlEventTouchUpInside];
    c.num.frame = CGRectMake(SCREEN_WIDTH-blank-2*btnWid-5-10, 5, btnWid+5, btnWid);
    c.add.frame = CGRectMake(SCREEN_WIDTH-blank-btnWid-10, 5, btnWid, btnWid);
    [c.add addTarget:self action:@selector(reflashTotal:) forControlEvents:UIControlEventTouchUpInside];
    c.cut.hidden = NO;
    c.add.hidden = NO;
    c.num.hidden = NO;
    c.price.frame = CGRectMake(c.cut.frame.origin.x-110, 7, 100, 24);
    c.price.text = [NSString stringWithFormat:@"￥%.2f/%@", so.price, so.unit];
    c.price.font = [UIFont systemFontOfSize:14];
    c.price.textAlignment = NSTextAlignmentRight;
    c.price.textColor = textColorBlue;
    c.remarkLbl.frame = CGRectMake(blank, c.skill.frame.origin.y+c.skill.frame.size.height+3, 60, 28);
    c.remark.frame = CGRectMake(50, c.skill.frame.origin.y+c.skill.frame.size.height+6, SCREEN_WIDTH-80, 22);
    c.remarkLbl.hidden = NO;
    c.remark.hidden = NO;
    c.remark.background = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, c.remark.frame.origin.y+c.remark.frame.size.height+4, SCREEN_WIDTH-60, 1)];
    line.backgroundColor = grayBgColor;
//    NSLog(@"SubmitOrderVC.m:\n【print:line.frame.origin.y】:%f",line.frame.origin.y);
    [c.contentView addSubview:line];
    return c;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH-20, 65);
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
////进入页面时显示顶部导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden=NO;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

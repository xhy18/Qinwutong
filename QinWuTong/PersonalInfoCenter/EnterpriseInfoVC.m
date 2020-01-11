//
//  EnterpriseInfoVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/17.
//  Copyright © 2019 ltl. All rights reserved.
//  企业个人中心

#import "EnterpriseInfoVC.h"
#import "InfoEditCell.h"
#import "PersonalCenterVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"

@interface EnterpriseInfoVC ()<UITableViewDelegate,UITableViewDataSource>


@property(strong, nonatomic) UITableView *itemList;
@property(strong, nonatomic) UIImage *userPhoto;
@property(strong, nonatomic) UIImageView *photo;
@property(strong, nonatomic) UILabel *userName;
@property(strong, nonatomic) NSArray *itemName;
@property(strong, nonatomic) NSMutableArray *itemContent;
@property(strong, nonatomic) NSMutableArray *itemTitle;

@property(strong, nonatomic) UIBarButtonItem *rightBarItem;

@property(strong, nonatomic) PersonalCenterVC *personalCenterVC;

@property(strong, nonatomic) UIImage *pic;

@property (strong, nonatomic) UIImagePickerController *imgPickerController;
@property (strong, nonatomic) UIImageView *sourceImgView;
@property (strong, nonatomic) UILabel *sourceImgLabel;
@property (strong, nonatomic) UIButton *imgButton;
@property (strong, nonatomic) UIButton *upload;
@property (strong, nonatomic) UIButton *compressButton;

@end

@implementation EnterpriseInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    _rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    _rightBarItem.tag = 1;//1-编辑；2-完成
    self.navigationItem.rightBarButtonItem = _rightBarItem;
    
    CGFloat topOffset = statusBarFrame.size.height+navigationHeight;
    
    self.view.backgroundColor = grayBgColor;
    CGFloat photoHei = 50;
    UILabel *photoBg = [[UILabel alloc]initWithFrame:CGRectMake(5, topOffset+5, SCREEN_WIDTH-10, photoHei+10)];
    photoBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:photoBg];
    _photo = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-photoHei-10, photoBg.frame.origin.y+5, photoHei, photoHei)];
    _photo.image = _userPhoto;
    _photo.layer.masksToBounds=YES;
    _photo.layer.cornerRadius=photoHei/2;
    UILabel *photoItem = [[UILabel alloc]initWithFrame:CGRectMake(photoBg.frame.origin.x+5, photoBg.frame.origin.y+5, 100, photoHei)];
    photoItem.text = @"头像";
    photoItem.font = [UIFont systemFontOfSize:20];
    _photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker:)];
    [_photo addGestureRecognizer:singleTap];
    
    [self.view addSubview:_photo];
    [self.view addSubview:photoItem];
    
    CGFloat itemHei = 40;
    _itemName = [NSArray arrayWithObjects:@"企业名称",@"企业编号",@"企业邮箱",@"认证主体",@"企业简介",nil];
    _itemTitle = [NSArray arrayWithObjects:@"name",@"number",@"email",@"wechat",@"weibo",nil];
    
    _itemList = [[UITableView alloc]initWithFrame:CGRectMake(5, photoBg.frame.origin.y+photoBg.frame.size.height+30, SCREEN_WIDTH-10, itemHei*[_itemName count])];//+3*([_itemName count]-1)
    _itemList.delegate = self;
    _itemList.dataSource = self;
    _itemList.rowHeight = itemHei;
    _itemList.scrollEnabled = NO;
    [_itemList registerClass:[InfoEditCell class] forCellReuseIdentifier:@"mycell"];
    [self.view addSubview:_itemList];
    [self getInfo];
}
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer{
    //do something....
    
}
//===================这些都是从一个轮子里拿过来配了下，用于上传图片=======================
//模态框弹出picker
-(void)showPicker:(UIGestureRecognizer *)gestureRecognizer{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:@"相册选取图片" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"执行动作，打开相册");
        [self presentViewController:self.imgPickerController animated:YES completion:nil];
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"执行动作，调用摄像头");
        [self presentViewController:self.imgPickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alertController addAction:choosePhotoAction];
    [alertController addAction:takePhotoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
// 代理方法(1) : 用户作出完成动作时会触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (self.imgPickerController.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {// 相册选取图片
        // 获取到这个图片
        if (self.imgPickerController.allowsEditing) {
            // 获取编辑后的图片
            self.pic = info[@"UIImagePickerControllerEditedImage"];
        }else {
            // 获取原始图片
            self.pic = info[@"UIImagePickerControllerOriginalImage"];
        }
        // 源图片展示
        _pic = [self compressImg:_pic sizeLimit:80];
        _photo.image = _pic;
        [self uploadImg];
        //        [_imgButton setImage:self.pic forState:UIControlStateNormal];
        //        _upload.hidden = NO;
        NSData *sourceImgData = UIImageJPEGRepresentation(self.pic, 1);
        self.sourceImgLabel.text = [NSString stringWithFormat:@"源图片 : %.2fK", sourceImgData.length / 1024.0];
        [self.view addSubview:self.sourceImgView];
        [self.sourceImgView addSubview:self.sourceImgLabel];
    }else if (self.imgPickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {// 拍照
        // 获取到这个图片
        if (self.imgPickerController.allowsEditing) {
            // 获取编辑后的图片
            self.pic = info[@"UIImagePickerControllerEditedImage"];
        }else {
            // 获取原始图片
            self.pic = info[@"UIImagePickerControllerOriginalImage"];
        }
        // 这里得保存一下新拍的照片, 然后走回调
        UIImageWriteToSavedPhotosAlbum(self.pic, self, @selector(photo:didFinishSavingWithError:contextInfo:), nil);
    }
    // 模态走imgPicker
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 代理方法(2) : 用户作出取消动作时会触发的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // 模态走imgPicker
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 6. 懒加载
- (UIImagePickerController *)imgPickerController {
    // 调用 imgPickerController 的时候, 判断一下是否支持相册或者摄像头功能
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)] && [UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        if (!_imgPickerController) {
            _imgPickerController = [[UIImagePickerController alloc] init];
            _imgPickerController.delegate = self;
            // 产生的媒体文件是否可进行编辑
            _imgPickerController.allowsEditing = YES;
            // 媒体类型
            _imgPickerController.mediaTypes = @[@"public.image"];
        }
        _imgPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        return _imgPickerController;
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持此功能!" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *defaltAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:defaltAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return nil;
    }
}
//==================================================================================
-(void)uploadImg{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSLog(@"useID:%@",[defaults stringForKey:@"userId"]);
    NSData *data = [[NSData alloc]init];
    data = UIImagePNGRepresentation(_pic);
    
    NSString *url =[NSString stringWithFormat:@"%@/app/client/appUser/uploadHeadPortrait",baseUrl];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [defaults stringForKey:@"userId"],@"userId",nil];
    //创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"multipart/form-data",@"image/png", nil];
    //上传文件
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件
        [formData appendPartWithFileData:data name:@"file" fileName:@"userhader.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        //        NSLog(@"%.2lf",progress);
        //        //        if(progress == 100.0){
        //        //            [SVProgressHUD dismiss];
        //        //        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //上传成功后
        NSLog(@"请求成功：%@",responseObject);
        //        [_personalCenterVC refreshPhoto:_pic];//偶尔发现无效
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoChangeSuccess" object:nil];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeHeadImage" object:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败后
        //        NSString t = [NSString stringWithFormat:@"请求失败：%@",error];
        NSLog(@"请求失败：%@",error);
        
    }];
}
-(UIImage *)compressImg:(UIImage *)img sizeLimit:(int)limit{
    NSData *sourceData = UIImageJPEGRepresentation(img, 1);
    [MyUtils debugMsg:[NSString stringWithFormat:@"压缩前%.2f",sourceData.length / 1024.0] vc:self];
    NSLog(@"%.2f",sourceData.length / 1024.0);
    float t = 0.8;
    int i=0;
    while((sourceData.length / 1024.0) > 100){
        sourceData = UIImageJPEGRepresentation(img, t);//这个系数并不是线性的。。。
        img = [UIImage imageWithData:sourceData];
        [MyUtils debugMsg:[NSString stringWithFormat:@"此次压缩%.2f",sourceData.length / 1024.0] vc:self];
        i++;
        if(i>10){
            sourceData = UIImageJPEGRepresentation(img, 0.5);//在某些大小的图片，在0.9的参数上会不执行压缩，于是跳不出循环，当循环10次之后直接改0.5，压缩一次算完
            img = [UIImage imageWithData:sourceData];
            [MyUtils debugMsg:[NSString stringWithFormat:@"此次压缩%.2f",sourceData.length / 1024.0] vc:self];
            break;
        }
    }
    return img;
}
-(void)setPersonalCenterVC:(PersonalCenterVC *)personalCenterVC setPhoto:(UIImage *)img{
    _personalCenterVC = personalCenterVC;
    _photo.image=[UIImage imageNamed:@"icon_default_head.png"];
    _userPhoto = img;
    //    if(img)
    //    else
    //        _photo.image = [UIImage imageNamed:@"icon_default_head.png"];
}
-(void)rightBtnClick:(UIButton *)btn{
    if(btn.tag == 1){//切换为编辑页面
        for (InfoEditCell *cell in self.itemList.visibleCells) {
            if(cell.tag == 0)//用户名不可编辑
                continue;
            [cell setStyle:true];
        }
        //这个修改按钮标题的方式很二。。。
        _rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
        _rightBarItem.tag = 2;
        self.navigationItem.rightBarButtonItem = _rightBarItem;
    }
    else{
        NSString *email;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithCapacity:5];
        [infoDict setObject:[defaults stringForKey:@"userId"] forKey:@"userId"];
        for (InfoEditCell *cell in self.itemList.visibleCells) {
            if(cell.tag == 0)//用户名不可编辑也不用读取
                continue;
            [cell setStyle:false];
            if(cell.tag>0 && cell.tag < [_itemTitle count]-1)
                [infoDict setObject:[MyUtils checkAndGetStr:cell.content.text] forKey:[_itemTitle objectAtIndex:cell.tag]];
            else
                email = [MyUtils checkAndGetStr:cell.content.text];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [defaults stringForKey:@"userId"],@"userId",
                                 email,@"email",
                                 infoDict,@"personalInfo",
                                 nil];
            [DIYAFNetworking PostHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appUser/completeEnterpriseInfo", baseUrl] isJson:true Dic:dic SuccessBlock:^(id responseObject){
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                int res = [[dict objectForKey:@"code"]integerValue];
                if(res == 0){
                    NSLog(@"json:%@",responseObject);
                    [MyUtils alertMsg:[NSString stringWithFormat:@"编辑成功!"] method:@"rightBtnClick" vc:self];
                    [self getInfo];
                }
                else{
                    NSString *error = [dict objectForKey:@"error"];
                    [MyUtils alertMsg:[NSString stringWithFormat:@"编辑失败：error:%@",error] method:@"rightBtnClick" vc:self];
                }
            } FailureBlock:^(id error){
                [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误：error:%@",error] method:@"rightBtnClick" vc:self];
            }];
        });
        _rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
        _rightBarItem.tag = 1;
        self.navigationItem.rightBarButtonItem = _rightBarItem;
    }
}
-(void)getInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:                                                                               [defaults stringForKey:@"userId"],@"userId",nil];
        
        [DIYAFNetworking GetHttpDataWithUrlStr:[NSString stringWithFormat:@"%@/app/client/appUser/enterpriseInfo", baseUrl]Dic:dic SuccessBlock:^(id responseObject){
            NSLog(@"获取用户信息成功jason:%@",responseObject);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //            NSLog(jsonData);
            
            self.itemContent = @[].mutableCopy;
            int res = [[d objectForKey:@"code"]integerValue];
            if(res == 0){
                //                NSString *t;
                //                t = responseObject[@"data"][@"name"];
                //                t = responseObject[@"data"][@"personalInfo"][@"name"];
                //                NSLog([NSString stringWithFormat:@"%@",t]);
                //
                ////                [self->_itemContent addObject:[NSString stringWithFormat:@"%@",t]];
                if([MyUtils isBlankString:responseObject[@"data"][@"userName"]])
                    [self->_itemContent addObject:@"(未填写)"];
                else
                    [self->_itemContent addObject:responseObject[@"data"][@"userName"]];
                NSDictionary *personalInfo = responseObject[@"data"][@"personalInfo"];
                if([personalInfo isKindOfClass:[NSNull class]]){
                    [self->_itemContent addObject:@"(未填写)"];
                    [self->_itemContent addObject:@"(未填写)"];
                    [self->_itemContent addObject:@"(未填写)"];
                    [self->_itemContent addObject:@"(未填写)"];
                }
                else{
                    //                NSString * t =responseObject[@"data"][@"personalInfo"];
                    for(int i = 1;i<[_itemTitle count]-1;i++){
                        NSString *t = [_itemTitle objectAtIndex:i];
                        if([MyUtils isBlankString:responseObject[@"data"][@"personalInfo"][t]])
                            [self->_itemContent addObject:@"(未填写)"];
                        else
                            [self->_itemContent addObject:responseObject[@"data"][@"personalInfo"][t]];
                    }
                }
                if([MyUtils isBlankString:responseObject[@"data"][@"email"]])
                    [self->_itemContent addObject:@"(未填写)"];
                else
                    [self->_itemContent addObject:responseObject[@"data"][@"email"]];
                [_itemList reloadData];
            }
            else{
                NSString *error = [d objectForKey:@"error"];
                [MyUtils alertMsg:[NSString stringWithFormat:@"获取用户信息失败：error:%@",error] method:@"getInfo" vc:self];
            }
        } FailureBlock:^(id error){
            [MyUtils alertMsg:[NSString stringWithFormat:@"请求错误:%@",error] method:@"getInfo" vc:self];
        }];
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_itemName count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoEditCell *c = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    c.title.text = [_itemName objectAtIndex:indexPath.row];
    if([_itemContent count] != [_itemName count]){
        //        [ErrorAlertVC showError:[NSString stringWithFormat:@"个人信息数组异常!"] method:@"tableView cell配置" vc:self];
        return c;
    }
    [c setStyle:false];
    NSString *t = [_itemContent objectAtIndex:indexPath.row];
    c.tag = indexPath.row;
    //    c.title = [_itemTitle objectAtIndex:indexPath.row];
    if(t && (![t isKindOfClass:[NSNull class]]))
        c.content.text = [_itemContent objectAtIndex:indexPath.row];
    else
        c.content.text = @"（未填写）";
    c.selectionStyle = UITableViewCellSelectionStyleNone;
    return c;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;
}
@end

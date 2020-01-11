//
//  UploadHeadPortraitVC.m
//  QinWuTong
//
//  Created by ltl on 2019/1/13.
//  Copyright © 2019 ltl. All rights reserved.
//  上传头像

#import "UploadHeadPortraitVC.h"

#import "Constants.h"
#import "MyUtils.h"
#import "AFNetworking.h"
#import "DIYAFNetworking.h"
@interface UploadHeadPortraitVC ()


@property (strong, nonatomic) UIImage *pic;

@property (strong, nonatomic) UIImagePickerController *imgPickerController;
@property (strong, nonatomic) UIImageView *sourceImgView;
@property (strong, nonatomic) UILabel *sourceImgLabel;
@property (strong, nonatomic) UIButton *imgButton;
@property (strong, nonatomic) UIButton *upload;
@property (strong, nonatomic) UIButton *compressButton;
@end

@implementation UploadHeadPortraitVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    _pic = [UIImage imageNamed:@"main_hot1.png"];
    
    self.navigationItem.title = @"上传头像";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : textColorOnBg,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize]}];
    self.navigationController.navigationBar.barTintColor = themeColor;
    [[UINavigationBar appearance] setTintColor:textColorOnBg];
    
    int blank  = 80;
    _imgButton = [[UIButton alloc] initWithFrame:CGRectMake(blank, (SCREEN_WIDTH-2*blank)/2, SCREEN_WIDTH-2*blank, SCREEN_WIDTH-2*blank)];
    //        _imgButton.center = CGPointMake(self.view.center.x - 50, 150);
    _imgButton.backgroundColor = [UIColor redColor];
    [_imgButton setTitleColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0] forState:UIControlStateNormal];
    _imgButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _imgButton.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    _imgButton.layer.cornerRadius = (SCREEN_WIDTH-2*blank)/2;
    _imgButton.layer.masksToBounds=YES;
    [_imgButton setTitle:@"请上传图片" forState:(UIControlStateNormal)];
    [_imgButton addTarget:self action:@selector(imgButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.imgButton];
    
    _upload = [[UIButton alloc]initWithFrame:CGRectMake(_imgButton.frame.origin.x, _imgButton.frame.origin.y+_imgButton.frame.size.height+20, _imgButton.frame.size.width, 40)];
    _upload.hidden = YES;
    [_upload setTitle:@"上  传" forState:UIControlStateNormal];
    _upload.titleLabel.font = [UIFont systemFontOfSize:20];
    _upload.backgroundColor = themeColor;
    _upload.layer.cornerRadius = 4;
    [_upload addTarget:self action:@selector(uploadImg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_upload];
}
#pragma mark - 3. 调用相册选取视频或录像, 我们只需要操作以下两个代理方法

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
        [_imgButton setImage:self.pic forState:UIControlStateNormal];
        _upload.hidden = NO;
//        self.sourceImgView.image = self.pic;
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

#pragma mark - 5. 给定一个事件模态出 imgPicker 来干活

- (void)imgButtonAction:(UIButton *)button {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您好! 我是imgPickerController!" message:@"您是要去相册选取图片呢还是拍照呢?" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册选取图片" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        // 选取图片状态
//        self.isPhotoAlbum = YES;
        // 模态出 imgPicker 来干活
        [self presentViewController:self.imgPickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了而已" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
        
//        if (self.isPhotoAlbum) {
//            
//            // 媒体源, 这里设置为相册
//            _imgPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        }else{
//            
//            // 媒体源, 这里设置为摄像头
//            _imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            // 摄像头, 这里设置默认使用后置摄像头
//            _imgPickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//            // 摄像头模式, 这里设置为拍照模式
//            _imgPickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//        }
        
        return _imgPickerController;
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持此功能!" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *defaltAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
        
        [alertController addAction:defaltAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return nil;
    }
}



- (UIImageView *)sourceImgView {

    if (!_sourceImgView) {
        
        _sourceImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - (SCREEN_HEIGHT - 250) / 2.0 * 4 / 3) / 2, SCREEN_HEIGHT - (SCREEN_HEIGHT - 250) / 2.0 * 2, (SCREEN_HEIGHT - 250) / 2.0 * 4 / 3, (SCREEN_HEIGHT - 250) / 2.0)];
        _sourceImgView.backgroundColor = [UIColor clearColor];
    }

    return _sourceImgView;
}

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

//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoChangeSuccess" object:nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeHeadImage" object:nil];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败后
//        NSString t = [NSString stringWithFormat:@"请求失败：%@",error];
        NSLog(@"请求失败：%@",error);

    }];
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

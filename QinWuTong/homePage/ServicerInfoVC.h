//
//  ServicerInfoVC.h
//  QinWuTong
//
//  Created by ltl on 2018/12/13.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServicerInfoVC : UIViewController
-(void)getSkillByServicerId;
//-(void)setServicerName:(NSString *)name setTel:(NSString *)tel setAddress:(NSString *)address setDis:(NSString *)distance setPhoto:(UIImage *)photo;
-(void)setServicerId:(NSString *)servicerId setLat:(double)lat setLon:(double)lon;
@end

NS_ASSUME_NONNULL_END

//
//  SubmitOrderVC.h
//  QinWuTong
//
//  Created by ltl on 2018/12/20.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAddressInfoObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubmitOrderVC : UIViewController
-(void)showAddress:(UserAddressInfoObj *)ao;
-(void)updateAddressArr:(NSMutableArray *)arr;
-(void)setServicerName:(NSString *)name setTel:(NSString *)tel setAddress:(NSString *)address setPhoto:(UIImage *)photo setSkills:(NSMutableArray *)skillsArr setServicerId:(NSString *)servicerId setHomeFee:(NSString *)homeFeeNum;
@end

NS_ASSUME_NONNULL_END

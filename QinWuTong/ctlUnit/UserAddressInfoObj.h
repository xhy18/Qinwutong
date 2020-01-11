//
//  UserAddressInfoObj.h
//  QinWuTong
//
//  Created by ltl on 2018/12/26.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserAddressInfoObj : UIViewController
@property(strong , nonatomic)NSString *name;
@property(strong , nonatomic)NSString *tel;
@property(strong , nonatomic)NSString *address;
@property(strong , nonatomic)NSString *id;
@property(nonatomic)bool *isdefault;

@end

NS_ASSUME_NONNULL_END

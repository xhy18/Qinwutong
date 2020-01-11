//
//  PayPageVC.h
//  QinWuTong
//
//  Created by ltl on 2019/1/16.
//  Copyright © 2019 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayPageVC : UIViewController
-(void)setAmount:(int)amount tip:(NSString *)tip;
-(void)setType:(int)type setId:(long)orderId tip:(NSString *)tip;
@end

NS_ASSUME_NONNULL_END

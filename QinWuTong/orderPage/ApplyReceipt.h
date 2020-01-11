//
//  ApplyReceipt.h
//  QinWuTong
//
//  Created by ltl on 2019/1/10.
//  Copyright © 2019 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderObj.h"
#import "SkillObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyReceipt : UIViewController
-(void)setAndInit:(OrderObj *)obj setSkill:(SkillObj *)skill;
@end

NS_ASSUME_NONNULL_END

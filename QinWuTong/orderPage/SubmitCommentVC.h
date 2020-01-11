//
//  SubmitCommentVC.h
//  QinWuTong
//
//  Created by ltl on 2019/1/4.
//  Copyright © 2019 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderObj.h"
#import "SkillObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubmitCommentVC : UIViewController
-(void)initFrameWithData:(OrderObj *)order skill:(SkillObj *)skill;
@end

NS_ASSUME_NONNULL_END

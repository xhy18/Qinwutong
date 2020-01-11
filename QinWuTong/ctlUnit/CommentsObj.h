//
//  CommentsObj.h
//  QinWuTong
//
//  Created by ltl on 2018/12/24.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentsObj : UIViewController
@property(strong , nonatomic)NSString *userName;
@property(strong , nonatomic)NSString *commentId;
@property(strong , nonatomic)NSString *serviceContent;
@property(strong , nonatomic)NSString *comments;
@property(strong , nonatomic)NSString *reply;
@property(strong , nonatomic)NSString *addComments;
@property(strong , nonatomic)NSString *score;
@property(strong , nonatomic)NSString *date;
@end

NS_ASSUME_NONNULL_END

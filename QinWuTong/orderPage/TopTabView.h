//
//  TopTabView.h
//  QinWuTong
//
//  Created by ltl on 2018/12/10.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopTabView : UIView


- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withUnselectedImage:(NSString *)unselectedImage withSelectedImage:(NSString *)selectedImage ;

@property (nonatomic, strong) UIImageView *unselectedImage; /**<  未被选中时的图片   **/
@property (nonatomic, strong) UIImageView *selectedImage; /**<  被选中时的图片   **/
@property (nonatomic, strong) UILabel *title; /**<  按钮中间的标题   **/

@end

NS_ASSUME_NONNULL_END

//
//  HJTPagerView.h
//  QinWuTong
//
//  Created by ltl on 2018/12/10.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJTPagerView : UIView

- (instancetype)initWithTitles:(NSArray *)titles WithVCs:(NSArray *)childVCs WithColorArrays:(NSArray *)colors;
@property (strong, nonatomic) UIColor *selectColor; /**<  选中时的颜色   **/
@property (strong, nonatomic) UIColor *unselectColor; /**<  未选中时的颜色   **/
@property (strong, nonatomic) UIColor *underlineColor; /**<  下划线的颜色   **/

@end

NS_ASSUME_NONNULL_END

//
//  HJTBaseView.h
//  QinWuTong
//
//  Created by ltl on 2018/12/10.
//  Copyright © 2018 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJTBaseView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) NSInteger currentPage; /**<  页码   **/
@property (strong, nonatomic) UIScrollView *topTab; /**<  顶部tab   **/
@property (strong, nonatomic) NSArray *titleArray; /**<  标题   **/

- (instancetype)initWithFrame:(CGRect)frame WithSelectColor:(UIColor *)selectColor WithUnselectorColor:(UIColor *)unselectColor WithUnderLineColor:(UIColor *)underlineColor;


@end

NS_ASSUME_NONNULL_END

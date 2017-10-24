//
//  TARefreshBaseViewPrivate.h
//  TARefreshControlDemo
//
//  Created by zoxuner on 2017/10/17.
//  Copyright © 2017年 zuoxunhudong. All rights reserved.
//

#import "TARefreshBaseView.h"

@interface TARefreshBaseView ()
@property(nonatomic, weak, readwrite) UIScrollView *scrollView;
/** refresh progress */
@property (nonatomic, assign, readwrite) CGFloat progress;
/**
 用于回弹时处理UI动画
 
 progress自身没有动画, 只有终点值
 
 @param duration 动画时长
 */
- (void)_setProgress:(CGFloat)progress withDuration:(CGFloat)duration;

/**
 执行刷新后的回调
 */
- (void)executeRefreshBlock;

@end

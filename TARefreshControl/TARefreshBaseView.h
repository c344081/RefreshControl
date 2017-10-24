//
//  TARefreshBaseView.h
//  TARefreshControlDemo
//
//  Created by zoxuner on 16/7/30.
//  Copyright © 2016年 zuoxunhudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TARefreshConst.h"
#import "UIView+TARefreshEx.h"

typedef void(^TARefreshBlock)(void);

@protocol TARefreshStateProtocol <NSObject>


@end


@interface TARefreshBaseView : UIView <TARefreshStateProtocol>

@property(nonatomic, weak, readonly) UIScrollView *scrollView;

/** refresh progress */
@property (nonatomic, assign, readonly) CGFloat progress;

/** refresh block*/
@property(nonatomic, copy) TARefreshBlock block;

+ (instancetype)refreshViewWithBlock:(TARefreshBlock)block;

/**
 *  @brief 结束刷新
 */
- (void)endRefreshing NS_REQUIRES_SUPER;

/**
 进入刷新需要移动的距离, 使用正数
 
 @return 可以刷新的阈值
 */
- (CGFloat)offsetForRefresh;

/**
 刷新进度更新后调用
 
 @note 主要用于一些依赖进度的UI更新, 不太适合做状态判断
 
 @param progress 进度
 @param oldValue 之前的进度
 */
- (void)onRefreshProgressUpdated:(CGFloat)progress oldValue:(CGFloat)oldValue;

/**
 用于回弹时处理UI动画
 
 progress自身没有动画, 只有终点值
 
 @param duration 动画时长
 @param completed 完成后的回调
 */
- (void)setProgress:(CGFloat)progress withDuration:(CGFloat)duration completed:(void(^)(void))completed;

//========================================
//  customise
//========================================
/**
 *  @brief 添加自定义控件
 */
- (void)addOwnViews;

/**
 *  @brief 设置控件frame
 */
- (void)layoutSubviewsFrame NS_REQUIRES_SUPER;

@end

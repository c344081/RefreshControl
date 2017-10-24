//
//  UIScrollView+TARefreshControl.h
//  TARefreshControlDemo
//
//  Created by zoxuner on 16/7/30.
//  Copyright © 2016年 zuoxunhudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TARefreshConst.h"
@class TARefreshControlHeader;
@class TARefreshControlFooter;
@class TARefreshDisposable;
@class RefreshControlState;

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TARefreshControl)
/** header*/
@property(nonatomic, strong) TARefreshControlHeader *ta_header;
/** footer*/
@property(nonatomic, strong) TARefreshControlFooter *ta_footer;
/** indicate dealloc */
@property (nonatomic, strong) TARefreshDisposable *ta_disposable;
/** refreshControl state*/
@property (nonatomic, strong) RefreshControlState *ta_refreshControlState;

/**
 表示刷新状态
 
 @return 表示刷新状态
 */
- (BOOL)isRefreshing;

/**
 表示正在加载分页数据

 @return 表示正在加载分页数据
 */
- (BOOL)isLoadingMore;

/**
 停止刷新
 
 @note 由于上拉与下拉只会同时有一个在刷新状态, 所以可以作为公用的结束刷新方法
 */
- (void)endRefreshing;

/**
 开始刷新
 */
- (void)beginRefreshing;

@end

NS_ASSUME_NONNULL_END

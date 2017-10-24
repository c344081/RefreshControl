//
//  TARefreshControlHeader.h
//  TARefreshControlDemo
//
//  Created by zoxuner on 16/7/30.
//  Copyright © 2016年 zuoxunhudong. All rights reserved.
//

#import "TARefreshBaseView.h"

@interface TARefreshControlHeader : TARefreshBaseView
/** 箭头视图*/
@property (nonatomic, weak) UIImageView *arrowImageView;
/** 说明文字*/
@property (nonatomic, weak) UILabel *textLabel;
/** activity indicator*/
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

/**
 *  @brief 开始刷新
 */
- (void)beginRefreshing;

- (void)onBeforeCanRefresh;

- (void)onCanRefresh;

- (void)onRefreshing;

- (void)onRefreshEnd;

@end

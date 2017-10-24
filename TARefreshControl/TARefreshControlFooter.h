//
//  TARefreshControlFooter.h
//  TARefreshControlDemo
//
//  Created by zoxuner on 16/7/30.
//  Copyright © 2016年 zuoxunhudong. All rights reserved.
//

#import "TARefreshBaseView.h"

@interface TARefreshControlFooter : TARefreshBaseView
/** 说明文字*/
@property (nonatomic, weak) UILabel *textLabel;
/** activity indicator*/
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

- (void)onLoading;

- (void)onLoadingEnd;

@end

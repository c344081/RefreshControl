//
//  TARefreshControlFooter.m
//  TARefreshControlDemo
//
//  Created by zoxuner on 16/7/30.
//  Copyright © 2016年 zuoxunhudong. All rights reserved.
//

#import "TARefreshControlFooter.h"
#import "UIScrollView+TARefreshControl.h"

@interface TARefreshControlFooter ()

@end

@implementation TARefreshControlFooter

- (void)addOwnViews {
    UILabel *textLabel = [[UILabel alloc] init];
    [self addSubview:textLabel];
    self.textLabel = textLabel;
    textLabel.textColor = [UIColor darkTextColor];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.text = @"上拉加载更多";
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityIndicator];
    self.activityIndicator = activityIndicator;
    activityIndicator.hidden = YES;
}

- (void)layoutSubviewsFrame {
    [super layoutSubviewsFrame];
    self.ta_height = TARefreshFooterH;
    self.ta_width = [UIScreen mainScreen].bounds.size.width;
    self.ta_y = MAX(CGRectGetMaxY(self.scrollView.frame), self.scrollView.contentSize.height);
    self.backgroundColor = [UIColor orangeColor];
    
    [self.textLabel sizeToFit];
    self.textLabel.ta_centerY = self.ta_height * 0.5;
    self.textLabel.ta_centerX = self.ta_width * 0.5;
    
    if (!self.activityIndicator.hidden) {
        if (self.textLabel.text.length > 0) {
            self.activityIndicator.ta_x = (self.ta_width - (self.activityIndicator.ta_width + 10 + self.textLabel.ta_width)) * 0.5;
            self.textLabel.ta_x = CGRectGetMaxX(self.activityIndicator.frame) + 10;
        } else {
            self.activityIndicator.ta_centerX = self.ta_width * 0.5;
        }
        self.activityIndicator.ta_centerY = self.ta_height * 0.5;
    }
}

- (void)endRefreshing {
    [super endRefreshing];
}

- (void)onLoading {
    self.textLabel.text = @"正在加载数据";
    [self.activityIndicator startAnimating];
    [self setNeedsLayout];
}

- (void)onLoadingEnd {
    self.textLabel.text = @"上拉加载更多";
    [self.activityIndicator stopAnimating];
    [self setNeedsLayout];
}

- (void)onRefreshProgressUpdated:(CGFloat)progress oldValue:(CGFloat)oldValue {
    NSLog(@"load more progress:%f", progress);
}

- (CGFloat)offsetForRefresh {
    return TARefreshFooterH;
}

@end

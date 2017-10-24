//
//  TARefreshControlHeader.m
//  TARefreshControlDemo
//
//  Created by zoxuner on 16/7/30.
//  Copyright © 2016年 zuoxunhudong. All rights reserved.
//

#import "TARefreshControlHeader.h"
#import "UIScrollView+TARefreshControl.h"

UIImage *arrowImage(void) {
    CGFloat width = 22;
    CGFloat height = 44;
    CGFloat lineWidth = 2.0;
    // arrow angle 90
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    [[UIColor darkTextColor] setStroke];
    UIBezierPath *verticalLinePath = [UIBezierPath bezierPath];
    verticalLinePath.lineWidth = lineWidth;
    verticalLinePath.lineCapStyle = kCGLineCapRound;
    [verticalLinePath moveToPoint:CGPointMake(width * 0.5, 0)];
    [verticalLinePath addLineToPoint:CGPointMake(width * 0.5, height - 0.5)];
    [verticalLinePath stroke];
   
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    leftPath.lineWidth = lineWidth;
    leftPath.lineCapStyle = kCGLineCapRound;
    [leftPath moveToPoint:CGPointMake(0.5, height - (width - 1) * 0.5)];
    [leftPath addLineToPoint:CGPointMake(width * 0.5, height - 0.5)];
    [leftPath stroke];
    
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    rightPath.lineWidth = lineWidth;
    rightPath.lineCapStyle = kCGLineCapRound;
    [rightPath moveToPoint:CGPointMake(width - 0.5, height - (width - 1) * 0.5)];
    [rightPath addLineToPoint:CGPointMake(width * 0.5, height - 0.5)];
    [rightPath stroke];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@interface TARefreshControlHeader ()

@end

@implementation TARefreshControlHeader

- (void)addOwnViews {
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:arrowImage()];
    [self addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    UILabel *textLabel = [[UILabel alloc] init];
    [self addSubview:textLabel];
    self.textLabel = textLabel;
    textLabel.textColor = [UIColor darkTextColor];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.text = @"下拉刷新";
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityIndicator];
    self.activityIndicator = activityIndicator;
    activityIndicator.hidden = YES;
}

- (void)layoutSubviewsFrame {
    [super layoutSubviewsFrame];
    self.ta_height = TARefreshHeaderH;
    self.ta_width = [UIScreen mainScreen].bounds.size.width;
    self.ta_y = CGRectGetMinY(self.scrollView.frame) - self.ta_height;
    self.backgroundColor = [UIColor orangeColor];
    
    [self.textLabel sizeToFit];
    self.textLabel.ta_centerY = self.ta_height * 0.5;
    
    if (!self.activityIndicator.hidden) {
        if (self.textLabel.text.length > 0) {
            self.activityIndicator.ta_x = (self.ta_width - (self.activityIndicator.ta_width + 10 + self.textLabel.ta_width)) * 0.5;
            self.textLabel.ta_x = CGRectGetMaxX(self.activityIndicator.frame) + 10;
        } else {
            self.activityIndicator.ta_centerX = self.ta_width * 0.5;
        }
        self.activityIndicator.ta_centerY = self.ta_height * 0.5;
    } else {
        if (self.arrowImageView.image) {
            CGFloat imageH = self.textLabel.ta_height + 5;
            self.arrowImageView.ta_height = imageH;
            self.arrowImageView.ta_width = self.arrowImageView.image.size.width / self.arrowImageView.image.size.height * imageH;
            self.arrowImageView.ta_centerY = self.ta_height * 0.5;
            self.arrowImageView.ta_x = (self.ta_width - (self.arrowImageView.ta_width + 10 + self.textLabel.ta_width)) * 0.5;
            self.textLabel.ta_x = CGRectGetMaxX(self.arrowImageView.frame) + 10;
        } else {
            self.textLabel.ta_centerX = self.ta_width * 0.5;
        }
    }
}

- (void)beginRefreshing {
    [self.scrollView beginRefreshing];
}

- (void)endRefreshing {
    [super endRefreshing];
}

- (void)onBeforeCanRefresh {
    self.textLabel.text = @"下拉刷新";
    [UIView animateWithDuration:0.15 animations:^{
        self.arrowImageView.transform = CGAffineTransformIdentity;
    }];
    [self setNeedsLayout];
}

- (void)onCanRefresh {
    self.textLabel.text = @"释放更新";
    [UIView animateWithDuration:0.15 animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI - 0.01);
    }];
    [self setNeedsLayout];
}

- (void)onRefreshing {
    self.textLabel.text = @"正在刷新...";
    [self.activityIndicator startAnimating];
    self.arrowImageView.hidden = YES;
    [self setNeedsLayout];
}

- (void)onRefreshEnd {
    self.textLabel.text = @"下拉刷新";
    [self.activityIndicator stopAnimating];
    self.arrowImageView.hidden = NO;
    self.arrowImageView.transform = CGAffineTransformIdentity;
    [self setNeedsLayout];
}

- (void)setProgress:(CGFloat)progress withDuration:(CGFloat)duration completed:(void (^)(void))completed {
    
}

- (void)onRefreshProgressUpdated:(CGFloat)progress oldValue:(CGFloat)oldValue {
    NSLog(@"refresh progress:%f", progress);
}

- (CGFloat)offsetForRefresh {
    return TARefreshHeaderH;
}

@end

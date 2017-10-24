//
//  UIView+TARefreshEx.m
//  TARefreshControlDemo
//
//  Created by zoxuner on 16/7/30.
//  Copyright © 2016年 zuoxunhudong. All rights reserved.
//

#import "UIView+TARefreshEx.h"

@implementation UIView (TARefreshEx)
- (void)setTa_x:(CGFloat)ta_x {
    CGRect frame = self.frame;
    frame.origin.x = ta_x;
    self.frame = frame;
}

- (CGFloat)ta_x {
    return self.frame.origin.x;
}

- (void)setTa_y:(CGFloat)ta_y {
    CGRect frame = self.frame;
    frame.origin.y = ta_y;
    self.frame = frame;
}

- (CGFloat)ta_y {
    return self.frame.origin.y;
}

- (void)setTa_width:(CGFloat)ta_width {
    CGRect frame = self.frame;
    frame.size.width = ta_width;
    self.frame = frame;
}

- (CGFloat)ta_width {
    return self.frame.size.width;
}

- (void)setTa_height:(CGFloat)ta_height {
    CGRect frame = self.frame;
    frame.size.height = ta_height;
    self.frame = frame;
}

- (CGFloat)ta_height {
    return self.frame.size.height;
}

- (void)setTa_centerX:(CGFloat)ta_centerX {
    CGPoint center = self.center;
    center.x = ta_centerX;
    self.center = center;
}

- (CGFloat)ta_centerX {
    return self.center.x;
}

- (void)setTa_centerY:(CGFloat)ta_centerY {
    CGPoint center = self.center;
    center.y = ta_centerY;
    self.center = center;
}

- (CGFloat)ta_centerY {
    return self.center.y;
}

@end

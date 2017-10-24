//
//  TARefreshDisposable.m
//  TARefreshControlDemo
//
//  Created by zoxuner on 2017/10/17.
//  Copyright © 2017年 zuoxunhudong. All rights reserved.
//

#import "TARefreshDisposable.h"

@implementation TARefreshDisposable

+ (instancetype)disposableWithBlock:(void (^)(void))block {
    return [[self.class alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(void(^)(void))block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)dealloc {
    !_block ?: _block();
}

@end

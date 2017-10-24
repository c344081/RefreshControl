//
//  RefreshControlState.m
//  SimpleStateMachineDemo
//
//  Created by zoxuner on 2017/10/19.
//  Copyright © 2017年 zuoxunhudong. All rights reserved.
//

#import "RefreshControlState.h"

@implementation RefreshControlState

+ (instancetype)fanWithState:(FSMState)state {
    return [[self.class alloc] initWithState:state];
}

@end

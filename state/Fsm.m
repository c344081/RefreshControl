//
//  Fsm.m
//  SimpleStateMachineDemo
//
//  Created by zoxuner on 2017/10/19.
//  Copyright © 2017年 zuoxunhudong. All rights reserved.
//

#import "Fsm.h"

@interface Fsm ()
/** 处理函数字典*/
@property (nonatomic, strong) NSMutableDictionary<FSMState,NSMutableDictionary<FSMEvent,FSMHandler> *> *handlers;
@end

@implementation Fsm

- (instancetype)initWithState:(FSMState)state {
    self = [super init];
    if (self) {
        self.state = state;
    }
    return self;
}

- (void)addHandler:(FSMHandler)handler state:(FSMState)state event:(FSMEvent)event {
    NSMutableDictionary *eventHandlers = self.handlers[state];
    if (!eventHandlers) {
        eventHandlers = [NSMutableDictionary dictionary];
        self.handlers[state] = eventHandlers;
    }
    FSMHandler h = eventHandlers[event];
    if (h) {
        NSLog(@"[警告] 状态(%@)事件(%@)已定义过", state, event);
    }
    eventHandlers[event] = handler;
}

- (FSMState)call:(FSMEvent)event {
    NSMutableDictionary *events = self.handlers[self.state];
    if (!events) {
        return self.state;
    }
    FSMHandler handler = events[event];
    if (handler) {
        FSMState oldState = self.state;
        self.state = handler();
        FSMState newState = self.state;
        NSLog(@"状态从 [\" %@ \"] 变成 [\" %@ \"]", oldState, newState);
    }
    return self.state;
}

- (NSMutableDictionary<FSMState,NSMutableDictionary<FSMEvent,FSMHandler> *> *)handlers {
    if (!_handlers) {
        _handlers = [NSMutableDictionary dictionary];
    }
    return _handlers;
}

@end

//
//  Fsm.h
//  SimpleStateMachineDemo
//
//  Created by zoxuner on 2017/10/19.
//  Copyright © 2017年 zuoxunhudong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString* FSMState;
typedef NSString* FSMEvent;
typedef FSMState(^FSMHandler)(void);

@interface Fsm : NSObject
/** 当前状态*/
@property (nonatomic, copy) FSMState state;

- (instancetype)initWithState:(FSMState)state;

- (void)addHandler:(FSMHandler)handler state:(FSMState)state event:(FSMEvent)event;

- (FSMState)call:(FSMEvent)event;

@end

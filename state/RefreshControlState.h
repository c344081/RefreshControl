//
//  RefreshControlState.h
//  SimpleStateMachineDemo
//
//  Created by zoxuner on 2017/10/19.
//  Copyright © 2017年 zuoxunhudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fsm.h"

static FSMState const Normal                 = @"Normal";

static FSMState const PullToRefresh         = @"PullToRefresh";
static FSMState const WaitingRefresh        = @"WaitingRefresh";
static FSMState const PullbackB4Threshold   = @"PullbackB4Threshold";
static FSMState const PullbackAftThreshold  = @"PullbackAftThreshold";
static FSMState const Refreshing            = @"Refreshing";
static FSMState const RefreshEnd            = @"Normal"; // 同Normal

static FSMEvent const PullingDownBeganEvent     = @"开始下拉刷新";
static FSMEvent const WaitingRefreshEvent       = @"可以刷新了";
static FSMEvent const PullbackB4ThresholdEvent  = @"阈值前回撤刷新";
static FSMEvent const PullbackAftThresholdEvent  = @"阈值后回撤刷新";
static FSMEvent const BackToNormalEvent         = @"恢复正常状态"; // 松手
static FSMEvent const RefreshBeganEvent         = @"进入刷新状态";
static FSMEvent const RefreshEndedEvent         = @"刷新结束";

static FSMState const WillLoadMore        = @"WillLoadMore";
static FSMState const LoadingMore         = @"LoadingMore";
static FSMState const LoadMoreEnded       = @"LoadMoreEnded";

static FSMEvent const WillLoadMoreEvent   = @"即将加载分页数据";
static FSMEvent const LoadMoreBeganEvent  = @"进入加载更多状态";
static FSMEvent const LoadMoreEndedEvent  = @"加载分页数据结束";

@interface RefreshControlState : Fsm

+ (instancetype)fanWithState:(FSMState)state;

@end


//
//  TARefreshDisposable.h
//  TARefreshControlDemo
//
//  Created by zoxuner on 2017/10/17.
//  Copyright © 2017年 zuoxunhudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TARefreshDisposable : NSObject
/** block*/
@property (nonatomic, copy) void(^block)(void);

/**
 实例化方法

 @param block dealloc前调用的block
 @return 实例
 */
+ (instancetype)disposableWithBlock:(void(^)(void))block;

@end

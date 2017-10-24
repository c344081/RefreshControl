//
//  UIScrollView+TARefreshControl.m
//  TARefreshControlDemo
//
//  Created by zoxuner on 16/7/30.
//  Copyright © 2016年 zuoxunhudong. All rights reserved.
//

#import "UIScrollView+TARefreshControl.h"
#import <objc/runtime.h>
#import "TARefreshControlHeader.h"
#import "TARefreshControlFooter.h"
#import "TARefreshBaseViewPrivate.h"
#import "RefreshControlState.h"

@implementation UIScrollView (TARefreshControl)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"UIScrollView");
        Method m1 = class_getInstanceMethod(cls, NSSelectorFromString(@"_scrollViewWillBeginDragging"));
        Method m2 = class_getInstanceMethod(cls, NSSelectorFromString(@"ta_scrollViewWillBeginDragging"));
        method_exchangeImplementations(m1, m2);
        
        Method m3 = class_getInstanceMethod(cls, NSSelectorFromString(@"_scrollViewWillEndDraggingWithDeceleration:"));
        Method m4 = class_getInstanceMethod(cls, NSSelectorFromString(@"ta_scrollViewWillEndDraggingWithDeceleration:"));
        method_exchangeImplementations(m3, m4);
        
        Method m5 = class_getInstanceMethod(cls, NSSelectorFromString(@"_notifyDidScroll"));
        Method m6 = class_getInstanceMethod(cls, NSSelectorFromString(@"ta_notifyDidScroll"));
        method_exchangeImplementations(m5, m6);
        
//        unsigned int count = 0;
//        Method *list = class_copyMethodList(cls, &count);
//        for (int i = 0; i < count; i++) {
//            NSLog(@"%@", NSStringFromSelector(method_getName(list[i])));
//        }
//        free(list);
    });
}

#pragma mark - public

- (void)endRefreshing {
    if (self.ta_refreshControlState.state == Refreshing) {
        [self.ta_refreshControlState call:RefreshEndedEvent];
    } else if (self.ta_refreshControlState.state == LoadingMore) {
        [self.ta_refreshControlState call:LoadMoreEndedEvent];
    }
}

#pragma mark - private

- (void)beginRefreshing {
    if (!self.ta_header) {
        return;
    }
    [self setContentOffset:CGPointMake(self.contentOffset.x, -[self ta_thresholdY])];
    [self.ta_refreshControlState call:RefreshBeganEvent];
}

- (void)ta_scrollViewWillBeginDragging {
    [self ta_scrollViewWillBeginDragging];
    if ([self ta_needRefreshControl]) {
        [self setTa_lastContentOffset:self.contentOffset];
    }
}

- (void)ta_scrollViewWillEndDraggingWithDeceleration:(BOOL)decelerate {
    if ([self ta_needRefreshControl]) {
        CGFloat threshold = [self ta_thresholdY];
        CGFloat loadMoreThreshold = [self ta_LoadMoreThresholdY];
        if (-self.contentOffset.y >= threshold) {
            [self.ta_refreshControlState call:RefreshBeganEvent];
        } else if (-self.contentOffset.y > loadMoreThreshold && -self.contentOffset.y < threshold) {
            [self.ta_refreshControlState call:BackToNormalEvent];
        }
    }
    [self ta_scrollViewWillEndDraggingWithDeceleration:decelerate];
}

- (void)ta_notifyDidScroll {
    [self ta_notifyDidScroll];
//    NSLog(@"offset:%@", NSStringFromUIEdgeInsets(self.contentInset));
    if ([self ta_needRefreshControl]) {
        CGFloat threshold = [self ta_thresholdY];
        CGFloat loadMoreThreshold = [self ta_LoadMoreThresholdY];
        CGPoint contentOffset = self.contentOffset;
        CGPoint lastContentOffset = [self ta_lastContentOffset];
        CGFloat deltaY = contentOffset.y - lastContentOffset.y;
        
        if (self.isDragging && self.ta_header) {
            if (deltaY < 0 && -contentOffset.y > self.contentInset.top && -contentOffset.y < threshold) {
                [self.ta_refreshControlState call:PullingDownBeganEvent];
            } else if (deltaY < 0 && -contentOffset.y > threshold && self.ta_refreshControlState.state != WaitingRefresh) {
                [self.ta_refreshControlState call:WaitingRefreshEvent];
            } else if (deltaY > 0 && -contentOffset.y <= threshold) {
                [self.ta_refreshControlState call:PullbackB4ThresholdEvent];
            } else if (deltaY > 0 && -contentOffset.y >= threshold) {
                [self.ta_refreshControlState call:PullbackAftThresholdEvent];
            }
            
            if (self.ta_refreshControlState.state != Refreshing &&
                -contentOffset.y >= self.contentInset.top)
            {
                self.ta_header.progress = 1.0 * (-contentOffset.y - self.contentInset.top) / self.ta_header.offsetForRefresh;
            }
        }
        
        if (self.ta_footer && !self.ta_footer.hidden) {
            if (deltaY > 0 && contentOffset.y >= loadMoreThreshold && lastContentOffset.y <= loadMoreThreshold) {
                [self.ta_refreshControlState call:WillLoadMoreEvent];
            } else if (deltaY > 0 && contentOffset.y > loadMoreThreshold && self.ta_refreshControlState.state != LoadingMore) {
                [self.ta_refreshControlState call:LoadMoreBeganEvent];
            }
            if (self.ta_refreshControlState.state != LoadingMore &&
                -contentOffset.y <= self.contentInset.top)
            {
                self.ta_footer.progress = 1.0 * (contentOffset.y + self.contentInset.top) / self.ta_footer.offsetForRefresh;
            }
        }
        
        [self setTa_lastContentOffset:contentOffset];
    }
}

- (void)changeRefreshControlState {
    BOOL needed = self.ta_header || self.ta_footer;
    [self setTa_needRefreshControl:needed];
}

#pragma mark - setter, getter

- (BOOL)isRefreshing {
    return self.ta_refreshControlState.state == Refreshing;
}

- (BOOL)isLoadingMore {
    return self.ta_refreshControlState.state == LoadingMore;
}

- (CGFloat)ta_thresholdY {
    return self.contentInset.top + [self headerHeight];
}

- (CGFloat)ta_LoadMoreThresholdY {
    return self.contentSize.height + [self footerHeight] - CGRectGetHeight(self.frame);
}

- (CGFloat)headerHeight {
    return 60;
}

- (CGFloat)footerHeight {
    return 50;
}

- (RefreshControlState *)ta_refreshControlState {
    if (![self ta_needRefreshControl]) {
        NSLog(@"invalid!! why access the state");
        return nil;
    }
    RefreshControlState *state = objc_getAssociatedObject(self, _cmd);
    if (!state) {
        state = [RefreshControlState fanWithState:Normal];
        
        __weak typeof(self) weakSelf = self;
        FSMHandler PullingDownBeganHandler = ^{
            __strong typeof(weakSelf) self = weakSelf;
            NSLog(@"开始下拉刷新");
            [self.ta_header onBeforeCanRefresh];
            return PullToRefresh;
        };
        
        FSMHandler WaitingRefreshHandler = ^{
            __strong typeof(weakSelf) self = weakSelf;
            NSLog(@"可以下拉刷新了");
            [self.ta_header onCanRefresh];
            return WaitingRefresh;
        };
        
        FSMHandler PullbackB4ThresholdHandler = ^{
            __strong typeof(weakSelf) self = weakSelf;
            NSLog(@"不想进入刷新状态了");
            [self.ta_header onBeforeCanRefresh];
            return PullbackB4Threshold;
        };
        
        FSMHandler PullbackAftThresholdHandler = ^{
            __strong typeof(weakSelf) self = weakSelf;
            NSLog(@"撤销刷新,不想进入刷新状态了");
            [self.ta_header onCanRefresh];
            return PullbackAftThreshold;
        };
        
        FSMHandler BackToNormalHandler = ^{
            NSLog(@"撤销刷新,不想进入刷新状态了");
            return Normal;
        };
        
        __block UIEdgeInsets originalInsets = self.contentInset;
        FSMHandler RefreshBeganHandler = ^{
            __strong typeof(weakSelf) self = weakSelf;
            NSLog(@"进入刷新状态");
            originalInsets = self.contentInset;
            UIEdgeInsets insets = originalInsets;
            insets.top = [self ta_thresholdY];
            [self.ta_header executeRefreshBlock];
            [self.ta_header onRefreshing];
            
            CGFloat duration = 0.15;
            [UIView beginAnimations:@"beginRefresh" context:nil];
            [UIView setAnimationDuration:duration];
            self.contentInset = insets;
            [UIView commitAnimations];
            
            [self.ta_header _setProgress:1.0 withDuration:duration];
            return Refreshing;
        };
        
        FSMHandler RefreshEndedHandler = ^{
            __strong typeof(weakSelf) self = weakSelf;
            NSLog(@"结束刷新状态");
            [self.ta_header onRefreshEnd];
            CGFloat duration = 0.25;
            [UIView beginAnimations:@"endRefresh" context:nil];
            [UIView setAnimationDuration:duration];
            self.contentInset = originalInsets;
            self.ta_header.progress = 0;
            [UIView commitAnimations];
            
            return RefreshEnd;
        };
        
        FSMHandler WillLoadMoreHandler = ^{
            NSLog(@"即将加载分页数据");
            return WillLoadMore;
        };
        
        FSMHandler LoadingMoreHandler = ^{
            __strong typeof(weakSelf) self = weakSelf;
            NSLog(@"进入加载更多数据");
            [self.ta_footer onLoading];
            originalInsets = self.contentInset;
            UIEdgeInsets insets = originalInsets;
            insets.bottom += self.footerHeight;
            [self.ta_footer executeRefreshBlock];
          
            CGFloat duration = 0.15;
            [UIView beginAnimations:@"beginLoadMore" context:nil];
            [UIView setAnimationDuration:duration];
            self.contentInset = insets;
            self.ta_footer.progress = 1.0;
            [UIView commitAnimations];
            
            return LoadingMore;
        };
        
        FSMHandler LoadMoreEndedHandler = ^{
            __strong typeof(weakSelf) self = weakSelf;
            NSLog(@"加载分页数据结束");
            [self.ta_footer onLoadingEnd];
            CGFloat duration = 0.25;
            [UIView beginAnimations:@"endLoadMore" context:nil];
            [UIView setAnimationDuration:duration];
            self.contentInset = originalInsets;
            self.ta_footer.progress = 0;
            [UIView commitAnimations];
            
            return LoadMoreEnded;
        };
        
        [state addHandler:PullingDownBeganHandler state:Normal event:PullingDownBeganEvent];
        [state addHandler:WaitingRefreshHandler state:Normal event:WaitingRefreshEvent]; // 可能跳过中间态直接变化
        [state addHandler:RefreshBeganHandler state:Normal event:RefreshBeganEvent]; // 可能由代码控制直接进入刷新
        [state addHandler:WillLoadMoreHandler state:Normal event:WillLoadMoreEvent]; // load more
        
        [state addHandler:BackToNormalHandler state:PullToRefresh event:BackToNormalEvent]; // 松手
        [state addHandler:WaitingRefreshHandler state:PullToRefresh event:WaitingRefreshEvent];
        [state addHandler:PullbackB4ThresholdHandler state:PullToRefresh event:PullbackB4ThresholdEvent];
        
        [state addHandler:BackToNormalHandler state:PullbackB4Threshold event:BackToNormalEvent];
        [state addHandler:PullingDownBeganHandler state:PullbackB4Threshold event:PullingDownBeganEvent];
        [state addHandler:WaitingRefreshHandler state:PullbackB4Threshold event:WaitingRefreshEvent]; //[!] 防止临界状态
        [state addHandler:WillLoadMoreHandler state:PullbackB4Threshold event:WillLoadMoreEvent];
        
        [state addHandler:PullbackAftThresholdHandler state:WaitingRefresh event:PullbackAftThresholdEvent];
        [state addHandler:PullbackB4ThresholdHandler state:WaitingRefresh event:PullbackB4ThresholdEvent]; //[!] 防止临界状态
        [state addHandler:RefreshBeganHandler state:WaitingRefresh event:RefreshBeganEvent];
        
        [state addHandler:WaitingRefreshHandler state:PullbackAftThreshold event:WaitingRefreshEvent];
        [state addHandler:PullbackB4ThresholdHandler state:PullbackAftThreshold event:PullbackB4ThresholdEvent];
        [state addHandler:RefreshBeganHandler state:PullbackAftThreshold event:RefreshBeganEvent];
        
        [state addHandler:RefreshEndedHandler state:Refreshing event:RefreshEndedEvent];
        
        [state addHandler:LoadingMoreHandler state:WillLoadMore event:LoadMoreBeganEvent];
        
        [state addHandler:LoadMoreEndedHandler state:LoadingMore event:LoadMoreEndedEvent];
        
        [state addHandler:PullingDownBeganHandler state:LoadMoreEnded event:PullingDownBeganEvent]; // 一直下拉到开始刷新
        [state addHandler:WillLoadMoreHandler state:LoadMoreEnded event:WillLoadMoreEvent]; // 继续加载分页
        
        [self setTa_refreshControlState:state];
    }
    return state;
}

- (void)setTa_refreshControlState:(RefreshControlState *)ta_refreshControlState {
    objc_setAssociatedObject(self, @selector(ta_refreshControlState), ta_refreshControlState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TARefreshControlHeader *)ta_header {
    return objc_getAssociatedObject(self, @selector(ta_header));
}

- (void)setTa_header:(TARefreshControlHeader *)ta_header {
    if (self.ta_header == ta_header) {
        return;
    }
    [self.ta_header removeFromSuperview];
    if (ta_header) {
        [self addSubview:ta_header];
        ta_header.scrollView = self;
    }
    objc_setAssociatedObject(self, @selector(ta_header), ta_header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self changeRefreshControlState];
}

- (TARefreshControlFooter *)ta_footer {
    return objc_getAssociatedObject(self, @selector(ta_footer));
}

- (void)setTa_footer:(TARefreshControlFooter *)ta_footer {
    if (self.ta_footer == ta_footer) {
        return;
    }
    [self.ta_footer removeFromSuperview];
    if (ta_footer) {
        [self addSubview:ta_footer];
        ta_footer.scrollView = self;
    }
    objc_setAssociatedObject(self, @selector(ta_footer), ta_footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self changeRefreshControlState];
}

- (TARefreshDisposable *)ta_disposable {
    return objc_getAssociatedObject(self, @selector(ta_disposable));
}

- (void)setTa_disposable:(TARefreshDisposable *)ta_disposable {
    objc_setAssociatedObject(self, @selector(ta_disposable), ta_disposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// MARK: - control refresh
- (BOOL)ta_needRefreshControl {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTa_needRefreshControl:(BOOL)needed {
    objc_setAssociatedObject(self, @selector(ta_needRefreshControl), @(needed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)ta_lastContentOffset {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setTa_lastContentOffset:(CGPoint)offset {
    objc_setAssociatedObject(self, @selector(ta_lastContentOffset), [NSValue valueWithCGPoint:offset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

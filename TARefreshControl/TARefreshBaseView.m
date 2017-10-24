//
//  TARefreshBaseView.m
//  TARefreshControlDemo
//
//  Created by zoxuner on 16/7/30.
//  Copyright © 2016年 zuoxunhudong. All rights reserved.
//

#import "TARefreshBaseView.h"
#import "TARefreshBaseViewPrivate.h"
#import "TARefreshDisposable.h"
#import "UIScrollView+TARefreshControl.h"

@interface TARefreshBaseView ()
/** disposable*/
@property (nonatomic, strong) TARefreshDisposable *disposable;
@end

@implementation TARefreshBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutSubviewsFrame];
}

- (void)dealloc {
    NSLog(@"%d, %s", __LINE__, __PRETTY_FUNCTION__);
}

- (void)setupUI {
    [self addOwnViews];
    [self setNeedsLayout];
}

- (void)addOwnViews {}

- (void)layoutSubviewsFrame {}

#pragma mark - private

#pragma mark - setter

#pragma mark - refresh

+ (instancetype)refreshViewWithBlock:(TARefreshBlock)block {
    return [[self.class alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(TARefreshBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)executeRefreshBlock {
    !self.block ?: self.block();
}

- (void)beginRefreshing {}

- (void)endRefreshing {
    [self.scrollView endRefreshing];
}

- (void)setProgress:(CGFloat)progress {
    CGFloat oldValue = _progress;
    _progress = progress;
    [self onRefreshProgressUpdated:progress oldValue:oldValue];
}

- (void)_setProgress:(CGFloat)progress withDuration:(CGFloat)duration {
    _progress = progress;
    [self setProgress:progress withDuration:duration completed:nil];
}

- (void)setProgress:(CGFloat)progress withDuration:(CGFloat)duration completed:(void (^)(void))completed {
    
}

- (void)onRefreshProgressUpdated:(CGFloat)progress oldValue:(CGFloat)oldValue { }

- (CGFloat)offsetForRefresh { return MAXFLOAT; }

@end

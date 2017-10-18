//
//  NSSafeTimer.m
//  safeTimerDemo
//
//  Created by 熊先提 on 15/7/15.
//  Copyright © 2015年 熊先提. All rights reserved.
//

#import "NSSafeTimer.h"

typedef void(^SafeTimerHandle)(void);

@interface NSSafeTimer ()

@property (nonatomic, weak)     id      target;
@property (nonatomic, assign)   SEL     selector;
@property (nonatomic, weak)     NSTimer *timer;
@property (assign, nonatomic)   BOOL isCouting;

@end


static NSSafeTimer *_safeTimer;
@implementation NSSafeTimer
{
    SafeTimerHandle _timerhandle;
}
@synthesize timer = _timer;




- (NSTimer *)timer{
    return _timer;
}

+ (NSSafeTimer *)scheduledSafeTimerWithTimeInterval:(NSTimeInterval)time
                                             target:(id)aTarget
                                           selector:(SEL)aSelector
                                           userInfo:(id)userInfo
                                            repeats:(BOOL)yesOrNo
{
    _safeTimer = [[NSSafeTimer alloc]init];
    [_safeTimer scheduledTimerWithTimeInterval:time
                                        target:aTarget
                                      selector:aSelector
                                      userInfo:userInfo
                                       repeats:yesOrNo];
    _safeTimer.enableCountLimit = YES;
    return _safeTimer;
}
- (void)scheduledTimerWithTimeInterval:(NSTimeInterval)time
                                target:(id)aTarget
                              selector:(SEL)aSelector
                              userInfo:(id)userInfo
                               repeats:(BOOL)yesOrNo
{
    
    self.target = aTarget;
    self.selector = aSelector;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:time
                                                  target:self
                                                selector:@selector(fire:)
                                                userInfo:userInfo
                                                 repeats:yesOrNo];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self setFireDate:[NSDate distantFuture]];
}

- (void)setFireDate:(NSDate *)fireDate
{
    _fireDate = fireDate;
    self.isCouting = NO;
    [self.timer setFireDate:fireDate];
}

- (void)invalidate
{
    [self.timer invalidate];
}

- (void) fire:(NSTimer *)timer {
    if(self.target) {
        if (self.enableCountLimit) {
            if (!self.isCouting) {
                self.isCouting = YES;
                return;
            }
        }
        if (self.target && self.selector && [self.target respondsToSelector:self.selector]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.target performSelector:self.selector withObject:timer.userInfo];
            });
        }
    } else {
        [self.timer invalidate];
        self.timer = nil;
        _safeTimer = nil;
    }
}
- (void)dealloc
{
    self.target = nil;
    NSLog(@"%@ dealloc",self);
}

@end

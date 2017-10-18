//
//  NSSafeTimer.h
//  safeTimerDemo
//
//  Created by 熊先提 on 15/7/15.
//  Copyright © 2015年 熊先提. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSafeTimer : NSObject

@property (nonatomic, weak)     NSDate  *fireDate;
@property (assign, nonatomic)   BOOL enableCountLimit;

+ (NSSafeTimer *)scheduledSafeTimerWithTimeInterval:(NSTimeInterval)time
                                             target:(id)aTarget
                                           selector:(SEL)aSelector
                                           userInfo:(id)userInfo
                                            repeats:(BOOL)yesOrNo;


- (void)invalidate;
- (NSTimer *)timer;
@end

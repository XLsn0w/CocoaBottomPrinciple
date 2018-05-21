//
//  CircularReference.m
//  CocoaBottomPrinciple
//
//  Created by ginlong on 2018/5/21.
//  Copyright © 2018年 ginlong. All rights reserved.
//

#import "CircularReference.h"

///1. NSTimer
///2. block    weakSelf
///3. delegate weak

@interface CircularReference () {
    NSTimer *_timer;
}
@end

@implementation CircularReference

- (instancetype)init {
    if (self = [super init]) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    }
    return  self;
}

- (void)handleTimer:(id)sender {
    NSLog(@"%@ say: Hi!", [self class]);
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    NSLog(@"[Friend class] is dealloced");
}

@end

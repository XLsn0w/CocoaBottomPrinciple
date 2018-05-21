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

/*
 即使在你的block代码中没有显式地出现"self"，也会出现循环引用！只要你在block里用到了self所拥有的东西！但对于这种情况，我们无法通过加__weak声明或者__block声明去禁止block对self进行强引用或者强制增加引用计数。但我们可以通过其他指针来避免循环引用(多谢xq_120的提醒)，具体是这么做的：
 
 
 __weak typeof(self) weakSelf = self;
 self.blkA = ^{
 __strong typeof(weakSelf) strongSelf = weakSelf;//加一下强引用，避免weakSelf被释放掉
 NSLog(@"%@", strongSelf->_xxView); //不会导致循环引用.
 
 
 self->_timer
 
 
 };
 
 */

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

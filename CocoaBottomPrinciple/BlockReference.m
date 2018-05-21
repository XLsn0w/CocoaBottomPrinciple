//
//  BlockReference.m
//  CocoaBottomPrinciple
//
//  Created by ginlong on 2018/5/21.
//  Copyright © 2018年 ginlong. All rights reserved.
//

#import "BlockReference.h"

@implementation BlockReference {
    NSArray *arr;
}

@end

/*
 循环引用的原因
 
 众所周知，ARC下用block会产生循环引用的问题，造成泄露的原因是啥呢？
 
 最简单的例子，如下面代码：
 
 [self.teacher requestData:^(NSData *data) {
 self.name = @"case";
 }];
 
 此种情况是最常见的循环引用导致的内存泄露了，
 在这里，self强引用了teacher,
 teacher又强引用了一个block，
 而该block在回调时又调用了self，会导致该block又强引用了self，造成了一个保留环，最终导致self无法释放。
 
 self -> teacher -> block -> self
 
 一般性的解决方案

 __weak typeof(self) weakSelf = self;
 [self.teacher requestData:^(NSData *data) {
 typeof(weakSelf) strongSelf = weakSelf;
 strongSelf.name = @"case";
 }];
 
 通过__weak的修饰，先把self弱引用（默认是强引用，实际上self是有个隐藏的__strong修饰的），然后在block回调里用weakSelf，这样就会打破保留环，从而避免了循环引用，如下：
 
 self -> teacher -> block -> weakSelf
 
 PS：一般会在block回调里再强引用一下weakSelf（typeof(weakSelf) strongSelf = weakSelf;），因为__weak修饰的都是存在栈内，可能随时会被系统释放，造成后面调用weakSelf时weakSelf可能已经是nil了，后面用weakSelf调用任何代码都是无效的。
 
 */

//
//  GCDViewController.m
//  CocoaBottomPrinciple
//
//  Created by ginlong on 2018/5/22.
//  Copyright © 2018年 ginlong. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController () {
    dispatch_semaphore_t semaphoreLock;
}
/* 剩余火车票数 */
@property (nonatomic, assign) int ticketSurplusCount;

@property (nonatomic, assign) dispatch_semaphore_t semaphore_t;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* 任务+队列 相关方法 */
    
    //    同步执行 + 并发队列
    //    [self syncConcurrent];
    
    //    异步执行 + 并发队列
    //    [self asyncConcurrent];
    
    //    同步执行 + 串行队列
    //    [self syncSerial];
    
    //    异步执行 + 串行队列
    //    [self asyncSerial];
    
    //    同步执行 + 主队列（主线程调用）
    //    [self syncMain];
    
    //    同步执行 + 主队列（其他线程调用）
    //    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    
    //    异步执行 + 主队列
    //    [self asyncMain];
    
    /* GCD 线程间通信 */
    
    //    [self communication];
    
    
    /* GCD 其他方法 */
    
    //    栅栏方法 dispatch_barrier_async
    //    [self barrier];
    
    //    延时执行方法 dispatch_after
    //    [self after];
    
    //    一次性代码（只执行一次）dispatch_once
    //    [self once];
    
    //    快速迭代方法 dispatch_apply
    //    [self apply];
    
    /* 队列组 gropu */
    //    队列组 dispatch_group_notify
    //    [self groupNotify];
    
    //    队列组 dispatch_group_wait
    //    [self groupWait];
    
    //    队列组 dispatch_group_enter、dispatch_group_leave
    //    [self groupEnterAndLeave];
    
    /* 信号量 dispatch_semaphore */
    //    semaphore 线程同步
    //    [self semaphoreSync];
    
    //    semaphore 线程安全
    //    非线程安全：不使用 semaphore
    //    [self initTicketStatusNotSave];
    
    //    线程安全：使用 semaphore 加锁
    //    [self initTicketStatusSave];
}

#pragma mark - 任务+队列 相关方法

/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent {
    NSLog(@"currentThread---%@", [NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncConcurrent---end");
}

/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncConcurrent---end");
}

/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncSerial---end");
}

/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncSerial---end");
}

/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMain {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncMain---end");
}

/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncMain---end");
}


#pragma mark - 线程间通信

/**
 * 线程间通信
 */
- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 异步追加任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}


#pragma mark - GCD 其他相关方法

/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}

/**
 * 延时执行方法 dispatch_after
 */
- (void)after {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}

/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
    });
}

/**
 * 快速迭代方法 dispatch_apply
 */
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}

#pragma mark - dispatch_group 队列组

/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
}

/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
    
}

/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)groupEnterAndLeave
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
    
    //    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    //    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //
    //    NSLog(@"group---end");
}

#pragma mark - semaphore 线程同步

/**
 * semaphore 线程同步
 */
- (void)semaphoreSync {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %zd",number);
}

#pragma mark - semaphore 线程安全
/**
 * 非线程安全：不使用 semaphore
 * 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
 */
- (void)initTicketStatusNotSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
}

/**
 * 售卖火车票(非线程安全)
 */
- (void)saleTicketNotSafe {
    while (1) {
        
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            break;
        }
        
    }
}

/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        
        // 相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///切圆角优化
///利用CoreGraphics画一个圆形上下文，然后把图片绘制上去，得到一个圆形的图片，达到切圆角的目的。
- (UIImage *)drawCircleImage:(UIImage*)image {
    CGFloat side = MIN(image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    CGFloat marginX = -(image.size.width - side) * 0.5;
    CGFloat marginY = -(image.size.height - side) * 0.5;
    [image drawInRect:CGRectMake(marginX, marginY, image.size.width, image.size.height)];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/*

二、GCD的使用方法
1、使用步骤
first:使用create或者系统方法创建一个queue

second:使用dispatch_async(someQueue, ^{});执行多线程的block方法

third:在上面多线程的block相应位置调用dispatch_async(dispatch_get_main_queue(), ^{});回到主线程进行操作

fourth:如果queue时通过create创建的，使用dispatch_release(someQueue);进行释放


2、代码示例
dispatch_queue_t tempQueue = dispatch_queue_create("com.llz.gcd.temp", NULL);

dispatch_async(tempQueue,
               
               ^{
                   
                   //do something
                   
                   dispatch_async(dispatch_get_main_queue(),
                                  
                                  ^{
                                      
                                      //do someting
                                      
                                  });
                   
               });

dispatch_release(tempQueue);//因为是create出来的，所以需要release


三、GCD的其他方法
1、dispatch_after
dispatch_after://在一个时间段后向某个queue中添加一个block方法



dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)3*NSEC_PER_SEC);//可以获得一个距某个时间点相当时长的时间，第一个参数为开始时间，现在设置的为当前时间，第二个参数为时间流失的数值，现在是3s

dispatch_after(time, dispatch_get_main_queue(),
               
               ^{
                   
                   NSLog(@"hello");
                   
               });//使用dispatch_after方法，在time后向主线程队列添加一个block方法

注意:dispatch_after与performSelector:withObject:afterDelay:的区别，后者为相应时间后执行该方法；前者为相应时间后向队列添加方法，而这个方法并不一定立刻执行

2、dispatch_group_t
dispatch_group_t:多线程组，将一些queue，添加到这个中，可以实现监测这些queue全部完成的状态，如果为Serial就没有使用这个的必要了



dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//创建queue

dispatch_group_t group = dispatch_group_create();//创建group



dispatch_group_async(group, queue, ^{});//向group中添加queue及其block方法，第一个参数为组名，第二个参数为queue名，第三个参数为block方法

dispatch_group_async(group, queue, ^{});//向group中添加queue及其block方法

dispatch_group_async(group, queue, ^{});//向group中添加queue及其block方法

dispatch_group_async(group, queue, ^{});//向group中添加queue及其block方法



dispatch_group_wait(group, DISPATCH_TIME_FOREVER);//可以通过wait方法设置监测时间，现在设置的是永远，也能用dispatch_time_t进行特定时间的设定

dispatch_release(group);//因为是create出来的，所以需要release


3、dispatch_barrier_async
dispatch_barrier_async(someQueue, ^{}):用于在某些一些动作中插入一些动作，一般配合create出来的concurrent类型queue使用,Serial就没有使用这个的必要了



dispatch_queue_t queue = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT);



dispatch_async(queue, ^{});

dispatch_async(queue, ^{});

dispatch_async(queue, ^{});

dispatch_barrier_async(queue, ^{});//会将queue对应的block方法加入queue，并等此方法结束后再继续queue里的剩下block方法

dispatch_async(queue, ^{});

dispatch_async(queue, ^{});



dispatch_release(queue);//因为是create出来的，所以需要release


4、dispatch_sync


dispatch_sync(someQueue, ^{})与dispatch_barrier_sync(someQueue, ^{})同步运行，会死锁，但是不要用在MainThread或者在非concurrent的本身queue里面进行自己的sync

5、dispatch_apply
dispatch_apply(10, someQueue, ^{}):用于将某个block代码块按指定次数重复追加到queue中，并等待这些block全部执行完毕，所以推荐用在async中



NSArray *array = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];

dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

dispatch_async(queue,
               
               ^{
                   
                   dispatch_apply(array.count, queue, ^(size_t index)//会将数组的长度作为次数，将block代码块添加到queue中，并等待其中所有block执行完毕
                                  
                                  {
                                      
                                      NSLog(@"%@",[array objectAtIndex:index]);
                                      
                                  });
                   
               });


6、dispatch_suspend&dispatch_resume
dispatch_suspend(someQueue)&dispatch_resume(someQueue):用于将挂起时queue中尚未执行的处理停止以及继续开始

7、dispatch_semaphore_t
dispatch_semaphore_t:计数信号，为了更细分的保证不会造成程序的变量被同时访问



dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);



dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);//初始化semaphore的计数，并设最大为1

NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];



for(int i = 0;i<10000;i++)//在循环中如果不用semaphore，则async出来的线程们可能会同时访问array，造成异常

{
    
    dispatch_async(queue,
                   
                   ^{
                       
                       dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//第一个参数为技术信号，第二个参数为等待时间，现在是一直等待直到semaphore的值等于1
                       
                       
                       
                       [array addObject:[NSNumber numberWithInt:i]];//排他成功后，即semaphore等于1时，执行数组添加对象操作，同时将semaphore值变为0
                       
                       
                       
                       dispatch_semaphore_signal(semaphore);//将semaphore的值增为1
                       
                   });
    
}

dispatch_release(semaphore);//因为是create出来的，所以需要release


8、dispatch_once_t
dispatch_once_t:保证其block块在应用中只执行一次



+(GCDViewController *)sharedInstance {
    
    static GCDViewController *sharedManager;
    
    static dispatch_once_t onceToken;//通过这个onceToken使得下面的实例化只做一次
    
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[MyClass alloc] init];
        
    });
    
    
    
    return sharedManager;
    
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

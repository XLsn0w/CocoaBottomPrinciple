//
//  CocoaBottomPrinciple.swift
//  CocoaBottomPrinciple
//
//  Created by ginlong on 2018/5/17.
//  Copyright © 2018年 ginlong. All rights reserved.
//

import UIKit

class CocoaBottomPrinciple: NSObject {

}

/*
 SD、YY、AFN、MJ是怎么实现的
 
 1.入口 setImageWithURL:placeholderImage:options:
 会先把 placeholderImage 显示，然后 SDWebImageManager 根据 URL 开始处理图片。
 2.进入 SDWebImageManagerdownloadWithURL:delegate:options:userInfo:，
 交给 SDImageCache 从缓存查找图片是否已经下载 queryDiskCacheForKey:delegate:userInfo:.
 3.先从内存图片缓存查找是否有图片，
 如果内存中已经有图片缓存，SDImageCacheDelegate 回调 imageCache:didFindImage:forKey:userInfo: 到 SDWebImageManager。
 4.SDWebImageManagerDelegate 回调 webImageManager:didFinishWithImage:
 到 UIImageView+WebCache 等前端展示图片。
 5.如果内存缓存中没有，生成 NSInvocationOperation
 添加到队列开始从硬盘查找图片是否已经缓存。
 6.根据 URLKey 在硬盘缓存目录下尝试读取图片文件。
 这一步是在 NSOperation 进行的操作，所以回主线程进行结果回调 notifyDelegate:。
 7.如果上一操作从硬盘读取到了图片，将图片添加到内存缓存中
 （如果空闲内存过小，会先清空内存缓存）。
 SDImageCacheDelegate 回调 imageCache:didFindImage:forKey:userInfo:。
 进而回调展示图片。
 8.如果从硬盘缓存目录读取不到图片，
 说明所有缓存都不存在该图片，需要下载图片，
 回调 imageCache:didNotFindImageForKey:userInfo:。
 9.共享或重新生成一个下载器 SDWebImageDownloader 开始下载图片。
 10.图片下载由 NSURLConnection 来做，
 实现相关 delegate 来判断图片下载中、下载完成和下载失败。
 11.connection:didReceiveData: 中
 利用 ImageIO 做了按图片下载进度加载效果。
 12.connectionDidFinishLoading: 数据下载完成后交给 SDWebImageDecoder 做图片解码处理。
 13.图片解码处理在一个 NSOperationQueue 完成，
 不会拖慢主线程 UI。如果有需要对下载的图片进行二次处理，
 最好也在这里完成，效率会好很多。
 14.在主线程 notifyDelegateOnMainThreadWithInfo:
 宣告解码完成，
 imageDecoder:didFinishDecodingImage:userInfo
 回调给 SDWebImageDownloader。
 15.imageDownloader:didFinishWithImage:
 回调给 SDWebImageManager 告知图片下载完成。
 16.通知所有的 downloadDelegates 下载完成，
 回调给需要的地方展示图片。
 17.将图片保存到 SDImageCache 中，
 内存缓存和硬盘缓存同时保存。
 写文件到硬盘也在以单独 NSInvocationOperation 完成，
 避免拖慢主线程。
 18.SDImageCache 在初始化的时候会注册一些消息通知，
 在内存警告或退到后台的时候清理内存图片缓存
 应用结束的时候清理过期图片。
 19.SDWI 也提供了 UIButton+WebCache 和
 MKAnnotationView+WebCache，方便使用。
 20.SDWebImagePrefetcher 可以预先下载图片，
 方便后续使用。
 
 iOS编译
 
 不管是OC还是Swift，都是采用Clang作为编译器前端，LLVM(Low level vritual machine)作为编译器后端。
 
 Clang编译器前端
 
 编译器前端的任务是进行：语法分析，语义分析，生成中间代码(intermediate representation )。在这个过程中，会进行类型检查，如果发现错误或者警告会标注出来在哪一行。
 
LLVM编译器后端
 
 编译器后端会进行机器无关的代码优化，生成机器语言，并且进行机器相关的代码优化。iOS的编译过程，后端的处理如下
 
 执行一次XCode build的流程
 
 当你在XCode中，选择build的时候（快捷键command+B），会执行如下过程
 
 编译信息写入辅助文件，创建编译后的文件架构(name.app)
 
 处理文件打包信息，例如在debug环境下
 
 执行CocoaPod编译前脚本
 
 例如对于使用CocoaPod的工程会执行CheckPods Manifest.lock
 
 编译各个.m文件，使用CompileC和clang命令。
 
 编译各个.m文件，使用CompileC和clang命令。
 
 
 一：NSDictionary实现原理
 
 NSDictionary（字典）是使用hash表来实现key和value之间的映射和存储的
 
 方法：- (void)setObject:(id)anObject forKey:(id)aKey;
 
 Objective-C中的字典NSDictionary底层其实是一个哈希表
 
 
 二：哈希原理
 
 散列表（Hash table，也叫哈希表），是根据关键码值(Key value)而直接进行访问的数据结构。也就是说，它通过把关键码值映射到表中一个位置来访问记录，以加快查找的速度。这个映射函数叫做散列函数，存放记录的数组叫做散列表。
 
 给定表M，存在函数f(key)，对任意给定的关键字值key，代入函数后若能得到包含该关键字的记录在表中的地址，则称表M为哈希(Hash）表，函数f(key)为哈希(Hash) 函数。
 
 哈希概念:哈希表的本质是一个数组，数组中每一个元素称为一个箱子(bin)，箱子中存放的是键值对。
 
 
 Block本质是Objective-C对象，是NSObject的子类，可以接收消息。
 
 
 
 KVO基本原理：
 
 1.KVO是基于runtime机制实现的
 
 2.当某个类的属性对象第一次被观察时，系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的setter 方法。派生类在被重写的setter方法内实现真正的通知机制
 
 3.如果原类为Person，那么生成的派生类名为NSKVONotifying_Person
 
 4.每个类对象中都有一个isa指针指向当前类，当一个类对象的第一次被观察，那么系统会偷偷将isa指针指向动态生成的派生类，从而在给被监控属性赋值时执行的是派生类的setter方法
 
 5.键值观察通知依赖于NSObject 的两个方法: willChangeValueForKey: 和 didChangevlueForKey:；在一个被观察属性发生改变之前， willChangeValueForKey:一定会被调用，这就 会记录旧的值。而当改变发生后，didChangeValueForKey:会被调用，继而 observeValueForKey:ofObject:change:context: 也会被调用。
 
 
 KVO深入原理：
 
 1.Apple 使用了 isa 混写（isa-swizzling）来实现 KVO 。当观察对象A时，KVO机制动态创建一个新的名为：?NSKVONotifying_A的新类，该类继承自对象A的本类，且KVO为NSKVONotifying_A重写观察属性的setter?方法，setter?方法会负责在调用原?setter?方法之前和之后，通知所有观察对象属性值的更改情况。
 
 2.NSKVONotifying_A类剖析：在这个过程，被观察对象的 isa 指针从指向原来的A类，被KVO机制修改为指向系统新创建的子类 NSKVONotifying_A类，来实现当前类属性值改变的监听；
 
 3.所以当我们从应用层面上看来，完全没有意识到有新的类出现，这是系统“隐瞒”了对KVO的底层实现过程，让我们误以为还是原来的类。但是此时如果我们创建一个新的名为“NSKVONotifying_A”的类()，就会发现系统运行到注册KVO的那段代码时程序就崩溃，因为系统在注册监听的时候动态创建了名为NSKVONotifying_A的中间类，并指向这个中间类了。
 
 4.（isa 指针的作用：每个对象都有isa 指针，指向该对象的类，它告诉 Runtime 系统这个对象的类是什么。所以对象注册为观察者时，isa指针指向新子类，那么这个被观察的对象就神奇地变成新子类的对象（或实例）了。）?因而在该对象上对 setter 的调用就会调用已重写的 setter，从而激活键值通知机制。
 
 5.子类setter方法剖析：KVO的键值观察通知依赖于 NSObject 的两个方法:willChangeValueForKey:和 didChangevlueForKey:，在存取数值的前后分别调用2个方法： 被观察属性发生改变之前，willChangeValueForKey:被调用，通知系统该 keyPath?的属性值即将变更；当改变发生后， didChangeValueForKey: 被调用，通知系统该 keyPath?的属性值已经变更；之后，?observeValueForKey:ofObject:change:context: 也会被调用。且重写观察属性的setter?方法这种继承方式的注入是在运行时而不是编译时实现的。
 
 
 
 
 1.为什么说Objective-C是一门动态的语言？
 1.object-c类的类型和数据变量的类型都是在运行是确定的，而不是在编译时确定。例如：多态特性，我们可以使用父类指针来指向子类对象，并且可以用来调用子类的方法。运行时(runtime)特性,我们可以动态的添加方法，或者替换方法。
 
 2.讲一下MVC和MVVM，MVP？
 MVC:简单来说就是，逻辑、试图、数据进行分层，实现解耦。
 MVVM:是Model-View-ViewMode模式的简称。由视图(View)、视图模型(ViewModel)、模型(Model)三部分组成.比MVC更加释放控制器臃肿，将一部分逻辑(耗时，公共方法，网络请求等)和数据的处理等操作从控制器里面搬运到ViewModel中
 MVVM的特点：
 
 低耦合。View可以独立于Model变化和修改，一个ViewModel可以绑定到不同的View上，当View变化的时候Model可以不变，当Model变化的时候View也可以不变。
 可重用性。可以把一些视图的逻辑放在ViewModel里面，让很多View重用这段视图逻辑。
 独立开发。开发人员可以专注与业务逻辑和数据的开发(ViewModel)。设计人员可以专注于界面(View)的设计。
 可测试性。可以针对ViewModel来对界面(View)进行测试
 MVP: 类似MVVM
 
 3.为什么代理要用weak？代理的delegate和dataSource有什么区别？block和代理的区别?
 代理是使用weak来修饰的。1.使用weak是为了避免循环引用。2.当使用weak修饰的属性，当对象释放的时候，系统会对属性赋值nil,object-c有个特性就是对nil对象发送消息也就是调用方法，不会cash。
 delegate:传递的是事件(even)，代理可以让A对象通知B对象，我(A)发生的变化，前提B遵循了A的代理，并且实现了A的代理方法。
 dataSource: 传递的是数据。如果A对象声明了数据源，当我们创建A对象的时候，我们就该实现数据源，来告诉A，他所需要的一些数据。例如：tableView数据源方法，需要告诉它，我要实现几组cell，每组cell多少行cell，实现的cell什么样式，什么内容
 同样delegate和  dataSource,都是可以使用require和optional来修饰的。
 
 代理和Block的区别
 相同点：代理和Block大多是我们都可以用来做倒序传值的。我们都得注意避免循环引用。不然我们去使用代理还是Block的时候，都需要判断它们是否实现
 不同点：代理使用weak修饰，代理必须先声明方法。当我们调用代理的时候要判断是否已经实现。
 block：使用的是copy来修饰，block保存的是一段代码，其实也就是一个函数。并且可以自动捕捉自动变量，如果想修改此自动变量，还必须使用__block修饰。
 
 4.属性的实质是什么？包括哪几个部分？属性默认的关键字都有哪些？@dynamic关键字和@synthesize关键字是用来做什么的？
 属性是描述类的特征，也就是具备什么特性。三个部分，带下划线的成员变量，get、setter方法。
 默认关键字：readwrite，assign, atomic; -- 是针对基本类型(NSInteger, BOOL, NSUInteger, int, 等)
 但是针对引用类型, 默认:strong, readwrite, atomic （例如：NSString, NSArray, NSDictory等）
 @dynamic :修饰的属性，其getter和setter方法编译器是不会自动帮你生成。必须自己是实现的。
 @synthesize：修饰的属性，其getter和setter方法编译器是会自动帮你生成，不必自己实现。且指定与属性相对应的成员变量。
 
 5.属性的默认关键字是什么？
 默认关键字，基本数据： atomic,readwrite,assign
 普通的 OC 对象: atomic,readwrite,strong
 
 6.NSString为什么要用copy关键字，如果用strong会有什么问题？（注意：这里没有说用strong就一定不行。使用copy和strong是看情况而定的
 众所周知，我们知道，可变类型（NSMutableArray,NSMutableString等）是不可边类型(NSString,NSArray等)的子类，因为多态的原因，我们可以使用不可边类型去接受可变类型。
 1.当我们使用strong修饰A不可边类型的时候，并且使用B可变类型给A赋值，再去修改可变类型B值的时候，A所指向的值也会发生改变。引文strong只是让创建的对象引用计数器+1，并返回当前对象的内容地址，当我们修改B指向的内容的时候，A指向的内容也同样发生了改变，因为他们指向的内存地址是相同的,是一份内容。
 2.当我们使用copy修饰A不可边类型的时候，并且使用B可变类型给A赋值，再去修改可变类型B值的时候，A所指向的值不会发生改变。因为当时用copy的修饰的时候，会拷贝一份内容出来，并且返回指针给A，当我们修改B指向的内容的时候，A指向的内容是没有发生改变的。因为A指向的内存地址和B指向的内存地址是不相同的，是两份内容
 3.copy修饰不可边类型(NSString,NSArray等)的时候，且使用不可边类型进行赋值，表示浅拷贝，只拷贝一份指针，和strong修饰一样，当修饰的是可变类型（NSMutableArray,NSMutableString等）的时候，且使用可边类型进行赋值，表示深拷贝，直接拷贝新一份内容，到内存中。表示两份内容。
 
 image.png
 7.如何令自己所写的对象具有拷贝功能?
 如果想让自己的类具备copy方法，并返回不可边类型，必须遵循nscopying协议，并且实现
 - (id)copyWithZone:(NSZone *)zone
 如果让自己的类具备mutableCopy方法，并且放回可变类型，必须遵守NSMutableCopying，并实现- (id)mutableCopyWithZone:(nullable NSZone *)zone
 注意：再此说的copy对应不可边类型和mutableCopy对应不可边类型方法，都是遵从系统规则而已。如果你想实现自己的规则，也是可以的。
 
 8.可变集合类 和 不可变集合类的 copy 和 mutablecopy有什么区别？如果是集合是内容复制的话，集合里面的元素也是内容复制么？
 可变使用copy表示深拷贝，不可变集合类使用copy的时候是浅拷贝。
 可变集合类、不可边类型使用mutablecopy表示深拷贝
 当是浅拷贝的时候，容器的内容是没有复制的。如果是深拷贝的话，容器的内容都会收到一条copy消息，拷贝出新的内容，从新组成新的容器返回。
 
 9.为什么IBOutlet修饰的UIView也适用weak关键字？
 在xib或者Sb拖控件时，其实控件就加载到了父控件的subviews数组里面，进行了强引用，即使使用了weak，也不造成对象的释放。
 
 10.nonatomic和atomic的区别？atomic是绝对的线程安全么？为什么？如果不是，那应该如何实现？
 nonatomic:表示非原子，不安全，但是效率高。
 atomic：表示原子行，安全，但是效率低。
 atomic：不能绝对保证线程的安全，当多线程同时访问的时候，会造成线程不安全。可以使用线程锁来保证线程的安全。
 
 11.UICollectionView自定义layout如何实现？
 实现一个自定义layout的常规做法是继承UICollectionViewLayout类，然后重载下列方法：
 
 -(CGSize)collectionViewContentSize
 返回collectionView的内容的尺寸
 -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
 返回rect中的所有的元素的布局属性
 返回的是包含UICollectionViewLayoutAttributes的NSArray
 UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视    图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes：
 layoutAttributesForCellWithIndexPath:
 layoutAttributesForSupplementaryViewOfKind:withIndexPath:
 layoutAttributesForDecorationViewOfKind:withIndexPath:
 -(UICollectionViewLayoutAttributes )layoutAttributesForItemAtIndexPath:(NSIndexPath )indexPath
 返回对应于indexPath的位置的cell的布局属性
 -(UICollectionViewLayoutAttributes )layoutAttributesForSupplementaryViewOfKind:(NSString )kind atIndexPath:(NSIndexPath *)indexPath
 返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
 -(UICollectionViewLayoutAttributes * )layoutAttributesForDecorationViewOfKind:(NSString)decorationViewKind atIndexPath:(NSIndexPath )indexPath
 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
 -(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
 12.用StoryBoard开发界面有什么弊端？如何避免？
 使用简单逻辑页面的跳转是可以使用sb的，开发比较块。
 但是SB对于逻辑项目比较复杂的时候，开发起来比较慢。不适合多人合作开发；也不利于版本的梗系和后期的维护。使用sb在项目变异编译的时候，也都会直接加载到内存中，造成内存的浪费。
 可以使用xib来代替，编辑复杂逻辑界面时候可以使用纯码编写。
 
 13.进程和线程的区别？同步异步的区别？并行和并发的区别？
 进程：是具有一定独立功能的程序关于某个数据集合上的一次运行活动,进程是系统进行资源分配和调度的一个独立单位.
 线程：是进程的一个实体,是CPU调度和分派的基本单位,它是比进程更小的能独立运行的基本单位.线程自己基本上不拥有系统资源,只拥有一点在运行中必不可少的资源(如程序计数器,一组寄存器和栈),但是它可与同属一个进程的其他的线程共享进程所拥有的全部资源.
 同步：阻塞当前线程操作，不能开辟线程。
 异步：不阻碍线程继续操作，可以开辟线程来执行任务。
 并发：当有多个线程在操作时,如果系统只有一个CPU,则它根本不可能真正同时进行一个以上的线程，它只能把CPU运行时间划分成若干个时间段,再将时间 段分配给各个线程执行，在一个时间段的线程代码运行时，其它线程处于挂起状。.这种方式我们称之为并发(Concurrent)。
 并行：当系统有一个以上CPU时,则线程的操作有可能非并发。当一个CPU执行一个线程时，另一个CPU可以执行另一个线程，两个线程互不抢占CPU资源，可以同时进行，这种方式我们称之为并行(Parallel)。
 区别：并发和并行是即相似又有区别的两个概念，并行是指两个或者多个事件在同一时刻发生；而并发是指两个或多个事件在同一时间间隔内发生。在多道程序环境下，并发性是指在一段时间内宏观上有多个程序在同时运行，但在单处理机系统中，每一时刻却仅能有一道程序执行，故微观上这些程序只能是分时地交替执行。倘若在计算机系统中有多个处理机，则这些可以并发执行的程序便可被分配到多个处理机上，实现并行执行，即利用每个处理机来处理一个可并发执行的程序，这样，多个程序便可以同时执行。
 
 14.线程间通信？
 当使用dispath-async函数开辟线程执行任务的完成时，我们需要使用dispatch_async(dispatch_get_main_queue(), ^{ });函数会到主线程内刷新UI。并完成通信
 
 15.GCD的一些常用的函数？（group，barrier，信号量，线程同步）
 我们使用队列组来开辟线程时，队列组中的队列任务是并发，当所有的队列组中的所有任务完成时候，才可以调用队列组完成任务。
 
 /**创建自己的队列*/
 dispatch_queue_t dispatchQueue = dispatch_queue_create("ted.queue.next", DISPATCH_QUEUE_CONCURRENT);
 /**创建一个队列组*/
 dispatch_group_t dispatchGroup = dispatch_group_create();
 /**将队列任务添加到队列组中*/
 dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
 NSLog(@"dispatch-1");
 });
 /**将队列任务添加到队列组中*/
 dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
 NSLog(@"dspatch-2");
 });
 /**队列组完成调用函数*/
 dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
 NSLog(@"end");
 })
 barrier:表示栅栏，当在并发队列里面使用栅栏时候，栅栏之前的并发任务开始并发执行，执行完毕后，执行栅栏内的任务，等栅栏任务执行完毕后，再并发执行栅栏后的任务。
 
 dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
 dispatch_async(concurrentQueue, ^(){
 NSLog(@"dispatch-1");
 });
 dispatch_async(concurrentQueue, ^(){
 NSLog(@"dispatch-2");
 });
 dispatch_barrier_async(concurrentQueue, ^(){
 NSLog(@"dispatch-barrier");
 });
 dispatch_async(concurrentQueue, ^(){
 NSLog(@"dispatch-3");
 });
 dispatch_async(concurrentQueue, ^(){
 NSLog(@"dispatch-4");
 });
 信号量：Semaphore是通过‘计数’的方式来标识线程是否是等待或继续执行的。信号量
 
 dispatch_semaphore_create(int) // 创建一个信号，并初始化信号的计数大小
 /* 等待信号，并且判断信号量，如果信号量计数大于等于你创建时候的信号量的计数，就可以通过，继续执行，并且将你传入的信号计数减1，
 * 如果传入的信号计数小于你创建的计数，就表示等待，等待信号计数的变化
 *  如果等待的时间超过你传入的时间，也会继续下面操作
 *   第一个参数：semaphore 表示信号量
 *   第二个参数：表示等待的时间
 *    返回int 如果传入的信号计数大于等于你创建信号的计数时候，返回0.  反之，返回的不等于0
 */
 int result = dispatch_semaphore_wait(dispatch_semaphore_t  semaphore,time outTime);// 表示等待，也是阻碍线程
 // 表示将信号技术+1
 dispatch_semaphore_signl(dispatch_semaphore_t semaphore);
 实现线程的同步的方法：串行队列，分组，信号量。也是可以使用并发队列。
 
 //加入队列
 dispatch_async(concurrentQueue, ^{
 //1.先去网上下载图片
 dispatch_sync(concurrentQueue, ^{
 
 });
 //2.在主线程展示到界面里
 dispatch_sync(dispatch_get_main_queue(), ^{
 
 });
 });
 16.如何使用队列来避免资源抢夺？
 当我们使用多线程来访问同一个数据的时候，就有可能造成数据的不准确性。这个时候我么可以使用线程锁的来来绑定。也是可以使用串行队列来完成。如：fmdb就是使用FMDatabaseQueue，来解决多线程抢夺资源。
 
 17.数据持久化的几个方案（fmdb用没用过）
 持久化方案：
 plist,存储字典，数组比较好用
 preference：偏好设置，实质也是plist
 NSKeyedArchiver：归档，可以存储对象
 sqlite：数据库，经常使用第三方来操作，也就是fmdb
 coreData:也是数据库储存，苹果官方的
 
 18.说一下appdelegate的几个方法？从后台到前台调用了哪些方法？第一次启动调用了哪些方法？从前台到后台调用了哪些方法？
 1029210 (1).gif
 19.NSCache优于NSDictionary的几点？
 1.nscache 是可以自动释放内存的。
 2.nscache是线程安全的，我们可以在不同的线程中添加，删除和查询缓存中的对象。
 3.一个缓存对象不会拷贝key对象。
 
 20.知不知道Designated Initializer？使用它的时候有什么需要注意的问题？
 个人理解：初始化函数，如果你想自定义初始化函数时，也是必须要初始化父类，以来保证可以继承父类的一些方法或者属性。
 Designated Initializer
 
 21.实现description方法能取到什么效果？
 description是nsobject的一个实例的方法，返回的是一个nsstring。当我们使用nslog打印的时候，打印出来的一般都是对象的内存地址，如果我们实现description方法时，我们就可以使用nslog打印对象的时候，我们可以把它里面的属性值和内存地址一起打印出来.打印什么，就是看你写什么了。
 
 -(NSString *)description{
 NSString * string = [NSString stringWithFormat:@"<Person:内存地址:%p name = %@ age = %ld>",self,self.name,self.age];
 return string;
 }
 22.objc使用什么机制管理对象内存？
 使用内存管理计数器，来管理内存的。当内存管理计数器为0的时候，对象就会被释放。
 
 中级
 Block
 1.block的实质是什么？一共有几种block？都是什么情况下生成的？
 block：本质就是一个object-c对象.
 block:存储位置，可能分为3个地方：代码去，堆区、栈区（ARC情况下会自动拷贝到堆区，因此ARC下只能有两个地方：代码去、堆区）
 代码区：不访问栈区的变量（如局部变量），且不访问堆区的变量（alloc创建的对象），此时block存放在代码去。
 堆区：访问了处于栈区的变量，或者堆区的变量，此时block存放在堆区。–需要注意实际是放在栈区，在ARC情况下会自动拷贝到堆区，如果不是ARC则存放在栈区，所在函数执行完毕就回释放，想再外面调用需要用copy指向它，这样就拷贝到了堆区，strong属性不会拷贝、会造成野指针错区。
 
 2.为什么在默认情况下无法修改被block捕获的变量？ __block都做了什么？
 默认情况下，block里面的变量，拷贝进去的是变量的值，而不是指向变量的内存的指针。
 当使用__block修饰后的变量，拷贝到block里面的就是指向变量的指针，所以我们就可以修改变量的值。
 
 3.模拟一下循环引用的一个情况？block实现界面反向传值如何实现？
 Person *p = [[Person alloc]init];
 [p setPersonBlock:^(NSString *str) {
 p.name = str;
 }];
 Runtime
 1.objc在向一个对象发送消息时，发生了什么？
 根据对象的isa指针找到类对象id，在查询类对象里面的methodLists方法函数列表，如果没有在好到，在沿着superClass,寻找父类，再在父类methodLists方法列表里面查询，最终找到SEL,根据id和SEL确认IMP（指针函数）,在发送消息；
 
 3.什么时候会报unrecognized selector错误？iOS有哪些机制来避免走到这一步？
 当发送消息的时候，我们会根据类里面的methodLists列表去查询我们要动用的SEL,当查询不到的时候，我们会一直沿着父类查询，当最终查询不到的时候我们会报unrecognized selector错误
 当系统查询不到方法的时候，会调用+(BOOL)resolveInstanceMethod:(SEL)sel动态解释的方法来给我一次机会来添加，调用不到的方法。或者我们可以再次使用-(id)forwardingTargetForSelector:(SEL)aSelector重定向的方法来告诉系统，该调用什么方法，一来保证不会崩溃。
 
 4.能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？
 1.不能向编译后得到的类增加实例变量
 2.能向运行时创建的类中添加实例变量
 解释：
 1.编译后的类已经注册在runtime中,类结构体中的objc_ivar_list实例变量的链表和instance_size实例变量的内存大小已经确定,runtime会调用class_setvarlayout或class_setWeaklvarLayout来处理strong weak引用.所以不能向存在的类中添加实例变量
 2.运行时创建的类是可以添加实例变量,调用class_addIvar函数.但是的在调用objc_allocateClassPair之后,objc_registerClassPair之前,原因同上.
 
 5.runtime如何实现weak变量的自动置nil？
 runtime 对注册的类， 会进行布局，对于 weak 对象会放入一个 hash 表中。 用 weak 指向的对象内存地址作为 key，当此对象的引用计数为0的时候会 dealloc，假如 weak 指向的对象内存地址是a，那么就会以a为键， 在这个 weak 表中搜索，找到所有以a为键的 weak 对象，从而设置为 nil。
 
 6.给类添加一个属性后，在类结构体里哪些元素会发生变化？
 instance_size ：实例的内存大小
 objc_ivar_list *ivars:属性列表
 
 RunLoop
 1.runloop是来做什么的？runloop和线程有什么关系？主线程默认开启了runloop么？子线程呢？
 runloop:字面意思就是跑圈，其实也就是一个循环跑圈，用来处理线程里面的事件和消息。
 runloop和线程的关系：每个线程如果想继续运行，不被释放，就必须有一个runloop来不停的跑圈，以来处理线程里面的各个事件和消息。
 主线程默认是开启一个runloop。也就是这个runloop才能保证我们程序正常的运行。子线程是默认没有开始runloop的
 
 2.runloop的mode是用来做什么的？有几种mode？
 model:是runloop里面的模式，不同的模式下的runloop处理的事件和消息有一定的差别。
 系统默认注册了5个Mode:
 （1）kCFRunLoopDefaultMode: App的默认 Mode，通常主线程是在这个 Mode 下运行的。
 （2）UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
 （3）UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用。
 （4）GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到。
 （5）kCFRunLoopCommonModes: 这是一个占位的 Mode，没有实际作用。
 注意iOS 对以上5中model进行了封装
 NSDefaultRunLoopMode;
 NSRunLoopCommonModes
 
 3.为什么把NSTimer对象以NSDefaultRunLoopMode（kCFRunLoopDefaultMode）添加到主运行循环以后，滑动scrollview的时候NSTimer却不动了？
 nstime对象是在 NSDefaultRunLoopMode下面调用消息的，但是当我们滑动scrollview的时候，NSDefaultRunLoopMode模式就自动切换到UITrackingRunLoopMode模式下面，却不可以继续响应nstime发送的消息。所以如果想在滑动scrollview的情况下面还调用nstime的消息，我们可以把nsrunloop的模式更改为NSRunLoopCommonModes
 
 4.苹果是如何实现Autorelease Pool的？
 Autorelease Pool作用：缓存池，可以避免我们经常写relase的一种方式。其实就是延迟release，将创建的对象，添加到最近的autoreleasePool中，等到autoreleasePool作用域结束的时候，会将里面所有的对象的引用计数器-1.
 autorelease
 
 类结构
 1.isa指针？（对象的isa，类对象的isa，元类的isa都要说）
 在oc中，类也是对象，所属元类。所以经常说:万物皆对象
 
 对象的isa指针指向所属的类
 类的isa指针指向了所属的元类
 元类的isa指向了根元类，根元类指向了自己。
 
 AC17D0A0-CB2A-4C23-8430-4BC7A99571CE.png
 2.类方法和实例方法有什么区别？
 调用的方式不同，类方法必须使用类调用，在方法里面不能调用属性，类方法里面也必须调用类方法。存储在元类结构体里面的methodLists里面
 实例方法必须使用实例对象调用，可以在实例方法里面使用属性，实例方法也必须调用实例方法。存储在类结构体里面的methodLists里面
 
 3.介绍一下分类，能用分类做什么？内部是如何实现的？它为什么会覆盖掉原来的方法？
 category:我们可以给类或者系统类添加实例方法方法。我们添加的实例方法，会被动态的添加到类结构里面的methodList列表里面。categort
 
 4.运行时能增加成员变量么？能增加属性么？如果能，如何增加？如果不能，为什么？
 可以添加属性的，但必须我们实现它的getter和setter方法。但是没有添加带下滑线同名的成员变量
 但是我们使用runtime我们就可以实现添加成员变量方法如下
 
 - (void)setName:(NSString *)name {
 /**
 *  为某个类关联某个对象
 *
 *  @param object#> 要关联的对象 description#>
 *  @param key#>    要关联的属性key description#>
 *  @param value#>  你要关联的属性 description#>
 *  @param policy#> 添加的成员变量的修饰符 description#>
 */
 objc_setAssociatedObject(self, @selector(name), name,   OBJC_ASSOCIATION_COPY_NONATOMIC);
 }
 - (NSString *)name {
 /**
 *  获取到某个类的某个关联对象
 *
 *  @param object#> 关联的对象 description#>
 *  @param key#>    属性的key值 description#>
 */
 return objc_getAssociatedObject(self, @selector(name));
 }
 5.objc中向一个nil对象发送消息将会发生什么？（返回值是对象，是标量，结构体）
 • 如果一个方法返回值是一个对象，那么发送给nil的消息将返回0(nil)。例如：Person * motherInlaw = [ aPerson spouse] mother]; 如果spouse对象为nil，那么发送给nil的消息mother也将返回nil。
 • 如果方法返回值为指针类型，其指针大小为小于或者等于sizeof(void*)，float，double，long double 或者long long的整型标量，发送给nil的消息将返回0。
 • 如果方法返回值为结构体，正如在《Mac OS X ABI 函数调用指南》，发送给nil的消息将返回0。结构体中各个字段的值将都是0。其他的结构体数据类型将不是用0填充的。
 • 如果方法的返回值不是上述提到的几种情况，那么发送给nil的消息的返回值将是未定义的。
 
 详细解答
 
 高级
 1.UITableview的优化方法（缓存高度，异步绘制，减少层级，hide，避免离屏渲染）
 缓存高度：当我们创建frame模型的时候，计算出来cell的高度的时候，我们可以将cell的高度缓存到字典里面，以cell的indexpath和Identifier作为为key。
 
 NSString *key = [[HeightCache shareHeightCache] makeKeyWithIdentifier:@"YwywProductGradeCell" indexPath:indexPath];
 if ([[HeightCache shareHeightCache] existInCacheByKey:key]) {
 return [[HeightCache shareHeightCache] heightFromCacheWithKey:key];
 }else{
 YwywProductGradeModelFrame *modelFrame = self.gradeArray[indexPath.row];
 [[HeightCache shareHeightCache] cacheHieght:modelFrame.cellHight key:key];
 return modelFrame.cellHight;
 }
 异步绘制、减少层级:目前还不是很清楚
 hide:个人理解应该是hidden吧，把可能会用到的控件都创建出来，根据不同的情况去隐藏或者显示出来。
 避免离屏渲染：只要不是同时使用边框/边框颜色以及圆角的时候，都可以使用layer直接设置。不会造成离屏渲染。
 
 2.有没有用过运行时，用它都能做什么？（交换方法，创建类，给新创建的类增加方法，改变isa指针）
 交换方式：一般写在类的+(void)load方法里面
 
 /** 获取原始setBackgroundColor方法 */
 Method originalM = class_getInstanceMethod([self class], @selector(setBackgroundColor:));
 /** 获取自定义的pb_setBackgroundColor方法 */
 Method exchangeM = class_getInstanceMethod([self class], @selector(pb_setBackgroundColor:));
 /** 交换方法 */
 method_exchangeImplementations(originalM, exchangeM);
 创建类：
 Class MyClass = objc_allocateClassPair([NSObject class], "Person", 0);
 添加方法
 /**参数一、类名参数
 二、SEL 添加的方法名字参数
 三、IMP指针 (IMP就是Implementation的缩写，它是指向一个方法实现的指针，每一个方法都有一个对应的IMP)
 参数四、其中types参数为"i@:@“，按顺序分别表示：具体类型可参照[官方文档](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html)i 返回值类型int，若是v则表示void@ 参数id(self): SEL(_cmd)@ id(str)
 V@:表示返回值是void 带有SEL参数 （An object (whether statically typed or typed id)）
 */
 class_addMethod(Person, @selector(addMethodForMyClass:), (IMP)addMethodForMyClass, "V@:");
 添加实例变量
 /**参数一、类名参数
 二、属性名称参数
 三、开辟字节长度参数
 四、对其方式参数
 五、参数类型 “@” 官方解释 An object (whether statically typed or typed id) （对象 静态类型或者id类型） 具体类型可参照[官方文档](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html)return: BOOL 是否添加成功
 */
 BOOL isSuccess = class_addIvar(Person, "name", sizeof(NSString *), 0, "@");
 isSuccess?NSLog(@"添加变量成功"):NSLog(@"添加变量失败");
 3.看过哪些第三方框架的源码？都是如何实现的？（如果没有，问一下多图下载的设计）
 4.SDWebImage的缓存策略？
 sd加载一张图片的时候，会先在内存里面查找是否有这张图片，如果没有会根据图片的md5(url)后的名称去沙盒里面去寻找，是否有这张图片，如果没有会开辟线程去下载，下载完毕后加载到imageview上面，并md(url)为名称缓存到沙盒里面。
 
 5.AFN为什么添加一条常驻线程？
 AFN 目的：就是开辟线程请求网络数据。如果没有常住线程的话，就会每次请求网络就去开辟线程，完成之后销毁开辟线程，这样就造成资源的浪费，开辟一条常住线程，就可以避免这种浪费，我们可以在每次的网络请求都添加到这条线程。
 
 6.KVO的使用？实现原理？（为什么要创建子类来实现）
 kvo：键值观察，根据键对应的值的变化，来调用方法。
 注册观察者：addObserver:forKeyPath:options:context:
 实现观察者：observeValueForKeyPath:ofObject:change:context:
 移除观察者：removeObserver:forKeyPath:(对象销毁，必须移除观察者)
 注意
 使用kvo监听A对象的时候，监听的本质不是这个A对象，而是系统创建的一个中间对象NSKVONotifying_A并继承A对象，并且A对象的isa指针指向的也不是A的类，而是这个NSKVONotifying_A对象
 kvo详解
 kvo详解2
 
 7.KVC的使用？实现原理？（KVC拿到key以后，是如何赋值的？知不知道集合操作符，能不能访问私有属性，能不能直接访问_ivar）
 kvc：键值赋值，使用最多的即使字典转模型。利用runtime获取对象的所有成员变量， 在根据kvc键值赋值，进行字典转模型
 setValue: forKey: 只查找本类里面的属性
 setValue: forKeyPath：会查找本类里面属性，没有会继续查找父类里面属性。
 kvc详解
 
 项目
 1.有已经上线的项目么？
 2.项目里哪个部分是你完成的？（找一个亮点问一下如何实现的）
 3.开发过程中遇到过什么困难，是如何解决的？
 4.遇到一个问题完全不能理解的时候，是如何帮助自己理解的？举个例子？
 5.有看书的习惯么？最近看的一本是什么书？有什么心得？
 6.有没有使用一些笔记软件？会在多平台同步以及多渠道采集么？（如果没有，问一下是如何复习知识的）
 7.有没有使用清单类，日历类的软件？（如果没有，问一下是如何安排，计划任务的）
 8.平常看博客么？有没有自己写过？（如果写，有哪些收获？如果没有写，问一下不写的原因）
 

 
 
 
 
 
 
 
 
 
 
 
 
 */


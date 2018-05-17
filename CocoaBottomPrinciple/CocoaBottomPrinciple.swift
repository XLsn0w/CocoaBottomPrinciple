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
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */


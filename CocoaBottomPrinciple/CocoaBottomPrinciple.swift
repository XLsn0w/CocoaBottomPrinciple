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
 
 
 
 
 
 */


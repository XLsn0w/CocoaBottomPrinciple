//
//  CopyProperty.h
//  CocoaBottomPrinciple
//
//  Created by ginlong on 2018/5/21.
//  Copyright © 2018年 ginlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CopyProperty : NSObject

@property (nonatomic, strong) NSString *name;    ///这个可变对象在外部被修改了,那么会影响该属性.
@property (nonatomic, copy)   NSString *nameCopy;///外部修改不影响

@end

/*
 
 因为父类指针可以指向子类对象,使用 copy 的目的是为了让本对象的属性不受外界影响,
 使用 copy 无论给我传入是一个可变对象还是不可对象,我本身持有的就是一个不可变的副本.
 如果我们使用是 strong ,那么这个属性就有可能指向一个可变对象,如果这个可变对象在外部被修改了,那么会影响该属性.
 
 copy 此特质所表达的所属关系与 strong 类似。然而设置方法并不保留新值，而是将其“拷贝” (copy)。
 当属性类型为 NSString 时，经常用此特质来保护其封装性，因为传递给设置方法的新值有可能指向一个 NSMutableString 类的实例。
 这个类是 NSString 的子类，表示一种可修改其值的字符串，此时若是不拷贝字符串，那么设置完属性之后，字符串的值就可能会在对象不知情的情况下遭人更改。
 所以，这时就要拷贝一份“不可变” (immutable)的字符串，确保对象中的字符串值不会无意间变动。
 只要实现属性所用的对象是“可变的” (mutable)，就应该在设置新属性值时拷贝一份。

 */

///如果对UIView设置了圆角的话，圆角部分会离屏渲染，离屏渲染的前提是位图发生了形变

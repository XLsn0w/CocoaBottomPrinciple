//
//  BlockReference.h
//  CocoaBottomPrinciple
//
//  Created by ginlong on 2018/5/21.
//  Copyright © 2018年 ginlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockReference : NSObject

@end

///block是存档在栈中，可能被随时回收，通过copy操作可以使其在堆中保留一份, 相当于一直强引用着,
///因此如果block中用到self时, 需要将其弱化, 通过__weak或者__unsafe_unretained.

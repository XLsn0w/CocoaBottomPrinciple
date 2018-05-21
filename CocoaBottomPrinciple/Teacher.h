

#import <Foundation/Foundation.h>

typedef void(^XLBlock)(NSData *data);

@interface Teacher : NSObject

@property (nonatomic, copy) void(^case6Block)();


- (void)requestData:(void(^)(NSData *data))block;

- (void)requestData2:(XLBlock)block;

- (void)callCase6BlackEvent;

@end



#import "SecondViewController.h"
#import "Teacher.h"

@interface SecondViewController ()

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) Teacher *teacher;

@end

@implementation SecondViewController

- (void)dealloc
{
    NSLog(@"==== dealloc ====");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _teacher = [[Teacher alloc] init];
}

#pragma mark -

//情况一：不泄露
- (void)case1
{
    NSLog(@"case 1 Click");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.name = @"case 1";
    });
}

//情况二：不泄露
- (void)case2
{
    NSLog(@"case 2 Click");
    __weak typeof(self) weakSelf = self;
    [self.teacher requestData:^(NSData *data) {
        typeof(weakSelf) strongSelf = weakSelf;
       strongSelf.name = @"case 2";
    }];
}

//情况三：泄漏
- (void)case3
{
    NSLog(@"case 3 Click");
    [self.teacher requestData:^(NSData *data) {
        self.name = @"case 3";
    }];
}

//情况四：不泄露
- (void)case4
{
    NSLog(@"case 4 Click");
    [self.teacher requestData:^(NSData *data) {
        self.name = @"case 4";
        self.teacher = nil;
    }];
    
    [self.teacher requestData2:^(NSData *data) {
        
    }];
}

//情况五：不泄露
- (void)case5 {
    NSLog(@"case 5 Click");
    Teacher *t = [[Teacher alloc] init];
    [t requestData:^(NSData *data) {
        self.name = @"case 5";
    }];
}

//情况六：不泄露
- (void)case6
{
    NSLog(@"case 6 Click");
    [self.teacher callCase6BlackEvent];
    self.teacher.case6Block = ^(NSData *data) {
        self.name = @"case 6";
        
        //下面两句代码任选其一即可防止内存泄漏，self.teacher 或者 case6Block 置为空都可以打破 retain cycle
        self.teacher = nil;
//        self.teacher.case6Block = nil;
    };
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

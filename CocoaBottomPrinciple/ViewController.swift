//
//  ViewController.swift
//  CocoaBottomPrinciple
//
//  Created by ginlong on 2018/5/17.
//  Copyright © 2018年 ginlong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for i in 1...5 {// ... 三个点表示序列 即 1到5的序列（1，2，3，4，5）也可以说是1-5
            print(i)
        }
        
        for i in 0 ..< 5 { //从0开始到小于5
            print("i=\(i)")
        }
        
        /*
         Swift 中的闭包有很多优化的地方
         1 根据上下文推断参数和返回值的类型
         2 从单行表达式闭包中隐式返回 可以省略return
         3 可以使用简化的参数如 $0 $1 意为从0或者1开始
         4 提供了尾随闭包的语法
         */
        //语法   parameters参数 return 隐藏了
        //{(parameters) -> return type in
        //    parameters
        //}
        
        //最简单的闭包//省略in的
//        let b = {
//            print("这也是闭包")
//        }

        //用变量记录函数 (带参数的闭包)
        //带有参数的闭包
        //参数返回值 实现代码  {形参->返回值 in 代码}
        //带参数待返回值的闭包
        let countBlock = {(num1:Int, num2:Int) -> Int in
            return num1+num2;
        }
        let count1 = countBlock(2,3)
        print(count1)
        
        var tuple : (String, Array) = ("小明",[90,87,88.5,95,78])
//        var o: (String, Array) = ("xx", ['1', '2', '2'])
        
        
        var i = 10;

        let block = {(name : String, age : Int) in
      
            i = 90
        }
        
        block("11", 3)
        
        print(i)
        
       var isShow:Bool = false;
        isShow = true

        guard isShow else {
            print("xxx")
            return
        }
        
        var h = 0
        
        repeat {
            
           h+=1
            
            print(h)
            
        } while h < 10
        


        defer {
            print("defer")
        }
        
        
        let houseAnimals : Set = ["?","?"]
        let farmAnimals: Set = ["?","?","?","?","?"]
        let cityAnimals: Set = ["?","?"]
        
        func min<T: Comparable>(_ a: T, _ b: T) -> T {
            return a < b ? a: b
        }
        //这里一定要遵守 Comparable 协议，因为并不是所有的类型都具有“可比性”
        
        
        let intArray = [1, 3, 5]
        
        let filterArr = intArray.filter {
            return $0 > 1
        }
        print(filterArr)
        
        //给局部变量加上__block关键字,则这个局部变量可以在block内部进行修改。
       
        /*
         
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"=================1");
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"=================2");
                });
            NSLog(@"=================3");
            });
        NSLog(@"==========阻塞主线程");
        while (1) {
        }
        NSLog(@"========2==阻塞主线程");
         
        */
        
        DispatchQueue.main.async {

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

/*

 iOS基础算法相关知识
 
 continue : 跳出此次循环,直接下一循环
 break : 跳出整个循环
 return: 跳出函数
 简单插入排序
 将某一元素插入到一个有序排列的数组中,要求插入元素后数组依然有序
 
 思路:
 1- 元素A依次对比数组元素
 2- 如果元素A>当前数组元素,跳出此次循环,元素A再去对比数组下一个元素
 3- 如果元素A==当前数组元素,直接终止循环
 4- 如果元素A<当前数组元素,则插入元素A并终止循环
 
 #pragma mark - 简单插入排序
 -(void)function
 {
 NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"1",@"5",@"8",@"9",@"12", nil];
 
 int element = 6;
 
 for (int i = 0; i < arr.count; i++)
 {
 if (element > [arr[i] intValue])
 {
 NSLog(@"元素大于数组中元素%@,继续循环",arr[i]);
 continue;
 }
 else if(element == [arr[i] intValue])
 {
 NSLog(@"元素等于数组元素%@,终止循环",arr[i]);
 break;
 }
 else
 {
 [arr insertObject:[NSString stringWithFormat:@"%d",element] atIndex:i];
 break;
 }
 }
 
 NSLog(@"循环结束后的数组内容为%@",arr);
 }
 插入排序
 将一个数据插入到已经排好序的有序数据中，从而得到一个新的、个数加一的有序数据
 
 实现思路(升序):
 1- 对于一组数据5,3,2,6,1,7,4
 2- 先排列好前两个数"3,5",将2插入到前面排好的有序数列中去,变为"2,3,5"
 3- 再将6插入到"2,3,5"中,依次插入即可
 
 #pragma mark - 插入排序
 -(void)function
 {
 NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"5",@"3",@"2",@"6",@"1",@"7",@"4",nil];
 
 for (int i = 1; i < arr.count; i ++)
 {
 int temp = [arr[i] intValue];
 
 for (int j = i - 1; j >= 0 && temp < [arr[j] intValue]; j --)
 {
 NSLog(@"循环时,temp值是%d,arr[j]是%d",temp,[arr[j] intValue]);
 arr[j + 1] = arr[j];
 arr[j] = [NSNumber numberWithInt:temp];
 NSLog(@"循环时,数组是%@",arr);
 }
 
 
 }
 NSLog(@"插入排序后：%@",arr);
 }
 
 冒泡排序
 可使用冒泡排序对一些数据进行升序或降序排列
 
 冒泡使用思路(升序):
 1- 按顺序比较,1与2比较,2与3比较,3与4....
 2- 如果1大于2,则交换,2与3同理....则这样对比循环一圈下来,最大的数就被放到了最后
 3- 除了最后一个数,其他继续比较
 4- 直到全部比较完成
 
 所以,需要两层for循环,第一层for循环决定了对比循环的圈数,(第一圈后,决定了最后一个数,第二圈后,决定了后两个数,下次圈循环时,这些数不需要再对比),第二层for循环,是相邻元素的对比,按大小将两个元素交换位置即可.
 
 #pragma mark - 冒泡排序/升序
 -(void)function
 {
 NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"5",@"3",@"6",@"2",@"1",@"7",@"4",nil];
 
 NSString *temp;
 for (int i = 0; i < arr.count - 1; i++)
 {
 for (int j = 0; j < arr.count - 1 - i; j++)
 {
 if ([arr[j] intValue] > [arr[j+1] intValue])
 {
 temp = arr[j];
 arr[j] = arr[j+1];
 arr[j+1] = temp;
 }
 }
 
 }
 NSLog(@"循环结束后的数组内容是%@",arr);
 
 }
 选择排序
 每一次从待排序的数据元素中选出最小或最大的一个元素,存放在数组的起始位置,知道全部待排序的元素排完
 
 实现思路(升序):
 1- 将arr[0]与arr[1]数据对比,若arr[1]<arr[0],则互换位置,则arr[0]为arr[1]的元素
 2- 将arr[0]与arr[2]数据对比,注意:此时arr[0]变为原来arr[1]的数据,若arr[2]<arr[0],也互换位置,arr[0]为arr[2]的元素
 3- 经过上面一轮对比,则最小的元素被放在了arr[0]的位置
 4- 下一圈再对比时,从arr[1]开始对比
 
 所以,需要两个for循环,第一个for循环决定了循环的圈数,第二个for循环进行对比,交换位置
 
 #pragma mark - 选择排序
 -(void)function
 {
 NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"5",@"3",@"6",@"2",@"1",@"7",@"4",nil];
 for (int i = 0; i < arr.count; i ++)
 {
 for (int j = i + 1; j < arr.count; j ++)
 {
 NSLog(@"当前对比的两个数是%@,%@",arr[i],arr[j]);
 if ([arr[i] intValue] > [arr[j] intValue])
 {
 NSString *temp = arr[i];
 arr[i] = arr[j];
 arr[j] = temp;
 }
 NSLog(@"排序结果%@",arr);
 }
 }
 NSLog(@"选择排序完成后,数组内容为：%@",arr);
 }
 **"我的音乐"项目需求 : **
 将你喜欢的歌曲,添加到"我的歌单",防止重复添加,如果"我的歌单"中存在这首歌,则不予加入并提示用户,若"我的歌单"中不存在这首歌,则加入
 
 -(void)function
 {
 //初始化数组
 NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"userDefaultsArr"]];
 if( !arr )
 {
 arr = [[NSMutableArray alloc] init];
 }
 
 //将元素str加入数组,若数组无元素,直接加入即可,若数组有元素,需要一一对比,若相同则返回,都不相同则加入
 NSString *str = @"8";
 if(arr)
 {
 if(arr.count == 0)
 {
 [arr addObject:str];
 [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"userDefaultsArr"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 else
 {
 for (int i = 0; i < arr.count; i++)
 {
 if ([str isEqualToString:[arr objectAtIndex:i]])
 {
 NSLog(@"已存在");
 break;
 }
 if (i == arr.count - 1)
 {
 [arr addObject:str];
 [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"userDefaultsArr"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 
 }
 
 }
 
 NSLog(@"完后数组内容为%@",arr);
 }
 
 }
 
 **"我的音乐"项目需求 : **
 制作"历史记录"列表,"历史记录"是这个样子的,声明一个可变数组arr,存字典(歌曲名及播放次数)
 现在你听了歌曲A,数组为内容为@[@"A,1"]
 你听了歌曲B,数组内容为@[@"B,1",@"A,1"]
 你听了歌曲C,数组内容为@[@"C,1",@"B,1",@"A,1"]
 你又听了歌曲A,数组内容为@[@"A,2",@"C,1",@"B,1"]
 你又听了歌曲B,数组内容为@[@"B,2",@"A,2",@"C,1"]
 ......
 
 这个实现要配合UITableView才能看出结果
 假设你现在已有tableView,数据是从_contentArr数组中读取的,每点击cell时,将当前行的内容传给你的算法函数
 
 初始化代码:
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 //初始化数组,tableView内容
 _contentArr = [[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E", nil];
 
 //初始化历史记录数组
 _historyArr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"userDefaultsArr"]];
 if( !_historyArr )
 {
 _historyArr = [[NSMutableArray alloc] init];
 }
 }
 点击Cell时调算法函数
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 [self function:[_contentArr objectAtIndex:indexPath.row]];
 }
 下面是算法实现:
 
 #pragma mark - 算法
 - (void)function: (NSString *)str
 {
 //数组每个数据存的是字典,默认播放次数是1
 NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
 [dic setObject:str forKey:@"ID"];
 [dic setObject:@"1" forKey:@"Count"];
 //计算每个元素的播放次数
 int count;
 
 
 if(_historyArr)
 {
 //若数组为空,直接加入数组即可
 if(_historyArr.count == 0)
 {
 [_historyArr addObject:dic];
 }
 else
 {
 for (int i = 0; i < _historyArr.count; i++)
 {
 //遍历发现数组中有此元素,将此元素的播放次数加1,移除此元素,再将它放在数组第一个位置
 if ([str isEqualToString:[[_historyArr objectAtIndex:i] objectForKey:@"ID"]])
 {
 count = [[[_historyArr objectAtIndex:i] objectForKey:@"Count"] intValue];
 count = count + 1;
 [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"Count"];
 
 [_historyArr removeObjectAtIndex:i];
 [_historyArr insertObject:dic atIndex:0];
 break;
 }
 //遍历到最后一个元素,证明数组中无此元素,直接将此元素放到数组第一个元素即可
 if (i == _historyArr.count - 1)
 {
 [_historyArr insertObject:dic atIndex:0];
 break;
 }
 
 }
 
 }
 
 [[NSUserDefaults standardUserDefaults] setObject:_historyArr forKey:@"userDefaultsArr"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 NSLog(@"完后数组内容为%@",_historyArr);
 }
 
 }
 
 */

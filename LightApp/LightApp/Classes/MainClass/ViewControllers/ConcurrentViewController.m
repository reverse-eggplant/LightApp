//
//  ConcurrentViewController.m
//  LightApp
//
//  Created by malong on 14/11/21.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "ConcurrentViewController.h"

@interface ConcurrentViewController ()
{
    NSArray * imageUrls;
    
    UIScrollView * scrollView;
    
    NSLock * downLoadLock;  //锁
    
    NSMutableArray * images;
    
    int currentImageViewIndex;
}
@end

@implementation ConcurrentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(ScreenWidth*6, ScreenHeight);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    
    imageUrls = @[@"http://pic26.nipic.com/20130108/4860403_165747416000_2.jpg",
                  @"http://cdn.duitang.com/uploads/item/201204/23/20120423202003_ZknUN.jpeg",
                  @"http://img4.duitang.com/uploads/item/201201/28/20120128220111_TfU3w.jpg",
                  @"http://t1.fansimg.com/uploads2011/07/userid51090time20110727082406.jpg",
                  @"http://pic27.nipic.com/20130308/11807702_190835818000_2.jpg",
                  @"http://pic4.nipic.com/20090905/3320717_164433099824_2.jpg"];
    
    NSArray * colors = [NSArray arrayWithObjects:
                        [UIColor redColor],
                        [UIColor orangeColor],
                        [UIColor yellowColor],
                        [UIColor blueColor],
                        [UIColor greenColor],
                        [UIColor purpleColor], nil];
    images = [NSMutableArray array];
    
    for (int i = 0; i<imageUrls.count; i++) {
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*ScreenWidth, 0.0, ScreenWidth, ScreenHeight)];
        imageView.tag = 100+i;
        imageView.backgroundColor = colors[i];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        
    }
    
    
    
//    [self userNSThreadDownLoad];
//    [self showGCD];
    [self userNSOperationShow];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Block

//带参数的block
- (void)testBlock1{
    
    //声明可用block
    double (^distanceFromRateAndTime)(double rate, double time) = ^(double rate,double time){
        return rate*time; //创建并给block赋值
    };
    
    //调用block
    double dx = distanceFromRateAndTime(35, 1.5);
    NSLog(@"dx = %f",dx);
    
    
    NSString * (^getfullName)(NSString *) = ^(NSString * string){
        NSString * firstName = @"ma";
        return [NSString stringWithFormat:@"%@%@",firstName,string];
    };
    NSLog(@"name = %@",getfullName(@"long"));
    
}

//不带参数的block
- (void)testBlock2{
    
    double(^nocanshu)(void) = ^{
        return (double)(arc4random()%200);
    };
    
    NSLog(@"nocanshu = %f",nocanshu()*100);
    
};


/*
 *基于线程
 *NSThread 是 Objective-C 对线程的一个封装。通过封装，在Cocoa环境中，可以让代码看起来更加亲切。例如，开发者可以利用 NSThread 的一个子类来定义一个线程，在这个子类的中封装需要在后台线程运行的代码
 优点：NSThread 比GCD和NSOperationQueue两个轻量级
 缺点：需要自己管理线程的生命周期，线程同步。线程同步对数据的加锁会有一定的系统开销
 */
#pragma mark NSTHread

- (void)userNSThreadDownLoad
{
    downLoadLock = [[NSLock alloc]init];
    for (int i = 0; i< imageUrls.count; i++) {
        //创建多个NSThread子线程
        NSThread * imageDownLoaderThread = [[NSThread alloc]initWithTarget:self
                                                                  selector:@selector(downLoadImage:)
                                                                    object:imageUrls[i]];
        [imageDownLoaderThread setName:[NSString stringWithFormat:@"imageDownLoaderThread=====%d",i]];
        [imageDownLoaderThread start];
    }
    
}

#pragma mark 图片加载方法


- (void)downLoadImage:(NSString *)imageurl{
    
    if (downLoadLock) [downLoadLock lock];
    
    
    currentImageViewIndex = [imageUrls indexOfObject:imageurl];
    
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:
                              [NSURL URLWithString:
                               imageurl]];
    
    NSLog(@"imageurl= %@",imageurl);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"data = %ld",(unsigned long)data.length);
         UIImage * image = [UIImage imageWithData:data];

         [NSThread sleepForTimeInterval:0.1];
         //回到主线程刷新UI，属于线程间通信
         if (image) {
             [self performSelectorOnMainThread:@selector(showImageWithImage:) withObject:image waitUntilDone:YES];

         }
         
         DLog(@"%@",[[NSThread currentThread] name]);
         [downLoadLock unlock];
         
     }];

    
 
    
}

- (void)showImageWithImage:(UIImage *)image{
    
    UIImageView * imageView = (UIImageView *)VIEWWITHTAG(scrollView, 100+currentImageViewIndex);
    imageView.image = image;
    
}

/*
 *形式：基于队列
 *出处：为了让开发者更加容易的使用设备上的多核CPU,苹果在OSX 10.6和iOS4 中引入了Grand Central Dispatch（GCD）。
 *优点：通过GCD，开发者不用再直接跟线程打交道了，只需要向队列中添加代码块即可，GCD在后端管理着一个线程池。GCD不仅决定着你的代码块将在哪个线程被执行，它还根据可用的系统资源对这些线程进行管理。这样可以将开发者从线程管理的工作中解放出来，通过集中的管理线程，来缓解大量线程被创建的问题。
 *GCD 带来的另一个重要改变是，作为开发者可以将工作考虑为一个队列，而不是一堆线程，这种并行的抽象模型更容易掌握和使用.
 *重点：运行在主线程中的main queue；3 个不同优先级的后台队列，以及一个优先级更低的后台队列。在绝大多数情况下使用默认的优先级队列。
 *风险：如果执行的任务需要访问一些共享的资源，那么在不同优先级的队列中调度这些任务很快就会造成不可预期的行为。这样可能会引起程序的完全挂起，因为低优先级的任务阻塞了高优先级任务，使它不能被执行。
 */

- (void)showGCD
{
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (NSString * imageUrl in  imageUrls)
        dispatch_group_async(group, queue, ^{
            [self downLoadImageData:imageUrl];
        });



}

- (void)downLoadImageData:(NSString *)imageUrl{

    
    NSLog(@"\nindex = %d",[imageUrls indexOfObject:imageUrl]);


    
}




/*
 *基于队列
 *operation queue 是由GCD提供的一个队列模型的Cocoa抽象。GCD提供了更加底层的控制，而操作队列则在GCD之上实现了一些方便的功能，这些功能对于app的开发者来说通常是最好最安全的选择。

 *NSOperationQueue 有两种不同类型的队列：主队列和自定义队列。主队列运行在主线程之上，而自定义队列在后台执行。在两种类型中，这些队列所处理的任务都使用 NSOperation 的子类来表述。
 */
#pragma mark NSOperation和NSOperationQueue
//扩展阅读：http://blog.csdn.net/q199109106q/article/details/8566222
- (void)userNSOperationShow
{
    
    NSOperationQueue * operationQueue = [[NSOperationQueue alloc]init];
    NSMutableArray * ops = [NSMutableArray array];
    for (int i = 0; i< imageUrls.count; i++) {
        //创建多个NSInvocationOperation
        NSInvocationOperation * invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self
                                                                                          selector:@selector(showImageUrlLabel:)
                                                                                            object:imageUrls[i]];
        [invocationOperation setName:[NSString stringWithFormat:@"invocationOperation=====%d",i]];
        [ops addObject:invocationOperation];
        if (ops.count >= 2) {
            [invocationOperation addDependency:ops[i-1]]; //添加依赖关系
        }
    }
    [operationQueue addOperations:ops waitUntilFinished:NO];
    

    
    
}

- (void)showImageUrlLabel:(NSString *)imageUrl{
    DLog(@"currentImageViewIndex = %d",[imageUrls indexOfObject:imageUrl]);
    
}



@end

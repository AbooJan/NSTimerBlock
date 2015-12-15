//
//  TestVC.m
//  TestDemo601
//
//  Created by 钟宝健 on 15/12/14.
//  Copyright © 2015年 钟宝健. All rights reserved.
//

#import "TestVC.h"
#import "NSTimer+Block.h"

@interface TestVC ()
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, strong) UILabel *testLabel1;
@property (nonatomic, assign) NSInteger count1;

@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic, strong) UILabel *testLabel2;
@property (nonatomic, assign) NSInteger count2;

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testLabel1 = (UILabel *)[self.view viewWithTag:1001];
    self.testLabel2 = (UILabel *)[self.view viewWithTag:1002];
    
    // 会有循环引用问题示例，此时 dealloc 方法不会调用
//    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown1:) userInfo:nil repeats:YES];
    
    
    // 没有带值
    __weak __typeof(&*self) weakSelf = self;
    self.timer1 = [NSTimer bk_scheduledTimerWithTimeInterval:1.0 block:^{
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        [strongSelf countDown1:strongSelf.timer1];
        
    } repeats:YES];
    
    
    // 有带值
    self.timer2 = [NSTimer bk_scheduledTimerWithTimeInterval:1.0 block:^{
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        [strongSelf countDown2:strongSelf.timer2];
        
    } userInfo:@{@"name" : @"Swift"} repeats:YES];
    
}

- (void)countDown1:(NSTimer *)timer
{
    self.testLabel1.text = [NSString stringWithFormat:@"%lds", (long)self.count1];
    self.count1 ++;
}

- (void)countDown2:(NSTimer *)timer
{
    NSDictionary *userInfo = timer.userInfo;
    if (userInfo) {
        
        self.testLabel2.text = [NSString stringWithFormat:@"%@: %ld", userInfo[@"name"] ,(long)self.count2];
        
        self.count2 ++;
    }
}

- (void)dealloc
{
    [self.timer1 invalidate];
    self.timer1 = nil;
    
    [self.timer2 invalidate];
    self.timer2 = nil;
    
    NSLog(@"dealloc");
}




@end

# NSTimerBlock
NSTimer 内存泄露问题解决Demo，将原来的定时方法调用放到了block中执行，从而转移了target。

```
// 会有循环引用问题示例，此时 dealloc 方法不会调用
self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown1:) userInfo:nil repeats:YES];

// 问题解决方案
__weak __typeof(&*self) weakSelf = self;
self.timer2 = [NSTimer bk_scheduledTimerWithTimeInterval:1.0 block:^{

    __strong __typeof__(weakSelf) strongSelf = weakSelf;
      
    [strongSelf countDown2:strongSelf.timer2];
        
} userInfo:nil repeats:YES];

```

解决方案主要是将原来的定时执行方法放到block中。

NSTimer+Block 分类：
```
+ (NSTimer *)bk_scheduledTimerWithTimeInterval:(NSTimeInterval)time block:(void (^)())block userInfo:(id)userInfo repeats:(BOOL)repeats
{
    NSTimer *timer = [self scheduledTimerWithTimeInterval:time target:self selector:@selector(block_blockInvoke:) userInfo:userInfo repeats:repeats];
    timer.funcBlock = block;
    
    return timer;
}

+ (void)block_blockInvoke:(NSTimer *)timer
{
    void (^block)() = timer.funcBlock;
    if (block) {
        block();
    }
}

```


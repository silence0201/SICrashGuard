//
//  NSTimer+Proxy.m
//  SICrashGuard
//
//  Created by Silence on 2018/3/12.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SISwizzling.h"
#import "SIRecord.h"

@interface __SITimerProxy : NSObject

@property (nonatomic,weak) NSTimer *sourceTimer ;
@property (nonatomic,weak) id target ;
@property (nonatomic) SEL aSelector;

@property (nonatomic,strong) NSString *className;

@end

@implementation __SITimerProxy

// 用来转发Selector
- (void)trigger:(id)userinfo {
    id strongTarget = self.target;
    if (strongTarget && [strongTarget respondsToSelector:self.aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [strongTarget performSelector:self.aSelector withObject:userinfo];
#pragma clang diagnostic pop
    }else {
        // target已经销毁或者其他原因无法触发
        NSString *className = self.className;
        NSString *selName = NSStringFromSelector(self.aSelector);
        NSString *reason = [NSString stringWithFormat:@"[%@ %@],Timer:%@ 没有正确移除",className,selName,self.sourceTimer];
        [SIRecord recordFatalWithReason:reason errorType:SIGuardTypeTimer];
        
        NSTimer *sourceTimer = self.sourceTimer;
        if(sourceTimer){
            // 将timer移除RunLoop
            [sourceTimer invalidate];
        }
    }
}

@end

@interface NSTimer (__SITimerProxy)

@property (nonatomic,strong) __SITimerProxy *timerProxy;

@end

@implementation NSTimer (__SITimerProxy)

- (void)setTimerProxy:(__SITimerProxy *)timerProxy {
    objc_setAssociatedObject(self, @selector(timerProxy), timerProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (__SITimerProxy *)timerProxy {
    return objc_getAssociatedObject(self, _cmd);
}

@end

#pragma mark -- Hook Method

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

SIStaticHookClass(NSTimer, GuardTimer, NSTimer *, @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:),
                  (NSTimeInterval)ti , (id)aTarget, (SEL)aSelector, (id)userInfo, (BOOL)yesOrNo) {
    if (yesOrNo) {
        __SITimerProxy *proxy = [[__SITimerProxy alloc]init];
        proxy.target = aTarget;
        proxy.className = NSStringFromClass([aTarget class]);
        proxy.aSelector = aSelector;
        NSTimer *timer = SIHookOrgin(ti,proxy,@selector(trigger:),userInfo,yesOrNo);
        timer.timerProxy = proxy;
        proxy.sourceTimer = timer;
        return timer;
    }
    
    return SIHookOrgin(ti, aTarget, aSelector, userInfo, yesOrNo);
}

SIStaticHookEnd

SIStaticHookClass(NSTimer, GuardTimer, NSTimer *, @selector(timerWithTimeInterval:target:selector:userInfo:repeats:),
                  (NSTimeInterval)ti , (id)aTarget, (SEL)aSelector, (id)userInfo, (BOOL)yesOrNo) {
    if (yesOrNo) {
        __SITimerProxy *proxy = [[__SITimerProxy alloc]init];
        proxy.target = aTarget;
        proxy.aSelector = aSelector;
        NSTimer *timer = SIHookOrgin(ti,proxy,@selector(trigger:),userInfo,yesOrNo);
        timer.timerProxy = proxy;
        proxy.sourceTimer = timer;
        return timer;
    }
    
    return SIHookOrgin(ti, aTarget, aSelector, userInfo, yesOrNo);
}

SIStaticHookEnd

#pragma clang diagnostic pop

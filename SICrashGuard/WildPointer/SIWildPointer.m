//
//  SIWildPointer.m
//  SICrashGuard
//
//  Created by Silence on 2018/3/14.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SIWildPointer.h"
#import "SIDynamicObject.h"

@implementation SIWildPointerManager

+ (instancetype)manager {
    static SIWildPointerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SIWildPointerManager alloc]init];
    });
    
    return manager;
}

@end

@implementation SIWildPointerProxy

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    SIDynamicObject *obj = [SIDynamicObject shareInstance];
    [obj addFunc:aSelector];
    
    return [[SIDynamicObject class] instanceMethodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    // 报告错误
    
    // 转发invocation
    [anInvocation invokeWithTarget:[SIDynamicObject shareInstance]];
}



@end

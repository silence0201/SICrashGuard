//
//  NSNull+Guard.m
//  SICrashGuard
//
//  Created by Silence on 2018/3/12.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SISwizzling.h"

// NSNull数据Selector问题,常见于数据为空解析
// 实现原理,将其转发给Number,String,Array,Dictionary避免出现Unrecoginzed

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

SIStaticHookClass(NSNull, GuardNull, id, @selector(forwardingTargetForSelector:), (SEL) aSelector) {
    static NSArray *tmpObjs ;
    if (!tmpObjs) {
        tmpObjs = @[@"",@0,@[],@{}];
    }
    
    for (id tmpObj in tmpObjs) {
        if ([tmpObj respondsToSelector:aSelector]) {
            return tmpObj;
        }
    }
    
    return SIHookOrgin(aSelector);
}

SIStaticHookEnd

#pragma clang diagnostic pop

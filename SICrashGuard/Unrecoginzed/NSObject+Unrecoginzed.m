//
//  NSObject+Unrecoginzed.m
//  SICrashGuard
//
//  Created by Silence on 2018/3/10.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import <objc/runtime.h>
#import "SISwizzling.h"
#import "SIDynamicObject.h"

static inline BOOL IsSystemClass(Class clazz) {
    BOOL isSystem = NO;
    NSBundle *mainBundle = [NSBundle bundleForClass:clazz];
    if (mainBundle == [NSBundle mainBundle]) {
        isSystem = NO;
    }else {
        isSystem = YES;
    }
    return isSystem;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

SIStaticHookClass(NSObject, GuardUR, id, @selector(forwardingTargetForSelector:),(SEL)aSelector) {
    // 系统类不做处理
    if (IsSystemClass([self class])) {
        return SIHookOrgin(aSelector);
    }
    
    // 判断是否可以转为NSString或NSNumber
    if ([self isKindOfClass:[NSNumber class]] && [NSString instanceMethodForSelector:aSelector]) {
        NSNumber *number = (NSNumber *)self;
        NSString *str = [number stringValue];
        return str;
    }
    
    if ([self isKindOfClass:[NSString class]] && [NSNumber instanceMethodForSelector:aSelector]) {
        NSString *str = (NSString *)self;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        NSNumber *number = [formatter numberFromString:str];
        return number;
    }
    
    // 动态转发给动态对象
    BOOL aBool = [self respondsToSelector:aSelector];
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool || signatrue) {
        return SIHookOrgin(aSelector);
    } else {
        SIDynamicObject *obj = [SIDynamicObject shareInstance];
        obj.realClass = [self class];
        [obj addFunc:aSelector];
        return obj;
    }
}

SIStaticHookEnd

SIStaticHookMetaClass(NSObject, GuardUR, id, @selector(forwardingTargetForSelector:),(SEL)aSelector) {
    // 系统类不做处理
    if (IsSystemClass([self class])) {
        return SIHookOrgin(aSelector);
    }
    
    // 动态转发给动态对象
    BOOL aBool = [self respondsToSelector:aSelector];
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool || signatrue) {
        return SIHookOrgin(aSelector);
    } else {
        SIDynamicObject *obj = [SIDynamicObject shareInstance];
        obj.realClass = [self class];
        [[obj class] addClassFunc:aSelector];
        return obj;
    }
}

SIStaticHookEnd

#pragma clang diagnostic pop

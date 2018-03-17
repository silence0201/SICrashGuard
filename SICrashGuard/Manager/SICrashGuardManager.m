//
//  SICrashGuardManager.m
//  SICrashGuard
//
//  Created by Silence on 2018/3/17.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SICrashGuardManager.h"
#import "SISwizzling.h"
#import "SIWildPointer.h"
#import "NSObject+WildPointer.h"
#import "SIRecord.h"

@implementation SICrashGuardManager

+ (void)registerGuardExceptWildPointer {
    [self registerGuardType:SIGuardTypeExceptWildPointer];
}

+ (void)registerGuardType:(SIGuardType)types {
    if (types & SIGuardTypeNSNull) {
        [self registerNSNull];
    }
    if (types & SIGuardTypeContainer) {
        [self registerContainer];
    }
    if (types & SIGuardTypeUnrecognizedSelector) {
        [self registerUnrecognizedSelector];
    }
    if (types & SIGuardTypeKVO) {
        [self registerKVO];
    }
    if (types & SIGuardTypeNotification) {
        [self registerNotification];
    }
    if (types & SIGuardTypeTimer) {
        [self registerTimer];
    }
    if (types & SIGuardTypeMainUI) {
        [self registerMainUI];
    }
    if (types & SIGuardTypeWildPointer) {
        [self registerGuardWildPointer];
    }
}

+ (void)registerNSNull {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        guard_hook_load_group(SIForOCString(GuardNull));
    });
}

+ (void)registerContainer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        guard_hook_load_group(SIForOCString(GuardCont));
    });
}

+ (void)registerUnrecognizedSelector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        guard_hook_load_group(SIForOCString(GuardUR));
    });
}

+ (void)registerKVO {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        guard_hook_load_group(SIForOCString(GuardKVO));
    });
}

+ (void)registerNotification {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        guard_hook_load_group(SIForOCString(GuardNoti));
        BOOL ABOVE_IOS8  = (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO);
        if (!ABOVE_IOS8) {
            guard_hook_load_group(SIForOCString(GuardNoti));
        }
    });
}

+ (void)registerTimer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        guard_hook_load_group(SIForOCString(GuardTimer));
    });
}

+ (void)registerMainUI {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        guard_hook_load_group(SIForOCString(GuardUI));
    });
}

+ (void)registerGuardWildPointer {
    unsigned int outCount ;
    NSMutableArray *results = [NSMutableArray array];
    Class *classes = objc_copyClassList(&outCount);
    for (int i = 0 ; i < outCount ; i++) {
        [results addObject:NSStringFromClass(classes[i])];
    }
    free(classes);
    NSArray <NSString *> *allClassName = results.copy;
    [self registerWildPointerWithClassNames:allClassName];
}

+ (void)registerGuardWildPointerWithPrxfix:(NSString *)prefix {
    unsigned int outCount ;
    NSMutableArray *results = [NSMutableArray array];
    Class *classes = objc_copyClassList(&outCount);
    for (int i = 0 ; i < outCount ; i++) {
        NSString *className = NSStringFromClass(classes[i]);
        if ([className hasPrefix:prefix]) {
            [results addObject:NSStringFromClass(classes[i])];
        }
    }
    free(classes);
    NSArray <NSString *> *allClassName = results.copy;
    [self registerWildPointerWithClassNames:allClassName];
}

+ (void)registerWildPointerWithClassNames:(NSArray<NSString *> *)classNames {
    NSMutableArray *avaibleList = classNames.mutableCopy;
    for (NSString *className in classNames) {
        NSBundle *classBundle = [NSBundle bundleForClass:NSClassFromString(className)];
        if (classBundle != [NSBundle mainBundle]) {
            // 不对系统的类进行处理
            [avaibleList removeObject:className];
        }
    }
    [SIWildPointerManager manager].classArr = avaibleList;
    defaultSwizzlingOCMethod([NSObject class], NSSelectorFromString(@"dealloc"), @selector(si_wildPointer_dealloc));
}

+ (void)registerRecordHandler:(id<SIRecordProtocol>)record {
    [SIRecord registerRecordHandler:record];
}



@end

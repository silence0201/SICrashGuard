//
//  NSNotificationCenter+Remover.m
//  Demo
//
//  Created by Silence on 2018/3/10.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SISwizzling.h"

@interface __ObserverRemover : NSObject
@end

@implementation __ObserverRemover {
    __strong NSMutableArray *_centers;
    __unsafe_unretained id _obs;
}

- (instancetype)initWithObserver:(id)obs {
    if (self = [super init]) {
        _obs = obs;
        _centers = [NSMutableArray array];
    }
    return self;
}

- (void)addCenter:(NSNotificationCenter *)center {
    if (center) {
        [_centers addObject:center];
    }
}

- (void)dealloc {
    @autoreleasepool {
        for (NSNotificationCenter *center in _centers) {
            [center removeObserver:_obs];
        }
    }
}

@end

void addCenterForObserver(NSNotificationCenter *center,id obs) {
    __ObserverRemover *remover;
    static char removerKey ;
    @autoreleasepool {
        remover = objc_getAssociatedObject(obs, &removerKey);
        if (!remover) {
            remover = [[__ObserverRemover alloc] initWithObserver:obs];
            /// 与观察者绑定
            objc_setAssociatedObject(obs, &removerKey, remover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [remover addCenter:center];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

SIStaticHookClass(NSNotificationCenter, GuardNoti, void, @selector(addObserver:selector:name:object:), (id)obs, (SEL)cmd, (NSString *)name, (id)obj) {
    SIHookOrgin(obs,cmd,name,obj);
    addCenterForObserver(self, obs);
}

SIStaticHookEnd

typedef void(^SINotificationBlock)(NSNotification *note);

SIStaticHookClass(NSNotificationCenter, GuardNoti, id, @selector(addObserverForName:object:queue:usingBlock:),(NSString *)name,(id)obj,(NSOperationQueue *)queue,(SINotificationBlock)block) {
    id obs = SIHookOrgin(name,obj,queue,block);
    addCenterForObserver(self, obs);
    return obs;
}

SIStaticHookEnd

#pragma clang diagnostic pop

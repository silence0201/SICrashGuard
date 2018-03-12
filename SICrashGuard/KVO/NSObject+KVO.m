//
//  NSObject+KVO.m
//  Demo
//
//  Created by Silence on 2018/3/12.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SISwizzling.h"

static void(*__si_hook_orgin_function_removeObserver)(NSObject* self, SEL _cmd ,NSObject *observer ,NSString *keyPath) = ((void*)0);

@interface __SIKVOProxy : NSObject {
    __unsafe_unretained NSObject *_observed;
}

// {keyPath:[obj1,obj2]}
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *kvoInfoMap;

@end

@implementation __SIKVOProxy

- (instancetype)initWithObserverd:(NSObject *)observed {
    if (self = [super init]) {
        _observed = observed;
    }
    return self;
}

- (void)dealloc {
    @autoreleasepool {
        NSDictionary<NSString *,NSHashTable<NSObject *> *> *kvoInfos = self.kvoInfoMap.copy;
        for (NSString *keyPath in kvoInfos) {
            // 调用removeObserver:forKeyPath:
            __si_hook_orgin_function_removeObserver(_observed,@selector(removeObserver:forKeyPath:),self,keyPath);
        }
    }
}

- (NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *)kvoInfoMap {
    if (!_kvoInfoMap) {
        _kvoInfoMap = [NSMutableDictionary dictionary];
    }
    return _kvoInfoMap;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // 转发KVO监听
    NSHashTable<NSObject *> *os = self.kvoInfoMap[keyPath];
    for (NSObject *observer in os) {
        @try {
            [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        } @catch (NSException *exception) {
            
        }
    }
}

@end

#pragma mark -- KVOProxy Property

@interface NSObject (__SIKVOProxy)

@property (nonatomic,strong) __SIKVOProxy *kvoProxy;

@end

@implementation NSObject (__SIKVOProxy)

- (void)setKvoProxy:(__SIKVOProxy *)kvoProxy {
    // 使用强引用
    objc_setAssociatedObject(self, @selector(kvoProxy), kvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (__SIKVOProxy *)kvoProxy {
    return objc_getAssociatedObject(self, _cmd);
}

@end

#pragma mark -- Hook KVO

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

SIStaticHookClass(NSObject, GuardKVO, void, @selector(addObserver:selector:name:object:),(NSObject *)observer, (NSString *)keyPath,(NSKeyValueObservingOptions)options, (void *)context) {
    if(!self.kvoProxy) {
        self.kvoProxy = [[__SIKVOProxy alloc]initWithObserverd:observer];
    }
    
    NSHashTable<NSObject *> *os = self.kvoProxy.kvoInfoMap[keyPath];
    if (os.count == 0) {
        // NSPointerFunctionsWeakMemory:不会修改HashTable容器内对象元素的引用计数，并且对象释放后，会被自动移除
        os = [[NSHashTable alloc]initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
        [os addObject:observer];
        
        // 只需要第一次调用的时候调用原方法
        SIHookOrgin(self.kvoProxy,keyPath,options,context);
        
        self.kvoProxy.kvoInfoMap[keyPath] = os;
        return;
    }
    
    if ([os containsObject:observer]) {
        // 多次添加处理
        return;
    }
    
    [os addObject:observer];
}

SIStaticHookEnd

SIStaticHookClass(NSObject, GuardKVO, void, @selector(removeObserver:forKeyPath:),
                  (NSObject *)observer, (NSString *)keyPath) {
    NSHashTable<NSObject *> *os = self.kvoProxy.kvoInfoMap[keyPath];
    
    if (![os containsObject:observer]) {
        // 移除一个不存在的监听
        return;
    }
    
    [os removeObject:observer];
    
    // 当移除后没有监听者,调用原来的方法移除监听
    if (os.count == 0) {
        SIHookOrgin(self.kvoProxy,keyPath);
        [self.kvoProxy.kvoInfoMap removeObjectForKey:keyPath];
    }
}

// 用来保存原来的方法,以便其他地方调用
SIStaticHookEnd_SaveOri(__si_hook_orgin_function_removeObserver)

#pragma clang diagnostic pop



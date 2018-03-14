//
//  NSObject+WildPointer.m
//  Demo
//
//  Created by Silence on 2018/3/14.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "NSObject+WildPointer.h"
#import "SIWildPointer.h"
#import "SIDynamicObject.h"
#import <objc/runtime.h>
#import <list>

// 最多保留个数
static NSInteger const threshold = 50;

static std::list<id> undellocedList;

@implementation NSObject (WildPointer)

- (void)si_wildPointer_dealloc {
    Class selfClazz = object_getClass(self);
    
    BOOL needProtect = NO;
    for (NSString *className in [SIWildPointerManager manager].classArr) {
        Class clazz = objc_getClass([className UTF8String]);
        if (clazz == selfClazz) {
            needProtect = YES;
            break;
        }
    }
    
    // 如果需要添加也指针保护,不销毁对象,指向Proxy对象
    if (needProtect) {
        [SIDynamicObject shareInstance].realClass = selfClazz;
        objc_destructInstance(self);
        object_setClass(self, [SIWildPointerProxy class]);
        
        undellocedList.size();
        if (undellocedList.size() >= threshold) {
            id object = undellocedList.front();
            undellocedList.pop_front();
            free(object);
        }
        undellocedList.push_back(self);
    } else {
        [self si_wildPointer_dealloc];
    }
}

@end

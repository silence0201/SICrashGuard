//
//  NSDictionary+Guard.m
//  Demo
//
//  Created by Silence on 2018/3/14.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SISwizzling.h"

/*
===============================
NSDictionary->Methods On Protection:
1 @{nil:nil}
2、dictionaryWithObject:forKey：
3、dictionaryWithObjects:forKeys:
4、dictionaryWithObjects:forKeys:count:

===============================
NSMutableDictionary->Methods On Protection:
1、setObject:forKey:
2、removeObjectForKey:
*/

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

#pragma mark -- NSDictionary
SIStaticHookClass(NSDictionary, GuardCont, NSDictionary *, @selector(dictionaryWithObjects:forKeys:count:),
                  (const id *) objects, (const id<NSCopying> *) keys, (NSUInteger)cnt) {
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            // 错误处理
            continue;
        }
        newObjects[index] = objects[i];
        newkeys[index] = keys[i];
        index++;
    }
    
    return SIHookOrgin(newObjects, newkeys,index);
}
SIStaticHookEnd

#pragma mark -- NSMutableDictionary
SIStaticHookPrivateClass(__NSDictionaryM, NSMutableDictionary *, GuardCont, void, @selector(setObject:forKey:), (id)anObject, (id<NSCopying>)aKey ) {
    if (anObject && aKey) {
        SIHookOrgin(anObject,aKey);
    } else {
        // 错误处理
    }
    
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSDictionaryM, NSMutableDictionary *, ProtectCont, void, @selector(setObject:forKeyedSubscript:), (id)anObject, (id<NSCopying>)aKey) {
    if (anObject && aKey) {
        SIHookOrgin(anObject,aKey);
    }else {
        // 错误处理
    }
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSDictionaryM, NSMutableDictionary *, ProtectCont, void, @selector(removeObjectForKey:), (id<NSCopying>)aKey ){
    if (aKey) {
        SIHookOrgin(aKey);
    }else {
        // 错误处理
    }
}
SIStaticHookEnd

#pragma clang diagnostic pop


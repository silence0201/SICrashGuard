//
//  NSCache+Guard.m
//  SICrashGuard
//
//  Created by Silence on 2018/3/14.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SISwizzling.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

SIStaticHookClass(NSCache, GuardCont, void, @selector(setObject:forKey:), (id)obj, (id)key) {
    if (obj && key) {
        SIHookOrgin(obj,key);
    }
}
SIStaticHookEnd

SIStaticHookClass(NSCache, GuardCont, void, @selector(setObject:forKey:cost:), (id)obj, (id)key, (NSUInteger)g) {
    if (obj && key) {
        SIHookOrgin(obj,key,g);
    }
}
SIStaticHookEnd

SIStaticHookClass(NSCache, GuardCont, void, @selector(removeObjectForKey:), (id<NSCopying>)aKey) {
    if (aKey) {
        SIHookOrgin(aKey);
    }
}
SIStaticHookEnd

#pragma clang diagnostic pop

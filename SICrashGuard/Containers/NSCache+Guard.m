//
//  NSCache+Guard.m
//  Demo
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
    } else {
        // 错误处理
    }
}
SIStaticHookEnd

SIStaticHookClass(NSCache, GuardCont, void, @selector(setObject:forKey:cost:), (id)obj, (id)key, (NSUInteger)g) {
    if (obj && key) {
        SIHookOrgin(obj,key,g);
    } else {
        // 错误处理
    }
}
SIStaticHookEnd

#pragma clang diagnostic pop

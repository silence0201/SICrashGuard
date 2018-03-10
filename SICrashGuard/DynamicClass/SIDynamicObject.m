//
//  SIDynamicObject.m
//  Demo
//
//  Created by Silence on 2018/3/10.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SIDynamicObject.h"
#import <objc/runtime.h>

/// 所有的方法的默认实现
int dynamicFunction(id target, SEL cmd, ...) {
    return 0 ;
}

/// 添加方法
static BOOL __addMethod (Class clazz, SEL sel) {
    NSMutableString *selName = [NSMutableString stringWithString:NSStringFromSelector(sel)];
    int count = (int)[selName replaceOccurrencesOfString:@":"
                                              withString:@"_"
                                                 options:NSCaseInsensitiveSearch
                                                   range:NSMakeRange(0, selName.length)];
    NSMutableString *methodEncoding = [NSMutableString stringWithString:@"i@:"];
    for (int i = 0 ;i < count;i++) {
        [methodEncoding appendString:@"@"];
    }
    [SIDynamicObject shareInstance].realSEL = sel;
    return class_addMethod(clazz, sel, (IMP)dynamicFunction, [methodEncoding UTF8String]);
}

@implementation SIDynamicObject

+ (instancetype)shareInstance {
    static SIDynamicObject *singleton;
    if (!singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [SIDynamicObject new];
        });
    }
    return singleton;
}

- (BOOL)addFunc:(SEL)sel {
    return __addMethod([SIDynamicObject class], sel);
}

+ (BOOL)addClassFunc:(SEL)sel {
    Class metaClass = objc_getMetaClass(class_getName([SIDynamicObject class]));
    return __addMethod(metaClass, sel);
}

@end

//
//  NSArray+Guard.m
//  SICrashGuard
//
//  Created by Silence on 2018/3/13.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SISwizzling.h"

/*
===============================

NSArray->Methods On Protection:
1、@[nil]
2、objectAtIndex:

===============================

NSMutableArray->Methods On Protection:
0、arrayWithObjects:nil
1、objectAtIndex:
2、removeObjectAtIndex:
3、removeObjectsInRange:
4、removeObjectsAtIndexes:
5、insertObject:atIndex:
6、insertObjects:atIndexes:
7、addObject:nil
8、replaceObjectAtIndex:withObject:
9、replaceObjectsAtIndexes:withObjects:
10、replaceObjectsInRange:withObjectsFromArray:
 
*/

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

#pragma mark -- NSArray
SIStaticHookClass(NSArray, GuardCont, id, @selector(objectAtIndex:), (NSUInteger)index) {
    if (index >= self.count) return nil;
    return SIHookOrgin(index);
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSSingleObjectArrayI, NSArray *, GuardCont, id, @selector(objectAtIndex:), (NSUInteger)index) {
    if (index >= self.count) return nil;
    return SIHookOrgin(index);
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSArrayI, NSArray *, GuardCont, id, @selector(objectAtIndexedSubscript:), (NSUInteger)index) {
    if (index >= self.count) return nil;
    return SIHookOrgin(index);
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSArray0, NSArray *, GuardCont, id, @selector(objectAtIndex:), (NSUInteger)index) {
    if (index >= self.count) return nil;
    return SIHookOrgin(index);
}
SIStaticHookEnd

SIStaticHookPrivateMetaClass(__NSSingleObjectArrayI, NSArray *, GuardCont, NSArray *,
                             @selector(arrayWithObjects:count:), (const id *)objects, (NSUInteger)cnt) {
    NSUInteger index = 0;
    id _Nonnull objectsNew[cnt];
    for (int i = 0; i < cnt; i++) {
        id objc = objects[i];
        if (objc == nil) {
            continue;
        }
        objectsNew[index++] = objc;
    }
    return SIHookOrgin(objectsNew,index);
}
SIStaticHookEnd

SIStaticHookPrivateMetaClass(__NSArrayI, NSArray *, GuardCont, NSArray *, @selector(arrayWithObjects:count:),
                             (const id *)objects, (NSUInteger)cnt) {
    NSUInteger index = 0;
    id _Nonnull objectsNew[cnt];
    for (int i = 0; i < cnt; i++) {
        id objc = objects[i];
        if (objc == nil) {
            continue;
        }
        objectsNew[index++] = objc;
    }
    return SIHookOrgin(objectsNew,index);
}
SIStaticHookEnd

SIStaticHookPrivateMetaClass(__NSArray0, NSArray *, GuardCont, NSArray *, @selector(arrayWithObjects:count:),
                             (const id *)objects, (NSUInteger)cnt) {
    NSUInteger index = 0;
    id _Nonnull objectsNew[cnt];
    for (int i = 0; i < cnt; i++) {
        id objc = objects[i];
        if (objc == nil) {
            continue;
        }
        objectsNew[index++] = objc;
    }
    return SIHookOrgin(objectsNew,index);
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSPlaceholderArray, NSArray *, GuardCont, NSArray *, @selector(initWithObjects:count:),
                         (const id *)objects, (NSUInteger)cnt) {
    NSUInteger index = 0;
    id _Nonnull objectsNew[cnt];
    for (int i = 0; i < cnt; i++) {
        id objc = objects[i];
        if (objc == nil) {
            continue;
        }
        objectsNew[index++] = objc;
    }
    return SIHookOrgin(objectsNew,index);
}

SIStaticHookEnd

#pragma mark -- NSMutableArray

SIStaticHookPrivateClass(__NSArrayM, NSMutableArray *, GuardCont, id, @selector(objectAtIndexedSubscript:), (NSUInteger)index) {
    if (index >= self.count) return nil;
    return SIHookOrgin(index);
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSArrayM, NSMutableArray *, GuardCont, void, @selector(addObject:), (id)anObject ) {
    if (anObject) {
        SIHookOrgin(anObject);
    }
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSArrayM, NSMutableArray *, GuardCont, void, @selector(insertObject:atIndex:), (id)anObject, (NSUInteger)index) {
    if (anObject && index <= self.count) {
        SIHookOrgin(anObject, index);
    }
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSArrayM,NSMutableArray *, GuardCont, void, @selector(removeObjectAtIndex:), (NSUInteger)index) {
    if (index < self.count) {
        SIHookOrgin(index);
    }
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSArrayM, NSMutableArray *, GuardCont, void, @selector(setObject:atIndexedSubscript:), (id) obj, (NSUInteger) idx) {
    if (obj && idx < self.count) {
        SIHookOrgin(obj, idx);
    }
}
SIStaticHookEnd


#pragma clang diagnostic pop

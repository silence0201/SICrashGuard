//
//  NSString+Guard.m
//  SICrashGuard
//
//  Created by Silence on 2018/3/13.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SISwizzling.h"

/*
===============================
NSString->Methods On Protection:
1、characterAtIndex：
2、substringFromIndex:
3、substringToIndex:
4、substringWithRange:
5、stringByReplacingCharactersInRange:withString:

===============================
NSMutableString->Methods On Protection:
1、replaceCharactersInRange:withString:
2、insertString:atIndex:
3、deleteCharactersInRange:
*/

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

#pragma mark -- NSString
SIStaticHookPrivateClass(__NSCFConstantString, NSString *, GuardCont, NSString *, @selector(characterAtIndex:), (NSUInteger)index) {
    if (index >= self.length) {
        return nil;
    }
    return SIHookOrgin(index);
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSCFConstantString, NSString *, GuardCont, NSString *, @selector(substringFromIndex:), (NSUInteger)from) {
    if (from >= self.length) {
        return nil;
    }
    return SIHookOrgin(from);
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSCFConstantString, NSString *, GuardCont, NSString *, @selector(substringToIndex:), (NSUInteger)to) {
    if (to >= self.length) {
        return nil;
    }
    return SIHookOrgin(to);
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSCFConstantString, NSString *, GuardCont, NSString *, @selector(substringWithRange:), (NSRange)range) {
    if (range.location+range.length>self.length) {
        return nil;
    }
    return SIHookOrgin(range);
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSCFConstantString, NSString *, GuardCont, id, @selector(stringByReplacingCharactersInRange:withString:), (NSRange)range,(NSString *)str) {
    if (range.location+range.length>self.length) {
        return nil;
    }
    return SIHookOrgin(range,str);
}
SIStaticHookEnd

#pragma mark -- NSMutableString
SIStaticHookPrivateClass(__NSCFString, NSString *, GuardCont, void, @selector(insertString:atIndex:), (NSString *)str,(NSUInteger)loc) {
    if (loc > self.length) {
        // 错误处理
    }else {
        SIHookOrgin(str,loc);
    }
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSCFString, NSString *, GuardCont, void, @selector(deleteCharactersInRange:), (NSRange)range) {
    if (range.location+range.length > self.length)  {
        // 错误处理
    }else {
        SIHookOrgin(range);
    }
}
SIStaticHookEnd

SIStaticHookPrivateClass(__NSCFString, NSString *, GuardCont, void, @selector(replaceCharactersInRange:withString:), (NSRange)range,(NSString *)str) {
    if (range.location+range.length > self.length) {
        
    }else{
        SIHookOrgin(range,str);
    }
    
}
SIStaticHookEnd

#pragma clang diagnostic pop

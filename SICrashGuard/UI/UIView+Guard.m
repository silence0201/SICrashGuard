//
//  UIView+Guard.m
//  SICrashGuard
//
//  Created by Silence on 2018/3/9.
//  Copyright © 2018年 Silence. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SISwizzling.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

SIStaticHookClass(UIView, GuardUI, void, @selector(setNeedsDisplay)) {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        SIHookOrgin();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            SIHookOrgin();
        });
    }
}
SIStaticHookEnd

SIStaticHookClass(UIView, GuardUI, void, @selector(layoutSubviews)) {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        SIHookOrgin();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            SIHookOrgin();
        });
    }
}
SIStaticHookEnd

SIStaticHookClass(UIView, GuardUI, void, @selector(setNeedsUpdateConstraints)) {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        SIHookOrgin();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            SIHookOrgin();
        });
    }
}
SIStaticHookEnd

#pragma clang diagnostic pop

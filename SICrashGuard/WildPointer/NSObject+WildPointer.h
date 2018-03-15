//
//  NSObject+WildPointer.h
//  SICrashGuard
//
//  Created by Silence on 2018/3/14.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WildPointer)

- (void)si_wildPointer_dealloc;

@end

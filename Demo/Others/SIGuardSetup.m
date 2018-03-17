//
//  SIGuardSetup.m
//  Demo
//
//  Created by Silence on 2018/3/17.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SICrashGuardManager.h"

#ifdef DEBUG
#define SILog(...)      printf("********************Guard start*************************\n[%s] %s [第%d行]\n%s\n*********************Gurad  end********************************\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define SILog(...)
#endif

@interface SIGuardSetup : NSObject<SIRecordProtocol>
@end

@implementation SIGuardSetup

+ (void)load {
    [SICrashGuardManager registerRecordHandler:[self new]];
    [SICrashGuardManager registerGuardExceptWildPointer];
}

- (void)recordWithReason:(NSError *)reason {
    SILog(@"截获到一个错误:%@ \n调用堆栈:%@",reason.localizedDescription,reason.userInfo[NSDebugDescriptionErrorKey]);
    
}

@end

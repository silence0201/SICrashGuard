//
//  SIRecord.m
//  SICrashGuard
//
//  Created by Silence on 2018/3/17.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SIRecord.h"
#import "SICallStackManager.h"

static id<SIRecordProtocol> __record;

@implementation SIRecord

+ (void)registerRecordHandler:(id<SIRecordProtocol>)record {
    __record = record;
}

+ (void)recordFatalWithReason:(nullable NSString *)reason
                    errorType:(SIGuardType)type {
    
    NSDictionary<NSString *, id> *errorInfo = @{
                                                NSLocalizedDescriptionKey : (reason.length ? reason : @"未标识原因" ),
                                                NSDebugDescriptionErrorKey: [SICallStackManager callStackOfCurrentThread]
                                                 };
    
    NSError *error = [NSError errorWithDomain:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
                                         code:-type
                                     userInfo:errorInfo];
    [__record recordWithReason:error];
}

@end

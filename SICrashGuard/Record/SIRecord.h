//
//  SIRecord.h
//  SICrashGuard
//
//  Created by Silence on 2018/3/17.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SICrashGuardManager.h"

@interface SIRecord : NSObject

+ (void)registerRecordHandler:(nullable id<SIRecordProtocol>)record;

+ (void)recordFatalWithReason:(nullable NSString *)reason
                    errorType:(SIGuardType)type;

@end

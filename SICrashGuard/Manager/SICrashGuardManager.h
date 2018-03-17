//
//  SICrashGuardManager.h
//  SICrashGuard
//
//  Created by Silecnce on 2018/3/17.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SIGuardType) {
    SIGuardTypeUnrecognizedSelector = 1 << 1,
    SIGuardTypeContainer = 1 << 2,
    SIGuardTypeNSNull = 1 << 3,
    SIGuardTypeKVO = 1 << 4,
    SIGuardTypeNotification = 1 << 5,
    SIGuardTypeTimer = 1 << 6,
    SIGuardTypeWildPointer = 1 << 7,
    SIGuardTypeMainUI = 1 << 8,
    SIGuardTypeExceptWildPointer = (SIGuardTypeUnrecognizedSelector | SIGuardTypeContainer |
                                          SIGuardTypeNSNull| SIGuardTypeKVO |
                                          SIGuardTypeNotification | SIGuardTypeTimer | SIGuardTypeMainUI)
};

NS_ASSUME_NONNULL_BEGIN

@protocol SIRecordProtocol <NSObject>

- (void)recordWithReason:(NSError *)reason;

@end

@interface SICrashGuardManager : NSObject

+ (void)registerRecordHandler:(id<SIRecordProtocol>)record;

+ (void)registerGuardExceptWildPointer;
+ (void)registerGuardType:(SIGuardType)types;

+ (void)registerGuardWildPointer;
+ (void)registerGuardWildPointerWithPrxfix:(NSString *)prefix;
+ (void)registerWildPointerWithClassNames:(nonnull NSArray<NSString *> *)classNames;



@end

NS_ASSUME_NONNULL_END

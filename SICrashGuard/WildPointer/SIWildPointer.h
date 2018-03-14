//
//  SIWildPointer.h
//  Demo
//
//  Created by Silence on 2018/3/14.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIWildPointerManager : NSObject

@property (nonatomic, copy) NSArray <NSString *> *classArr;   // 需要处理的classes

+ (instancetype)manager;

@end

@interface SIWildPointerProxy : NSObject

- (instancetype)init;

@end

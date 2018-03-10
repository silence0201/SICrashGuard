//
//  SIDynamicObject.h
//  Demo
//
//  Created by Silence on 2018/3/10.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 可以动态生成所有方法的类,用来转发
@interface SIDynamicObject : NSObject

@property (nonatomic) Class realClass;
@property (nonatomic) SEL realSEL;

- (instancetype)init __unavailable;
+ (instancetype)shareInstance;

- (BOOL)addFunc:(SEL)sel;
+ (BOOL)addClassFunc:(SEL)sel;

@end

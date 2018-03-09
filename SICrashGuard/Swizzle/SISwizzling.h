//
//  SIMetamacros.h
//  Demo
//
//  Created by Silence on 2018/3/9.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "SIMetamacros.h"

#define SIForOCString(_) @#_

#define SISEL2Str(_) NSStringFromSelector(_)

#define FOREACH_ARGS(MACRO, ...)  \
        metamacro_if_eq(1,metamacro_argcount(__VA_ARGS__))                                                      \
        ()                                                                                                      \
        (metamacro_foreach(MACRO , , metamacro_tail(__VA_ARGS__)))                                              \


#define CREATE_ARGS_DELETE_PAREN(VALUE) ,VALUE

#define CREATE_ARGS(INDEX,VALUE) CREATE_ARGS_DELETE_PAREN VALUE

#define __CREATE_ARGS_DELETE_PAREN(...) \
        [type appendFormat:@"%s",@encode(metamacro_head(__VA_ARGS__))];

#define CRATE_TYPE_CODING_DEL_VAR(TYPE) TYPE ,

#define CRATE_TYPE_CODING(INDEX,VALUE) \
        __CREATE_ARGS_DELETE_PAREN(CRATE_TYPE_CODING_DEL_VAR VALUE)

#define __SIHookType__void ,

#define __SIHookTypeIsVoidType(...)  \
        metamacro_if_eq(metamacro_argcount(__VA_ARGS__),2)

#define SIHookTypeIsVoidType(TYPE) \
        __SIHookTypeIsVoidType(__SIHookType__ ## TYPE)

/// 调用原始函数
#define SIHookOrgin(...)                                                                                        \
            __si_hook_orgin_function                                                                            \
            ?__si_hook_orgin_function(self,__siHookSel,##__VA_ARGS__)                                           \
            :((typeof(__si_hook_orgin_function))(class_getMethodImplementation(__siHookSuperClass,__siHookSel)))(self,__siHookSel,##__VA_ARGS__)


/// 生成真实调用函数,私有
#define __SIHookClassBegin(theHookClass,                                                                        \
                           notWorkSubClass,                                                                     \
                           addMethod,                                                                           \
                           returnValue,                                                                         \
                           returnType,                                                                          \
                           theSEL,                                                                              \
                           theSelfTypeAndVar,                                                                   \
                           ...)                                                                                 \
                                                                                                                \
    static char associatedKey;                                                                                  \
    __unused Class __siHookClass = guard_hook_getClassFromObject(theHookClass);                                 \
    __unused Class __siHookSuperClass = class_getSuperclass(__siHookClass);                                     \
    __unused SEL __siHookSel  = theSEL;                                                                         \
    if (nil == __siHookClass                                                                                    \
        || objc_getAssociatedObject(__siHookClass, &associatedKey))                                             \
    {                                                                                                           \
        return NO;                                                                                              \
    }                                                                                                           \
    metamacro_if_eq(addMethod,1)                                                                                \
    (                                                                                                           \
        if (!class_respondsToSelector(__siHookClass,__siHookSel))                                               \
        {                                                                                                       \
            id _emptyBlock = ^returnType(id self                                                                \
                                         FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ ))                            \
            {                                                                                                   \
                Method method = class_getInstanceMethod(__siHookSuperClass,__siHookSel);                        \
                if (method)                                                                                     \
                {                                                                                               \
                    __unused                                                                                    \
                    returnType(*superFunction)(theSelfTypeAndVar,                                               \
                                               SEL _cmd                                                         \
                                               FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ ))                      \
                    = (void*)method_getImplementation(method);                                                  \
                    SIHookTypeIsVoidType(returnType)                                                            \
                    ()                                                                                          \
                    (return )                                                                                   \
                    superFunction(self,__siHookSel,##__VA_ARGS__);                                              \
                }                                                                                               \
                else                                                                                            \
                {                                                                                               \
                    SIHookTypeIsVoidType(returnType)                                                            \
                    (return;)                                                                                   \
                    (return returnValue;)                                                                       \
                }                                                                                               \
            };                                                                                                  \
            NSMutableString *type = [[NSMutableString alloc] init];                                             \
            [type appendFormat:@"%s@:", @encode(returnType)];                                                   \
            FOREACH_ARGS(CRATE_TYPE_CODING,1,##__VA_ARGS__ )                                                    \
            class_addMethod(__siHookClass,                                                                      \
                            theSEL,                                                                             \
                            (IMP)imp_implementationWithBlock(_emptyBlock),                                      \
                            type.UTF8String);                                                                   \
        }                                                                                                       \
    )                                                                                                           \
    ()                                                                                                          \
    if (!class_respondsToSelector(__siHookClass,__siHookSel))                                                   \
    {                                                                                                           \
        return NO;                                                                                              \
    }                                                                                                           \
    __block __unused                                                                                            \
    returnType(*__si_hook_orgin_function)(theSelfTypeAndVar,                                                    \
                                          SEL _cmd                                                              \
                                          FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ ))                           \
                = NULL;                                                                                         \
    id newImpBlock =                                                                                            \
    ^returnType(theSelfTypeAndVar FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ )) {                                 \
            metamacro_if_eq(notWorkSubClass,1)                                                                  \
            (if (!guard_hook_check_block(object_getClass(self),__siHookClass,&associatedKey))                   \
             {                                                                                                  \
              SIHookTypeIsVoidType(returnType)                                                                  \
              (SIHookOrgin(__VA_ARGS__ ); return;)                                                              \
              (return SIHookOrgin(__VA_ARGS__ );)                                                               \
            })                                                                                                  \
            ()                                                                                                  \


#define __siHookClassEnd                                                                                        \
    };                                                                                                          \
    objc_setAssociatedObject(__siHookClass,                                                                     \
                             &associatedKey,                                                                    \
                             [newImpBlock copy],                                                                \
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                                \
    __si_hook_orgin_function = guard_hook_imp_function(__siHookClass,                                          \
                                                         __siHookSel,                                           \
                                                         imp_implementationWithBlock(newImpBlock));             \
                                                                                                                \


#define __SIStaticHookClass(theCFunctionName,theHookClassType,selfType,GroupName,returnType,theSEL,... )        \
        static BOOL theCFunctionName ();                                                                        \
        static void* metamacro_concat(theCFunctionName, pointer) __attribute__ ((used, section ("__DATA,__sh" # GroupName))) = theCFunctionName;                                   \
        static BOOL theCFunctionName () {                                                                       \
        __SIHookClassBegin(theHookClassType,                                                                    \
                           0,                                                                                   \
                           0,                                                                                   \
                            ,                                                                                   \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            selfType self,                                                                      \
                            ##__VA_ARGS__)                                                                      \

/// 拦截私有类的方法
#define SIStaticHookPrivateClass(theHookClassType,publicType,GroupName,returnType,theSEL,... )                  \
        __SIStaticHookClass(metamacro_concat(__guard_hook_auto_load_function_ , __COUNTER__),                   \
                            NSClassFromString(@#theHookClassType),                                              \
                            publicType,                                                                         \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \

/// 拦截方法,私有
#define SIStaticHookClass(theHookClassType,GroupName,returnType,theSEL,... )                                    \
        __SIStaticHookClass(metamacro_concat(__guard_hook_auto_load_function_ , __COUNTER__),                  \
                            [theHookClassType class],                                                           \
                            theHookClassType*,                                                                  \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \

/// 拦截类方法
#define SIStaticHookMetaClass(theHookClassType,GroupName,returnType,theSEL,... )                                \
        __SIStaticHookClass(metamacro_concat(__guard_hook_auto_load_function_ , __COUNTER__),                   \
                            object_getClass([theHookClassType class]),                                          \
                            Class,                                                                              \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \

/// 拦截私有类的类方法
#define SIStaticHookPrivateMetaClass(theHookClassType,publicType,GroupName,returnType,theSEL,... )              \
        __SIStaticHookClass(metamacro_concat(__guard_hook_auto_load_function_ , __COUNTER__),                  \
                            object_getClass(NSClassFromString(@#theHookClassType)),                             \
                            publicType,                                                                         \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \

/// 结束标志
#define SIStaticHookEnd   __siHookClassEnd        return YES;                                                   \
                    }

#define SIStaticHookEnd_SaveOri(P) __siHookClassEnd P = __si_hook_orgin_function;  return YES;   }              \





// 私有 请不要手动调用
void * guard_hook_imp_function(Class clazz,
                                SEL   sel,
                                void  *newFunction);
BOOL guard_hook_check_block(Class objectClass, Class hookClass,void* associatedKey);
Class guard_hook_getClassFromObject(id object);


/// 启动
void guard_hook_load_group(NSString* groupName);
BOOL defaultSwizzlingOCMethod(Class self, SEL origSel_, SEL altSel_);

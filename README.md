# SICrashGuard

iOS APP运行时Crash自动修复系统

## 安装

下载项目后,将项目下`SICrashGuard.framework`添加到项目中

## 使用

使用SICrashGuardManager对相关注册

```
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
```

## SICrashGuard
SICrashGuard is available under the MIT license. See the LICENSE file for more info.
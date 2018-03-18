//
//  WildPointerTestViewController.m
//  Demo
//
//  Created by Silence on 2018/3/17.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "WildPointerTestViewController.h"
#import "SICrashGuardManager.h"

@interface TestClass : NSObject
@property (nonatomic,strong) NSString *name;
@end
@implementation TestClass
@end

@interface WildPointerTestViewController ()

@end

@implementation WildPointerTestViewController {
    TestClass *p ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SICrashGuardManager registerWildPointerWithClassNames:@[@"TestClass"]];
    p = [[TestClass alloc]init];
    p.name = @"Bell";
}
- (IBAction)DainglingPointTest:(id)sender {
    NSLog(@"%@",p.name);
    [p release];
    NSLog(@"%@",p.name);
}

@end

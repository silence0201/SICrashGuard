//
//  NSNullTestViewController.m
//  Demo
//
//  Created by Silence on 2018/3/17.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "NSNullTestViewController.h"

@interface NSNullTestViewController ()

@end

@implementation NSNullTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)jsontest:(id)sender {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *testJson = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",testJson);
    
    id data = [testJson objectForKey:@"data"];
    NSLog(@"%@",[data class]);
    
    
    // 假定data为Sting,调用String的方法
    // 如果不加守护默认会崩溃
    NSLog(@"%@",[data lowercaseString]);
}

@end

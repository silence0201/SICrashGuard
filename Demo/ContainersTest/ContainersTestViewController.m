//
//  ContainersTestViewController.m
//  Demo
//
//  Created by Silence on 2018/3/17.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "ContainersTestViewController.h"

@interface ContainersTestViewController ()

@end

@implementation ContainersTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)testArray{
    /*
     NSArray->Methods On Protection:
     1、@[nil]
     2、arrayWithObjects:count:
     3、objectsAtIndexes:
     4、objectAtIndex:
     */
    NSString *value = nil;
    NSString *key = nil;
    //1、@[nil]
    NSArray *array0 = @[value];
    NSLog(@"array0:%@",array0);
    //2、arrayWithObjects:count:
    NSArray *array1 = [NSArray arrayWithObjects:@"abc",value,value, nil];
    NSLog(@"array1:%@",array1);
    //3、objectsAtIndexes:
    NSArray *array2 = @[@"1",@"2",@"3"];
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)];
    NSLog(@"first:%ld,last:%ld",set.firstIndex,set.lastIndex);
    NSArray *objectsAtIndexes = [array2 objectsAtIndexes:set];
    NSLog(@"objectsAtIndexes:%@",objectsAtIndexes);
    //4、objectAtIndex
    id objectAtIndex = [array2 objectAtIndex:4];
    array2[4];
}
- (IBAction)testMutableArray{
    NSString *value = nil;
    NSString *key = nil;
    // arrayWithObjects:nil
    NSMutableArray *array0 = [NSMutableArray arrayWithObjects:@"aklkd",value,value, nil];
    NSLog(@"array0:%@",array0);
    // objectAtIndex:
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    NSString *objectAtIndex = [array1 objectAtIndex:5];
    objectAtIndex = array1[4];
    // removeObjectAtIndex:
    [array1 removeObjectAtIndex:5];
    // removeObjectsInRange:
    [array1 removeObjectsInRange:NSMakeRange(2, 3)];
    NSLog(@"removeObjectsInRangeArray1:%@",array1);
    // removeObjectsAtIndexes:
    array1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    [array1 removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 4)]];
    NSLog(@"removeObjectsAtIndexesArray:%@",array1);
    // insertObject:atIndex:
    array1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    [array1 insertObject:@"5" atIndex:5];
    NSLog(@"insertObjectArray:%@",array1);
    // addObject:nil
    array1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    [array1 addObject:value];
    // arrayWithObjects
    array1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    [array1 replaceObjectAtIndex:5 withObject:@"5"];
    
    array1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    [array1 replaceObjectAtIndex:2 withObject:nil];
    
    
}

- (IBAction)testDictionary{
    //1 @{nil:nil}
    NSString *value = nil;
    NSString *key = nil;
    NSDictionary *dic = @{@"key":value};
    dic = @{key:@"value"};
    //  dictionaryWithObject:forKey：
    [NSDictionary dictionaryWithObject:@"value" forKey:key];
    [NSDictionary dictionaryWithObject:value forKey:@"key"];
    
    NSLog(@"%@",dic);
}

- (IBAction)testMutableDictionary{
    NSString *value = nil;
    NSString *key = nil;
    // setObject:forKey:
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:@"value" forKey:key];
    [dicM setObject:value forKey:@"key"];
    [dicM setObject:@"value" forKey:@"key"];
    NSLog(@"dicM:%@",dicM);
    //  removeObjectForKey:
    [dicM removeObjectForKey:key];
    NSLog(@"dicM:%@",dicM);
}
- (IBAction)testNSCache {
    NSString *value = nil;
    NSString *key = nil;
    // setObject:forKey:
    NSCache *cache = [[NSCache alloc]init];
    [cache setObject:@"value" forKey:key];
    [cache setObject:value forKey:@"key"];
    [cache setObject:@"value" forKey:@"key"];
    NSLog(@"cache:%@",cache);
    // removeObjectForKey:
    [cache removeObjectForKey:key];
    NSLog(@"cache:%@",cache);
    
}


@end

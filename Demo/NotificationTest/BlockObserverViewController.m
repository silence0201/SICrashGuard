//
//  BlockObserverViewController.m
//  Demo
//
//  Created by Silence on 2018/3/17.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "BlockObserverViewController.h"

@interface BlockObserverViewController ()

@end

@implementation BlockObserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"Block" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@",weakSelf.class);
    }];
}

- (void)dealloc {
    NSLog(@"BlockObserverViewController dealloc");
}

- (IBAction)post:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Block" object:nil];
}

@end

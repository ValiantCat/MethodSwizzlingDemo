//
//  ViewController.m
//  JRSwizzleDemo
//
//  Created by nero on 2017/7/17.
//  Copyright © 2017年 nero. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[ Student new] sayHello];
}


@end

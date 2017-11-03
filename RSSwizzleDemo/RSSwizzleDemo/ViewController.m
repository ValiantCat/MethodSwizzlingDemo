//
//  ViewController.m
//  RSSwizzleDemo
//
//  Created by nero on 2017/7/18.
//  Copyright © 2017年 nero. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[ Student new] sayHello];
}


@end

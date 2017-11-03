//
//  Person+swizzle.m
//  JRSwizzleDemo
//
//  Created by nero on 2017/7/17.
//  Copyright © 2017年 nero. All rights reserved.
//

#import "Person+swizzle.h"
#import "JRSwizzle.h"

@implementation Person (swizzle)

+ (void)load {
    [self jr_swizzleMethod:@selector(p_sayHello) withMethod:@selector(sayHello) error:nil];
}

- (void)p_sayHello {
    [self p_sayHello];
    
    NSLog(@"Person + swizzle say hello");
}

@end

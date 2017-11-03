//
//  Student+swizzle.m
//  JRSwizzleDemo
//
//  Created by nero on 2017/7/17.
//  Copyright © 2017年 nero. All rights reserved.
//

#import "Student+swizzle.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

@implementation Student (swizzle)
+ (void)load {
    [self jr_swizzleMethod:@selector(s_sayHello) withMethod:@selector(sayHello) error:nil];
}

- (void)s_sayHello {
    
    [self s_sayHello];
//    [super sayHello];
    NSLog(@"Student + swizzle say hello");
}
@end

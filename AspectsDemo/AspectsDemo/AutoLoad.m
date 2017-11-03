//
//  AutoLoad.m
//  AspectsDemo
//
//  Created by nero on 2017/7/17.
//  Copyright © 2017年 nero. All rights reserved.
//

#import "AutoLoad.h"
#import "Aspects.h"
#import "Student.h"
#import "Person+swizzle.h"
#import "JRSwizzle.h"
void autoCrack()  {
    [Student aspect_hookSelector:@selector(sayHello) withOptions:(AspectPositionAfter) usingBlock:^(id<AspectInfo> aspectInfo) {
        NSLog(@"Student + swizzle say hello");
    } error:nil];
    [Person jr_swizzleMethod:@selector(p_sayHello) withMethod:@selector(sayHello) error:nil];
//    [Person aspect_hookSelector:@selector(sayHello) withOptions:(AspectPositionAfter) usingBlock:^(id<AspectInfo> aspectInfo) {
//        NSLog(@"Person + swizzle say hello");
//    } error:nil];
    
    
}

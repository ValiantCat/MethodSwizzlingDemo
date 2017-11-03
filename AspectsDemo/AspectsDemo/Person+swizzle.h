//
//  Person+swizzle.h
//  JRSwizzleDemo
//
//  Created by nero on 2017/7/17.
//  Copyright © 2017年 nero. All rights reserved.
//

#import "Person.h"

@interface Person (swizzle)
- (void)p_sayHello;
@end

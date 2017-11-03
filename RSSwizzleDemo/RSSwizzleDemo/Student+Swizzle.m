//
//  Student+Swizzle.m
//  RSSwizzleDemo
//
//  Created by nero on 2017/7/18.
//  Copyright © 2017年 nero. All rights reserved.
//

#import "Student+Swizzle.h"
#import "RSSwizzle.h"
#import <objc/runtime.h>
void autoCrack() {
    
    RSSwizzleImpFactoryBlock newImp = ^id(RSSwizzleInfo *swizzleInfo) {
        void (*originalImplementation_)(__attribute__((objc_ownership(none))) id, SEL);
        SEL selector_ = @selector(sayHello);
        return ^void (__attribute__((objc_ownership(none))) id self) {
            IMP xx = method_getImplementation(class_getInstanceMethod([Student class], selector_));
            IMP xx1 = method_getImplementation(class_getInstanceMethod(class_getSuperclass([Student class]) , selector_));
            IMP oriiMP = (IMP)[swizzleInfo getOriginalImplementation];
                ((__typeof(originalImplementation_))[swizzleInfo getOriginalImplementation])(self, selector_);
            //只有这一行是我们的核心逻辑
            NSLog(@"Student + swizzle say hello");
            
        };
        
    };
    [RSSwizzle swizzleInstanceMethod:@selector(sayHello)
                             inClass:[[Student class] class]
                       newImpFactory:newImp
                                mode:0 key:((void*)0)];;
    
    RSSwizzleInstanceMethod([Student class],
                            @selector(sayHello),
                            RSSWReturnType(void),
                            RSSWArguments(),
                            RSSWReplacement(
                                            {
                                                // Calling original implementation.
                                                RSSWCallOriginal();
                                                // Returning modified return value.
                                                NSLog(@"Student + swizzle say hello");
                                            }), 0, NULL);

    RSSwizzleInstanceMethod([Student class],
                            @selector(sayHello),
                            RSSWReturnType(void),
                            RSSWArguments(),
                            RSSWReplacement(
                                            {
                                                // Calling original implementation.
                                                RSSWCallOriginal();
                                                // Returning modified return value.
                                                NSLog(@"Student + swizzle say hello sencod time");
                                            }), 0, NULL);

    RSSwizzleInstanceMethod([Person class],
                            @selector(sayHello),
                            RSSWReturnType(void),
                            RSSWArguments(),
                            RSSWReplacement(
                                            {
                                                // Calling original implementation.
                                                RSSWCallOriginal();
                                                // Returning modified return value.
                                                NSLog(@"Person + swizzle say hello");
                                            }), 0, NULL);
    
}

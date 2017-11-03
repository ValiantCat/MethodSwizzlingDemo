//
//  NSNotificationCenter+Stability.m
//  XXShield
//
//  Created by nero on 2017/2/8.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "NSNotificationCenter+Shield.h"
#import <objc/runtime.h>
#import "RSSwizzle.h"

@interface XXObserverRemover : NSObject {
    __strong NSMutableArray *_centers;
    __unsafe_unretained id _obs;
}
@end
@implementation XXObserverRemover

- (instancetype)initWithObserver:(id)obs {
    if (self = [super init]) {
        _obs = obs;
        _centers = @[].mutableCopy;
    }
    return self;
}

- (void)addCenter:(NSNotificationCenter*)center {
    if (center) {
        [_centers addObject:center];
    }
}

- (void)dealloc {
    @autoreleasepool {
        for (NSNotificationCenter *center in _centers) {
            [center removeObserver:_obs];
        }
    }
}

@end

void addCenterForObserver(NSNotificationCenter *center ,id obs) {
    XXObserverRemover *remover = nil;
    static char removerKey;
    @autoreleasepool {
        remover = objc_getAssociatedObject(obs, &removerKey);
        if (!remover) {
            remover = [[XXObserverRemover alloc] initWithObserver:obs];
            objc_setAssociatedObject(obs, &removerKey, remover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [remover addCenter:center];
    }
    
}
void autoHook() {
    RSSwizzleInstanceMethod([NSNotificationCenter class], @selector(addObserver:selector:name:object:),
                            RSSWReturnType(void), RSSWArguments(id obs,SEL cmd,NSString *name,id obj),
                            RSSWReplacement({
        RSSWCallOriginal(obs,cmd,name,obj);
        addCenterForObserver(self, obs);
    }), 0, NULL);
    
}




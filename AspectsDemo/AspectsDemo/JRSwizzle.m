// JRSwizzle.m semver:1.1.0
//   Copyright (c) 2007-2016 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/mit
//   https://github.com/rentzsch/jrswizzle

#import "JRSwizzle.h"


	#import <objc/runtime.h>
	#import <objc/message.h>


#define SetNSErrorFor(FUNC, ERROR_VAR, FORMAT,...)	\
	if (ERROR_VAR) {	\
		NSString *errStr = [NSString stringWithFormat:@"%s: " FORMAT,FUNC,##__VA_ARGS__]; \
		*ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
										 code:-1	\
									 userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
	}
#define SetNSError(ERROR_VAR, FORMAT,...) SetNSErrorFor(__func__, ERROR_VAR, FORMAT, ##__VA_ARGS__)


#define GetClass(obj)	object_getClass(obj)


@implementation NSObject (JRSwizzle)

+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_ {

	Method origMethod = class_getInstanceMethod(self, origSel_);
	if (!origMethod) {

		SetNSError(error_, @"original method %@ not found for class %@", NSStringFromSelector(origSel_), [self class]);

		return NO;
	}

	Method altMethod = class_getInstanceMethod(self, altSel_);
	if (!altMethod) {

		SetNSError(error_, @"alternate method %@ not found for class %@", NSStringFromSelector(altSel_), [self class]);

		return NO;
	}

	class_addMethod(self,
					origSel_,
					class_getMethodImplementation(self, origSel_),
					method_getTypeEncoding(origMethod));
	class_addMethod(self,
					altSel_,
					class_getMethodImplementation(self, altSel_),
					method_getTypeEncoding(altMethod));

	method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
	return YES;
}

+ (BOOL)jr_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_ {
	return [GetClass((id)self) jr_swizzleMethod:origSel_ withMethod:altSel_ error:error_];
}

+ (NSInvocation*)jr_swizzleMethod:(SEL)origSel withBlock:(id)block error:(NSError**)error {
    IMP blockIMP = imp_implementationWithBlock(block);
    NSString *blockSelectorString = [NSString stringWithFormat:@"_jr_block_%@_%p", NSStringFromSelector(origSel), block];
    SEL blockSel = sel_registerName([blockSelectorString cStringUsingEncoding:NSUTF8StringEncoding]);
    Method origSelMethod = class_getInstanceMethod(self, origSel);
    const char* origSelMethodArgs = method_getTypeEncoding(origSelMethod);
    class_addMethod(self, blockSel, blockIMP, origSelMethodArgs);

    NSMethodSignature *origSig = [NSMethodSignature signatureWithObjCTypes:origSelMethodArgs];
    NSInvocation *origInvocation = [NSInvocation invocationWithMethodSignature:origSig];
    origInvocation.selector = blockSel;

    [self jr_swizzleMethod:origSel withMethod:blockSel error:nil];

    return origInvocation;
}

+ (NSInvocation*)jr_swizzleClassMethod:(SEL)origSel withBlock:(id)block error:(NSError**)error {
    NSInvocation *invocation = [GetClass((id)self) jr_swizzleMethod:origSel withBlock:block error:error];
    invocation.target = self;

    return invocation;
}

@end

#import <Foundation/Foundation.h>

#ifndef EVESwizzleHelpers_h
#define EVESwizzleHelpers_h

BOOL injectSelector(Class newClass, SEL newSelector, Class delegateClass, SEL delegateSelector);

void injectIntoClassHierarchy(SEL newSelector, SEL delegateSelector, NSArray *delegateSubclasses, Class newClass, Class delegateClass);

NSArray *getSubclassesOfClass(Class parentClass);

Class getClassWithProtocolInHierarchy(Class baseClass, Protocol *searchProtocol);

BOOL doesInstanceOverrideSelector(Class instance, SEL selector);

#endif
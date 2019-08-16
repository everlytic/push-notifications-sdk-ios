#import <objc/runtime.h>
#import "EVESwizzleHelpers.h"

BOOL injectSelector(Class newClass, SEL newSel, Class addToClass, SEL makeLikeSel) {
    NSLog(@"injectSelector()");
    Method newMeth = class_getInstanceMethod(newClass, newSel);
    IMP imp = method_getImplementation(newMeth);

    const char* methodTypeEncoding = method_getTypeEncoding(newMeth);
    // Keep - class_getInstanceMethod for existing detection.
    //    class_addMethod will successfuly add if the addToClass was loaded twice into the runtime.
    BOOL existing = class_getInstanceMethod(addToClass, makeLikeSel) != NULL;

    if (existing) {
        class_addMethod(addToClass, newSel, imp, methodTypeEncoding);
        newMeth = class_getInstanceMethod(addToClass, newSel);
        Method orgMeth = class_getInstanceMethod(addToClass, makeLikeSel);
        method_exchangeImplementations(orgMeth, newMeth);
    }
    else
        class_addMethod(addToClass, makeLikeSel, imp, methodTypeEncoding);

    return existing;

    /*Method swizMethod = class_getInstanceMethod(newClass, newSelector);
    IMP swizImp = method_getImplementation(swizMethod);

    const char * methodTypeEncoding = method_getTypeEncoding(swizMethod);

    BOOL delegateHasSelector = class_getInstanceMethod(delegateClass, delegateSelector) != NULL;

    if (delegateHasSelector) {
        class_addMethod(delegateClass, newSelector, swizImp, methodTypeEncoding);
        swizMethod = class_getInstanceMethod(delegateClass, newSelector);
        Method orgMethod = class_getInstanceMethod(delegateClass, delegateSelector);
        method_exchangeImplementations(orgMethod, swizMethod);
    } else {
        class_addMethod(delegateClass, delegateSelector, swizImp, methodTypeEncoding);
    }

    return delegateHasSelector;*/
}

void injectIntoClassHierarchy(SEL newSelector, SEL delegateSelector, NSArray *delegateSubclasses, Class newClass, Class delegateClass) {
    NSLog(@"injectIntoClassHierarchy()");
    for(Class subclass in delegateSubclasses) {
        if (doesInstanceOverrideSelector(subclass, delegateSelector)) {
            injectSelector(newClass, newSelector, subclass, delegateSelector);
            return;
        }
    }

    injectSelector(newClass, newSelector, delegateClass, delegateSelector);
}

NSArray *getSubclassesOfClass(Class parentClass) {
    NSLog(@"getSubclassesOfClass()");
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = (Class*)malloc(sizeof(Class) * numClasses);

    objc_getClassList(classes, numClasses);

    NSMutableArray *result = [NSMutableArray array];

    for (NSInteger i = 0; i < numClasses; i++) {
        Class superClass = classes[i];

        while(superClass && superClass != parentClass) {
            superClass = class_getSuperclass(superClass);
        }

        if (superClass)
            [result addObject:classes[i]];
    }

    free(classes);

    return result;
}

Class getClassWithProtocolInHierarchy(Class baseClass, Protocol *searchProtocol) {
    NSLog(@"getClassWithProtocolInHierarchy()");
    if (!class_conformsToProtocol(baseClass, searchProtocol)) {
        if ([baseClass superclass] == nil)
            return nil;
        Class foundClass = getClassWithProtocolInHierarchy([baseClass superclass], searchProtocol);
        if (foundClass)
            return foundClass;
        return baseClass;
    }
    return baseClass;
}

BOOL doesInstanceOverrideSelector(Class instance, SEL selector) {
    NSLog(@"doesInstanceOverrideSelector()");
    Class instSuperClass = [instance superclass];
    return [instance instanceMethodForSelector: selector] != [instSuperClass instanceMethodForSelector: selector];
}
#import <UIKit/UIKit.h>
#import "EVEUIApplicationDelegate.h"
#import "EVESwizzleHelpers.h"
#import "EVEDatabase.h"


@implementation EVEUIApplicationDelegate

#pragma mark - Method Swizzles

+ (void)swizzleApplicationDelegate {

    Class delegateClass = getClassWithProtocolInHierarchy([UIApplication class], @protocol(UIApplicationDelegate));
    NSArray *delegateSubclasses = getSubclassesOfClass(delegateClass);

    injectIntoClassHierarchy(
            @selector(everlytic_application:didReceiveRemoteNotification:fetchCompletionHandler:),
            @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:),
            delegateSubclasses,
            [self class],
            delegateClass
    );

    injectIntoClassHierarchy(@selector(everlytic_applicationDidBecomeActive:), @selector(applicationDidBecomeActive:), delegateSubclasses, [self class], delegateClass);

    injectIntoClassHierarchy(@selector(everlytic_applicationWillResignActive:), @selector(applicationWillResignActive:), delegateSubclasses, [self class], delegateClass);
}

- (void)everlytic_application:(UIApplication *)application
 didReceiveRemoteNotification:(NSDictionary *)userInfo
       fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    // todo handle foreground & background notifications

    if ([self respondsToSelector:@selector(everlytic_application:didReceiveRemoteNotification:fetchCompletionHandler:)]){
        [self everlytic_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    }
}

- (void)everlytic_applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"@selector(applicationDidBecomeActive:)");
//    NSLog(@"Opening database...");
//    [EVEDatabase open];
//    NSLog(@"Database opened");

    if ([self respondsToSelector:@selector(everlytic_applicationDidBecomeActive:)]){
        [self everlytic_applicationDidBecomeActive:application];
    }
}

- (void)everlytic_applicationWillResignActive:(UIApplication *)application {

    NSLog(@"@selector(applicationWillResignActive:)");
//    NSLog(@"Closing database...");
//    [EVEDatabase close];
//    NSLog(@"Database closed");

    if ([self respondsToSelector:@selector(everlytic_applicationWillResignActive:)]) {
        [self everlytic_applicationWillResignActive:application];
    }
}

@end

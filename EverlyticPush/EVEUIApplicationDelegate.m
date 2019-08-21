#import <UIKit/UIKit.h>
#import "EVEUIApplicationDelegate.h"
#import "EVESwizzleHelpers.h"
#import "EVENotificationEventsLog.h"
#import "EVENotificationLog.h"
#import "EVEEventsHelpers.h"

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

    NSMutableDictionary *mutableUserInfo = [userInfo mutableCopy];
//    if (application.applicationState == UIApplicationStateBackground || application.applicationState == UIApplicationStateActive) {
    [EVEEventsHelpers storeDeliveryEventWithUserInfo:userInfo];
    [EVEEventsHelpers storeNotificationInLogWithUserInfo:userInfo];

    [EVEEventsHelpers uploadPendingEventsWithCompletionHandler:nil];
//    }


    [EVEUIApplicationDelegate cleanUserInfo:mutableUserInfo];

    NSLog(@"didReceiveRemoteNotification:%@", userInfo);
    NSLog(@"Sending cleaned userInfo to application delegate:%@", mutableUserInfo);
    if ([self respondsToSelector:@selector(everlytic_application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
        [self everlytic_application:application didReceiveRemoteNotification:mutableUserInfo fetchCompletionHandler:completionHandler];
    } else {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

+ (void)cleanUserInfo:(NSMutableDictionary *)userInfo {
    // Renames the custom attributes to remove the prefix, removes actions completely
    for (NSString *key in [userInfo allKeys]) {
        unichar charKeyPrefix = [key characterAtIndex:0];
        if (charKeyPrefix == kCustomAttributePrefix) {
            userInfo[[key substringFromIndex:1]] = userInfo[key];
        }

        if (charKeyPrefix == kCustomAttributePrefix || charKeyPrefix == kActionPrefix) {
            [userInfo removeObjectForKey:key];
        }
    }
}

- (void)everlytic_applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"@selector(applicationDidBecomeActive:)");

//    [EVEReachability reachabilityForInternetConnection].reachabilityBlock = ^(EVEReachability *reachability, SCNetworkConnectionFlags flags) {
        [EVEEventsHelpers uploadPendingEventsWithCompletionHandler:nil];
//    };

    if ([self respondsToSelector:@selector(everlytic_applicationDidBecomeActive:)]) {
        [self everlytic_applicationDidBecomeActive:application];
    }
}

- (void)everlytic_applicationWillResignActive:(UIApplication *)application {

    NSLog(@"@selector(applicationWillResignActive:)");

    if ([self respondsToSelector:@selector(everlytic_applicationWillResignActive:)]) {
        [self everlytic_applicationWillResignActive:application];
    }
}

@end

#import <UIKit/UIKit.h>
#import "EVEUIApplicationDelegate.h"
#import "EVESwizzleHelpers.h"
#import "EVEDatabase.h"
#import "EVENotificationEventsLog.h"
#import "EVEApiResponse.h"
#import "EVEApi.h"
#import "EVEHttp.h"
#import "EVEDefaults.h"
#import "EVENotificationLog.h"
#import "EVEEventsHelpers.h"
#import "EVEReachability.h"

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

    NSNumber *const messageId = @([userInfo[@"message_id"] intValue]);

    if (application.applicationState == UIApplicationStateBackground || application.applicationState == UIApplicationStateActive) {
        [EVEEventsHelpers storeDeliveryEventWithUserInfo:userInfo];
        [EVEDatabase inDatabase:^(FMDatabase *database) {
            EVENotificationLog *log = [[EVENotificationLog alloc] initWithDatabase:database];
            [log insertNotificationWithMessageId:messageId
                                  subscriptionId:[EVEDefaults subscriptionId]
                                       contactId:[EVEDefaults contactId]
                                           title:userInfo[@"title"]
                                            body:userInfo[@"body"]
                                        metadata:@{}
                                         actions:[EVENotificationLog decodeActions:userInfo]
                                customParameters:[EVENotificationLog decodeCustomParameters:userInfo]
                                         groupId:@0
                                      receivedAt:[NSDate date]
                                          readAt:nil
                                     dismissedAt:nil
            ];
        }];

        [EVEEventsHelpers uploadPendingEventsWithCompletionHandler:nil];
    }


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

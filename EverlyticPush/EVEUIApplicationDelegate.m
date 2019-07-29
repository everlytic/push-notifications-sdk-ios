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

    [EVEDatabase inDatabase:^(FMDatabase *database) {
        EVENotificationLog *log = [[EVENotificationLog alloc] initWithDatabase:database];
        NSNumber *const messageId = @([userInfo[@"message_id"] intValue]);

        if (application.applicationState == UIApplicationStateInactive) {
            EVENotificationEventsLog *eventsLog = [[EVENotificationEventsLog alloc] initWithDatabase:database];
            EVENotificationEvent *event = [[EVENotificationEvent alloc]
                    initWithType:CLICK
            notificationCenterId:nil
                  subscriptionId:[EVEDefaults subscriptionId]
                       messageId:messageId
                        metadata:@{}
                        datetime:nil
            ];

            [eventsLog insertNotificationEvent:event];
            [log setNotificationByMessageId:messageId asRead:true];
        } else if (application.applicationState == UIApplicationStateBackground || application.applicationState == UIApplicationStateActive) {

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
        }

    }];

    NSLog(@"didReceiveRemoteNotification:%@", userInfo);

    if ([self respondsToSelector:@selector(everlytic_application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
        [self everlytic_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    }
}

- (void)everlytic_applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"@selector(applicationDidBecomeActive:)");

    id configString = [EVEDefaults configurationString];

    if (configString != nil) {

        EVEHttp *http = [[EVEHttp alloc] initWithSdkConfiguration:[EVESdkConfiguration initFromConfigString:configString]];
        id api = [[EVEApi alloc] initWithHttpInstance:http];

        [EVEDatabase inDatabase:^(FMDatabase *database) {
            EVENotificationEventsLog *eventsLog = [[EVENotificationEventsLog alloc] initWithDatabase:database];
            NSArray *events = [eventsLog pendingEvents];

            for (EVENotificationEvent *event in events) {
#ifdef DEBUG
                NSLog(@"Uploading event %@ type=%@", event.notification_center_id, [EVENotificationEvent typeAsString:event.type]);
#endif

                void (^ const removeEvent)(EVEApiResponse *, NSError *) = ^(EVEApiResponse *response, NSError *error) {
                    if (error == nil) {
                        NSLog(@"Successfully uploaded event(%@), removing from log", event.notification_center_id);
                        BOOL success = [eventsLog removeNotificationEventByNotificationCenterId:event.notification_center_id];
                        NSLog(@"Remove success: %d", success);
                    }

                    NSLog(@"Error: %@", error);
                };

                switch (event.type) {
                    case CLICK:
                        [api recordClickEvent:event completionHandler:removeEvent];
                        break;
                    case DELIVERY:
                        [api recordDeliveryEvent:event completionHandler:removeEvent];
                        break;
                    case DISMISS:
                        [api recordDismissEvent:event completionHandler:removeEvent];
                        break;
                    case UNKNOWN:
                        break;
                }
            }
        }];
    }

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

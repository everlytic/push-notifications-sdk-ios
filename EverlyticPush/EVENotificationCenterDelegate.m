#import "EVENotificationCenterDelegate.h"
#import "EVEDatabase.h"
#import "EVENotificationEventsLog.h"
#import "EVEDefaults.h"


@implementation EVENotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"willPresentNotification: %@", notification);
    completionHandler(UNNotificationPresentationOptionAlert);
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"didReceiveNotificationResponse: %@", response);

    if ([response.actionIdentifier compare:UNNotificationDismissActionIdentifier] == NSOrderedSame) {
        [EVEDatabase inDatabase:^(FMDatabase *database) {
            id log = [[EVENotificationEventsLog alloc] initWithDatabase:database];
            NSNumber *messageId = response.notification.request.content.userInfo[@"message_id"];
            id event = [[EVENotificationEvent alloc]
                    initWithId:nil
                          type:DISMISS
          notificationCenterId:nil
                subscriptionId:[EVEDefaults subscriptionId]
                     messageId:messageId
                      metadata:@{}
                      datetime:nil
            ];

            BOOL success = [log insertNotificationEvent:event];
            NSLog(@"Dismiss event created successfully=%d event=%@", success, event);
        }];
    }

    completionHandler();
}

@end
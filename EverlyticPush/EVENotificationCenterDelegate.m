#import "EVENotificationCenterDelegate.h"
#import "EVEDatabase.h"
#import "EVENotificationEventsLog.h"
#import "EVEEventsHelpers.h"
#import "EVENotificationLog.h"


@implementation EVENotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"willPresentNotification: %@", notification);
    [EVEEventsHelpers storeNotificationInLogWithUserInfo:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionAlert);
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"userNotificationCenter:didReceiveNotificationResponse: %@", response);

    id userInfo = response.notification.request.content.userInfo;

    [EVEEventsHelpers storeDeliveryEventWithUserInfo:userInfo];
    [EVEEventsHelpers storeNotificationInLogWithUserInfo:userInfo];

    NSNumber *const messageId = @([userInfo[@"message_id"] intValue]);
    if ([response.actionIdentifier compare:UNNotificationDefaultActionIdentifier] == NSOrderedSame) {

        [EVEEventsHelpers storeClickEventWithUserInfo:userInfo];
        [EVEDatabase inDatabase:^(FMDatabase *database) {
            [[[EVENotificationLog alloc] initWithDatabase:database]
                    setNotificationByMessageId:messageId asRead:true];
        }];
    } else if ([response.actionIdentifier compare:UNNotificationDismissActionIdentifier] == NSOrderedSame) {
        NSLog(@"should store notification dismissal");
        [EVEEventsHelpers storeDismissEventWithUserInfo:userInfo];
        [EVEDatabase inDatabase:^(FMDatabase *database) {
            [[[EVENotificationLog alloc] initWithDatabase:database]
                    setNotificationByMessageId:messageId asDismissed:true];
        }];
    }

    [EVEEventsHelpers uploadPendingEventsWithCompletionHandler:^{
        completionHandler();
    }];
}

@end

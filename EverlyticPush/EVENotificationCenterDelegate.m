#import "EVENotificationCenterDelegate.h"
#import "EVEDatabase.h"
#import "EVENotificationEventsLog.h"
#import "EVEDefaults.h"
#import "EVEEventsHelpers.h"
#import "EVENotificationLog.h"


@implementation EVENotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"willPresentNotification: %@", notification);
    completionHandler(UNNotificationPresentationOptionAlert);
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"didReceiveNotificationResponse: %@", response);

    id userInfo = response.notification.request.content.userInfo;

    if ([response.actionIdentifier compare:UNNotificationDefaultActionIdentifier] == NSOrderedSame) {
        NSNumber *const messageId = @([userInfo[@"message_id"] intValue]);

        [EVEEventsHelpers storeClickEventWithUserInfo:userInfo];
        [EVEDatabase inDatabase:^(FMDatabase *database) {
            EVENotificationLog *log = [[EVENotificationLog alloc] initWithDatabase:database];
            [log setNotificationByMessageId:messageId asRead:true];
        }];
    }

    if ([response.actionIdentifier compare:UNNotificationDismissActionIdentifier] == NSOrderedSame) {
        [EVEEventsHelpers storeDismissEventWithUserInfo:userInfo];
    }

    completionHandler();
}

@end
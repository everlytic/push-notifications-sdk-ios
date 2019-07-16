#import <UserNotifications/UserNotifications.h>
#import "EverlyticNotificationServiceExtentionHandler.h"
#import "EVENotificationEventsLog.h"
#import "EVEDatabase.h"
#import "EVEDefaults.h"
#import "FMDatabaseQueue.h"


@implementation EverlyticNotificationServiceExtentionHandler

+ (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {

    NSLog(@"Creating notification event... ");
    EVENotificationEvent *event = [[EVENotificationEvent alloc]
            initWithType:DELIVERY
    notificationCenterId:request.identifier
          subscriptionId:EVEDefaults.subscriptionId
               messageId:(unsigned long) request.content.userInfo[@"message_id"]
                metadata:@{}
    ];
    NSLog(@"Created event = %@", event);

    NSLog(@"Storing event in db...");

    __block BOOL success = NO;

    [EVEDatabase inDatabase:^(FMDatabase *db) {
        EVENotificationEventsLog *repo = [[EVENotificationEventsLog alloc] initWithDatabase:db];
        success = [repo insertNotificationEvent:event];
    }];

    NSLog(@"Event stored successfully: %@", success ? @"YES" : @"NO");

    [self applyNotificationContent:request toMutableNotificationContent:notificationContent];
}

+ (void)applyNotificationContent:(UNNotificationRequest *)request toMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {
    notificationContent.body = request.content.userInfo[@"body"];
    notificationContent.title = request.content.userInfo[@"title"];
//    notificationContent.sound = [UNNotificationSound defaultSound];
}

+ (void)serviceExtensionTimeWillExpireWithRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {
    [self applyNotificationContent:request toMutableNotificationContent:notificationContent];
}


@end
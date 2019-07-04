#import <UserNotifications/UserNotifications.h>
#import "EverlyticNotificationServiceExtentionHandler.h"
#import "EVENotificationEventsLog.h"
#import "EVEDatabase.h"
#import "EVEDefaults.h"


@implementation EverlyticNotificationServiceExtentionHandler

+ (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {

    EVENotificationEventsLog *repo = [[EVENotificationEventsLog alloc] initWithDatabase:[EVEDatabase database]];

    EVENotificationEvent *event = [[EVENotificationEvent alloc]
            initWithType:DELIVERY
    notificationCenterId:request.identifier
          subscriptionId:EVEDefaults.subscriptionId
               messageId:request.content.userInfo[@"message_id"]
                metadata:@{}
    ];

    [repo insertNotificationEvent:event];

    [self applyNotificationContent:request toMutableNotificationContent:notificationContent];
}

+ (void)applyNotificationContent:(UNNotificationRequest *)request toMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {
    notificationContent.body = request.content.userInfo[@"body"];
    notificationContent.title = request.content.userInfo[@"title"];
    notificationContent.sound = [UNNotificationSound defaultSound];
}

+ (void)serviceExtensionTimeWillExpireWithRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {
    [self applyNotificationContent:request toMutableNotificationContent:notificationContent];
}


@end
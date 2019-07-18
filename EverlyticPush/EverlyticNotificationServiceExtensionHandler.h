#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>


@interface EverlyticNotificationServiceExtensionHandler : NSObject
+ (void) didReceiveNotificationRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent;
+ (void)serviceExtensionTimeWillExpireWithRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent;
@end

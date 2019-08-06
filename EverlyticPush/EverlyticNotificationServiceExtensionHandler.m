#import <UserNotifications/UserNotifications.h>
#import "EverlyticNotificationServiceExtensionHandler.h"
#import "EVENotificationEventsLog.h"
#import "EVEDatabase.h"
#import "EVEDefaults.h"
#import "FMDatabaseQueue.h"
#import "EVEApi.h"
#import "EVEHttp.h"
#import "EVEEventsHelpers.h"

@implementation EverlyticNotificationServiceExtensionHandler

//NSMutableDictionary<NSString *, NSURLSessionDataTask *> *tasks = [[NSMutableDictionary alloc] init];

+ (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {

    NSLog(@"Creating notification event... ");

    [EVEEventsHelpers storeDeliveryEventWithUserInfo:request.content.userInfo];

    [EVEEventsHelpers uploadPendingEventsWithCompletionHandler:^{
        NSLog(@"Something");
    }];

    [self applyNotificationContent:request toMutableNotificationContent:notificationContent];
}

+ (void)serviceExtensionTimeWillExpireWithRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {

    NSLog(@"Extension will time out. Cancelling network request and storing event for upload later");

    [self applyNotificationContent:request toMutableNotificationContent:notificationContent];
}

+ (EVESdkConfiguration *)sdkConfiguration {
    return [EVESdkConfiguration initFromConfigString:[EVEDefaults configurationString]];
}

+ (void)applyNotificationContent:(UNNotificationRequest *)request toMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {
    notificationContent.title = request.content.userInfo[@"title"];
    notificationContent.body = request.content.userInfo[@"body"];
//    notificationContent.sound = [UNNotificationSound defaultSound];
}

@end

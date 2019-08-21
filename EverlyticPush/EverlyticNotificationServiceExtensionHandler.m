#import <UserNotifications/UserNotifications.h>
#import "EverlyticNotificationServiceExtensionHandler.h"
#import "EVENotificationEventsLog.h"
#import "EVEDefaults.h"
#import "EVEHttp.h"
#import "EVEEventsHelpers.h"

@implementation EverlyticNotificationServiceExtensionHandler

//NSMutableDictionary<NSString *, NSURLSessionDataTask *> *tasks = [[NSMutableDictionary alloc] init];

+ (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent  API_AVAILABLE(ios(10.0)){

    NSLog(@"Creating notification event...");

    id userInfo = request.content.userInfo;
    
    [EVEEventsHelpers storeDeliveryEventWithUserInfo:userInfo];
    [EVEEventsHelpers storeNotificationInLogWithUserInfo:userInfo];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [EVEEventsHelpers uploadPendingEventsWithCompletionHandler:^{
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    [self applyNotificationContent:request toMutableNotificationContent:notificationContent];
}

+ (void)serviceExtensionTimeWillExpireWithRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent  API_AVAILABLE(ios(10.0)){

    NSLog(@"Extension will time out. Cancelling network request and storing event for upload later");

    [self applyNotificationContent:request toMutableNotificationContent:notificationContent];
}

+ (EVESdkConfiguration *)sdkConfiguration {
    return [EVESdkConfiguration initFromConfigString:[EVEDefaults configurationString]];
}

+ (void)applyNotificationContent:(UNNotificationRequest *)request toMutableNotificationContent:(UNMutableNotificationContent *)notificationContent  API_AVAILABLE(ios(10.0)){
    notificationContent.title = request.content.userInfo[@"title"];
    notificationContent.body = request.content.userInfo[@"body"];
    notificationContent.sound = [UNNotificationSound defaultSound];
}

@end

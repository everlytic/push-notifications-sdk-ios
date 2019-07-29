#import <UserNotifications/UserNotifications.h>
#import "EverlyticNotificationServiceExtensionHandler.h"
#import "EVENotificationEventsLog.h"
#import "EVEDatabase.h"
#import "EVEDefaults.h"
#import "FMDatabaseQueue.h"
#import "EVEApi.h"
#import "EVEHttp.h"

@implementation EverlyticNotificationServiceExtensionHandler

//NSMutableDictionary<NSString *, NSURLSessionDataTask *> *tasks = [[NSMutableDictionary alloc] init];

+ (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {

    NSLog(@"Creating notification event... ");

    EVENotificationEvent *event = [self eventForNotificationRequest:request];

    [self synchronousRecordEvent:event];

    [self applyNotificationContent:request toMutableNotificationContent:notificationContent];
}

+ (void)synchronousRecordEvent:(EVENotificationEvent *)event {
    EVEApi *api = [[EVEApi alloc] initWithHttpInstance:[[EVEHttp alloc] initWithSdkConfiguration:self.sdkConfiguration]];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//
    NSURLSessionDataTask *task = [api recordDeliveryEvent:event completionHandler:^(EVEApiResponse *response, NSError *error) {
        __block BOOL stored = false;
        if (error != nil && !(error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled)) {
            stored = [self storeEvent:event];
        }
        NSLog(@"Event was stored=%d", stored);
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

+ (void)serviceExtensionTimeWillExpireWithRequest:(UNNotificationRequest *)request withMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {

    NSLog(@"Extension will time out. Cancelling network request and storing event for upload later");
    EVENotificationEvent *event = [self eventForNotificationRequest:request];

    __block BOOL success = NO;

    success = [self storeEvent:event];

    NSLog(@"Event stored successfully: %@", success ? @"YES" : @"NO");

    [self applyNotificationContent:request toMutableNotificationContent:notificationContent];
}

+ (BOOL)storeEvent:(EVENotificationEvent *)event {
    __block BOOL success;
    [EVEDatabase inDatabase:^(FMDatabase *db) {
        EVENotificationEventsLog *repo = [[EVENotificationEventsLog alloc] initWithDatabase:db];
        success = [repo insertNotificationEvent:event];
    }];
    return success;
}

+ (EVESdkConfiguration *)sdkConfiguration {
    return [EVESdkConfiguration initFromConfigString:[EVEDefaults configurationString]];
}

+ (EVENotificationEvent *)eventForNotificationRequest:(UNNotificationRequest *)request {
    EVENotificationEvent *event = [[EVENotificationEvent alloc]
            initWithType:DELIVERY
    notificationCenterId:request.identifier
          subscriptionId:EVEDefaults.subscriptionId
               messageId:[[NSNumber alloc] initWithInt:[request.content.userInfo[@"message_id"] intValue]]
                metadata:@{}
                datetime:nil
    ];
    return event;
}

+ (void)applyNotificationContent:(UNNotificationRequest *)request toMutableNotificationContent:(UNMutableNotificationContent *)notificationContent {
    notificationContent.title = request.content.userInfo[@"title"];
    notificationContent.body = [NSString stringWithFormat:@"deviceId=%@\ndbVersion=%@", EVEDefaults.deviceId, EVEDefaults.dbVersion];
//    notificationContent.sound = [UNNotificationSound defaultSound];
}

@end
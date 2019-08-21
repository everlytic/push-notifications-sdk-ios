#import "EVEEventsHelpers.h"
#import "EVEDefaults.h"
#import "EVEHttp.h"
#import "EVEApi.h"
#import "EVENotificationEventsLog.h"
#import "EVEDatabase.h"
#import "EVENotificationLog.h"

@implementation EVEEventsHelpers

+ (void)storeDeliveryEventWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@":storeDeliveryEventWithUserInfo()");
    [self storeEventWithUserInfo:userInfo type:DELIVERY];
}

+ (void)storeClickEventWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@":storeClickEventWithUserInfo()");
    [self storeEventWithUserInfo:userInfo type:CLICK];
}

+ (void)storeDismissEventWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@":storeDismissEventWithUserInfo()");
    [self storeEventWithUserInfo:userInfo type:DISMISS];
}

+ (void)storeNotificationInLogWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@":storeNotificationInLogWithUserInfo()");
    NSNumber *const messageId = @([userInfo[@"message_id"] intValue]);
    [EVEDatabase inDatabase:^(FMDatabase *database) {
        EVENotificationLog *log = [[EVENotificationLog alloc] initWithDatabase:database];
        bool success = [log insertNotificationWithMessageId:messageId
                              subscriptionId:[EVEDefaults subscriptionId]
                                   contactId:[EVEDefaults contactId]
                                       title:userInfo[@"title"]
                                        body:userInfo[@"body"]
                                    metadata:@{}
                                     actions:[EVENotificationLog decodeActions:userInfo]
                            customParameters:[EVENotificationLog decodeCustomParameters:userInfo]
                                     groupId:@0
                                  returnData:userInfo[@"ev_return_data"]
                                  receivedAt:[NSDate date]
                                      readAt:nil
                                 dismissedAt:nil
        ];

        NSLog(@"Inserted notification into log: %d", success);
    }];
}

+ (void)storeEventWithUserInfo:(NSDictionary *)userInfo type:(EVENotificationEventType)type {
    NSNumber *const messageId = @([userInfo[@"message_id"] intValue]);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    NSLog(@"%@", userInfo);

    EVENotificationEvent *event = [[EVENotificationEvent alloc]
            initWithId:nil
                  type:type
  notificationCenterId:nil
        subscriptionId:[EVEDefaults subscriptionId]
             messageId:messageId
              metadata:@{}
            returnData:userInfo[@"ev_return_data"]
              datetime:nil
    ];

    [EVEDatabase inDatabase:^(FMDatabase *database) {
        EVENotificationEventsLog *eventsLog = [[EVENotificationEventsLog alloc] initWithDatabase:database];
        [eventsLog insertNotificationEvent:event];
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

+ (void)uploadPendingEventsWithCompletionHandler:(void (^)())completionHandler {
    id configString = [EVEDefaults configurationString];
    [NSThread currentThread];

    if (configString != nil) {

        EVEHttp *http = [[EVEHttp alloc] initWithSdkConfiguration:[EVESdkConfiguration initFromConfigString:configString] reachabilityBlock:nil];
        id api = [[EVEApi alloc] initWithHttpInstance:http];

        [EVEDatabase inDatabase:^(FMDatabase *database) {
            EVENotificationEventsLog *eventsLog = [[EVENotificationEventsLog alloc] initWithDatabase:database];
            NSArray *events = [eventsLog pendingEvents];

            [self uploadEvents:events api:api onComplete:^{
                if (completionHandler != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler();
                    });
                }
            }];
        }];
    }

}

+ (void)uploadEvents:(NSArray *)events api:(id)api onComplete:(void (^)())onComplete {

    if ([events count] > 0) {
        id event = events[0];

        [self uploadEvent:event api:api onComplete:^{
            id remainingEvents = [events mutableCopy];
            [remainingEvents removeObject:event];

            // use a recursive function to upload
            [self uploadEvents:remainingEvents api:api onComplete:onComplete];
        }];
    } else {
        onComplete();
    }

}

+ (void)uploadEvent:(EVENotificationEvent *)event api:(id)api onComplete:(void (^)())onComplete {
    void (^ const removeEvent)(EVEApiResponse *, NSError *) = ^(EVEApiResponse *response, NSError *error) {
        if (error == nil) {
            NSLog(@"Successfully uploaded event(%@), removing from log", event.id);
            [EVEDatabase inDatabase:^(FMDatabase *db) {
                BOOL success = [[[EVENotificationEventsLog alloc] initWithDatabase:db] removeNotificationEventById:event.id];
                NSLog(@"Remove success: %d", success);

                onComplete();
            }];
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


@end

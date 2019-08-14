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
    NSNumber *const messageId = @([userInfo[@"message_id"] intValue]);
    [EVEDatabase inDatabase:^(FMDatabase *database) {
        EVENotificationLog *log = [[EVENotificationLog alloc] initWithDatabase:database];
        [log insertNotificationWithMessageId:messageId
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
//    dispatch_queue_t origQueue = dispatch_get_current_queue();

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (configString != nil) {

            EVEHttp *http = [[EVEHttp alloc] initWithSdkConfiguration:[EVESdkConfiguration initFromConfigString:configString] reachabilityBlock:nil];
            id api = [[EVEApi alloc] initWithHttpInstance:http];

            [EVEDatabase inDatabase:^(FMDatabase *database) {
                EVENotificationEventsLog *eventsLog = [[EVENotificationEventsLog alloc] initWithDatabase:database];
                NSArray *events = [eventsLog pendingEvents];

                for (EVENotificationEvent *event in events) {
#ifdef DEBUG
                    NSLog(@"Uploading event %@ type=%@", event.id, [EVENotificationEvent typeAsString:event.type]);
#endif
//                    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                    void (^ const removeEvent)(EVEApiResponse *, NSError *) = ^(EVEApiResponse *response, NSError *error) {
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            if (error == nil) {
                                NSLog(@"Successfully uploaded event(%@), removing from log", event.id);
                                [EVEDatabase inDatabase:^(FMDatabase *db) {
                                    BOOL success = [[[EVENotificationEventsLog alloc] initWithDatabase:db] removeNotificationEventById:event.id];
                                    NSLog(@"Remove success: %d", success);
                                }];
                            }
                            NSLog(@"Error: %@", error);
//                            dispatch_semaphore_signal(semaphore);
//                        });
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

//                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                }

                if (completionHandler != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler();
                    });
                }
            }];
        }
//    });

}


@end
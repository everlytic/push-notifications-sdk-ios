#import "EVENotificationEventsLog.h"
#import "EVENotificationEvent.h"
#import "FMDatabase.h"
#import "NSDate+EVEDateFormatter.h"
#import "EVEDefaults.h"
#import "EVEHelpers.h"
#import "FMResultSet.h"

@interface EVENotificationEventsLog ()
@property(strong, nonatomic) FMDatabase *database;
@end

@implementation EVENotificationEventsLog

NSString *const kLogTableName = @"notification_events_log";
NSString *const kLogId = @"_id";
NSString *const kLogIosNotificationCenterId = @"ios_notification_center_id";
NSString *const kLogEventType = @"event_type";
NSString *const kLogSubscriptionId = @"subscription_id";
NSString *const kLogMessageId = @"message_id";
NSString *const kLogDeviceId = @"device_id";
NSString *const kLogMetadata = @"metadata";
NSString *const kLogDatetime = @"datetime";

+ (NSString *)createTableStatement {
    return [NSString stringWithFormat:@"CREATE TABLE `%@` ("
                                      @"  `%@` INTEGER PRIMARY KEY AUTOINCREMENT,"
                                      @"  `%@` TEXT,"
                                      @"  `%@` TEXT NOT NULL,"
                                      @"  `%@` INTEGER NOT NULL,"
                                      @"  `%@` INTEGER NOT NULL,"
                                      @"  `%@` TEXT NOT NULL,"
                                      @"  `%@` TEXT NOT NULL DEFAULT '{}',"
                                      @"  `%@` TEXT NOT NULL"
                                      @"); "
                                      @"CREATE UNIQUE INDEX `idx_unq_message_id_event_type` on `%@` (`%@`, `%@`)",
                                      kLogTableName,
                                      kLogId,
                                      kLogIosNotificationCenterId,
                                      kLogEventType,
                                      kLogSubscriptionId,
                                      kLogMessageId,
                                      kLogDeviceId,
                                      kLogMetadata,
                                      kLogDatetime,
            // unq index vars
                                      kLogTableName,
                                      kLogMessageId,
                                      kLogEventType
    ];
}

+ (NSDictionary<NSNumber *, NSArray<NSString *> *> *)migrations {
    return @{};
}

- (BOOL)insertNotificationEvent:(EVENotificationEvent *)event {
    id sql = [NSString stringWithFormat:@"INSERT or REPLACE INTO `%@` ("
                                        @"  `%@`,"
                                        @"  `%@`,"
                                        @"  `%@`,"
                                        @"  `%@`,"
                                        @"  `%@`,"
                                        @"  `%@`,"
                                        @"  `%@`"
                                        @") VALUES ("
                                        @"  ?,?,?,?,?,?,?"
                                        @");",
                                        kLogTableName,
                                        kLogIosNotificationCenterId,
                                        kLogEventType,
                                        kLogSubscriptionId,
                                        kLogMessageId,
                                        kLogDeviceId,
                                        kLogMetadata,
                                        kLogDatetime
    ];

    BOOL result = [self.database
            executeUpdate:sql,
                          [event notification_center_id],
                          [EVENotificationEvent typeAsString:event.type],
                          [event subscription_id],
                          [event message_id],
                          [EVEDefaults deviceId],
                          [EVEHelpers encodeJSONFromObject:[event metadata]],
                          [[NSDate date] dateToIso8601String]
    ];

    return result;
}

- (NSArray<EVENotificationEvent *> *)pendingEventsForType:(EVENotificationEventType)type {
    id typeString = [EVENotificationEvent typeAsString:type];

    id sql = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE `%@` = ?;", kLogTableName, kLogEventType];

    FMResultSet *result = [self.database executeQuery:sql, typeString];

    NSMutableArray<EVENotificationEvent *> *events = [self eventsFromResultSet:result];

    return events;
}

- (NSArray<EVENotificationEvent *> *)pendingEvents {
    id sql = [NSString stringWithFormat:@"SELECT * FROM `%@`;", kLogTableName];

    FMResultSet *result = [self.database executeQuery:sql];

    NSMutableArray<EVENotificationEvent *> *events = [self eventsFromResultSet:result];

    return events;
}

- (NSMutableArray<EVENotificationEvent *> *)eventsFromResultSet:(FMResultSet *)result {
    NSMutableArray<EVENotificationEvent *> *events = [[NSMutableArray alloc] init];
    while ([result next]) {
        EVENotificationEvent *const e = [[EVENotificationEvent alloc]
                initWithId:@([result intForColumn:kLogId])
                      type:[EVENotificationEvent typeFromString:[result stringForColumn:kLogEventType]]
      notificationCenterId:[result stringForColumn:kLogIosNotificationCenterId]
            subscriptionId:@([result intForColumn:kLogSubscriptionId])
                 messageId:@([result intForColumn:kLogMessageId])
                  metadata:[EVEHelpers decodeJSONFromString:[result stringForColumn:kLogMetadata]]
                  datetime:[[EVEHelpers iso8601DateFormatter] dateFromString:[result stringForColumn:kLogDatetime]]
        ];

        [events addObject:e];
    }

    [result close];

    return events;
}


- (BOOL)removeNotificationEventById:(NSNumber *)eventId {
    id sql = @"DELETE FROM `notification_events_log` WHERE `_id` = ?";
    return [self.database executeUpdate:sql, eventId];
}

- (BOOL)removeNotificationEventByNotificationCenterId:(NSString *)notificationCenterId {
    id sql = @"DELETE FROM `notification_events_log` WHERE `ios_notification_center_id` = ?";
    return [self.database executeUpdate:sql, notificationCenterId];
}

@end

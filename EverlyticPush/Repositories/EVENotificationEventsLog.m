#import "EVENotificationEventsLog.h"
#import "EVENotificationEvent.h"
#import "FMDatabase.h"
#import "NSDate+EVEDateFormatter.h"
#import "EVEDefaults.h"

@interface EVENotificationEventsLog ()
@property(strong, nonatomic) FMDatabase *database;
@end

@implementation EVENotificationEventsLog

+ (NSString *)createTableStatement {
    return @"CREATE TABLE `notification_events_log` ("
           @"  `_id` INTEGER PRIMARY KEY AUTOINCREMENT,"
           @"  `ios_notification_center_id` INTEGER NOT NULL,"
           @"  `event_type` TEXT NOT NULL,"
           @"  `subscription_id` INTEGER NOT NULL,"
           @"  `message_id` INTEGER NOT NULL,"
           @"  `device_id` TEXT NOT NULL,"
           @"  `metadata` TEXT NOT NULL DEFAULT '{}',"
           @"  `datetime` TEXT NOT NULL"
           @");";
}

+ (NSDictionary<NSNumber *, NSArray<NSString *> *> *)migrations {
    return @{};
}

- (BOOL)insertNotificationEvent:(EVENotificationEvent *)event {
    id sql = @"INSERT INTO `notification_events_log` ("
             @"  `ios_notification_center_id`,"
             @"  `event_type`, "
             @"  `subscription_id`, "
             @"  `message_id`, "
             @"  `device_id`, "
             @"  `metadata`, "
             @"  `datetime`"
             @") VALUES ("
             @"  ?,?,?,?,?,?,?"
             @");";

    return [self.database
            executeUpdate:sql,
                          [event notification_center_id],
                          [event typeAsString],
                          [event subscription_id],
                          [event message_id],
                          [EVEDefaults deviceId],
                          [event metadata],
                          [[NSDate date] dateToIso8601String]
    ];
}

- (NSArray<EVENotificationEvent *> *)allPendingEventsForType:(EVENotificationEventType *)type {
    return nil;
}

- (BOOL)removeNotificationEventById:(unsigned int)eventId {
    return 0;
}


@end

#import "EVENotificationEventsLog.h"
#import "EVENotificationEvent.h"

@interface EVENotificationEventsLog ()
@property(strong, nonatomic) FMDatabase *database;
@end

@implementation EVENotificationEventsLog

+ (NSString *)createTableStatement {
    return @"CREATE TABLE `notification_events_log` ("
           @"  `_id` INTEGER PRIMARY KEY AUTOINCREMENT,"
           @"  `android_notification_id` INTEGER NOT NULL,"
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

- (bool)insertNotificationEvent:(EVENotificationEvent *)event {
    return 0;
}

- (NSArray<EVENotificationEvent *> *)allPendingEventsForType:(EVENotificationEventType *)type {
    return nil;
}

- (bool)removeNotificationEventById:(unsigned int)id1 {
    return 0;
}


@end
#import <UserNotifications/UserNotifications.h>
#import "EVENotificationLog.h"
#import "FMDatabase.h"

@interface EVENotificationLog ()
@property(strong, nonatomic) FMDatabase *database;
@end

@implementation EVENotificationLog
+ (NSString *)createTableStatement {
    return @"CREATE TABLE `notification_log` ("
           @"  `_id` INTEGER PRIMARY KEY AUTOINCREMENT,"
           @"  `message_id` INTEGER,"
           @"  `ios_notification_center_id` TEXT,"
           @"  `subscription_id` INTEGER,"
           @"  `contact_id` INTEGER,"
           @"  `title` TEXT,"
           @"  `body` TEXT,"
           @"  `metadata` TEXT DEFAULT '{}',"
           @"  `actions` TEXT,"
           @"  `custom_parameters` TEXT,"
           @"  `group_id` INTEGER DEFAULT 0,"
           @"  `raw_notification` TEXT,"
           @"  `received_at` TEXT NOT NULL,"
           @"  `read_at` TEXT DEFAULT NULL,"
           @"  `dismissed_at` TEXT DEFAULT NULL"
           @");";
}

+ (NSDictionary<NSNumber *, NSArray<NSString *> *> *)migrations {
    return @{};
}

- (bool)insertNotification:(UNNotification *)notification subscriptionId:(long)subscriptionId contactId:(long)contactId {
    id sql =
            @"INSERT INTO `notification_log` "
            @"(`message_id`, `ios_notification_identifier`, `subscription_id`, `contact_id`, `title`, `body`, `metadata`,"
            @"  `actions`, `custom_parameters`, `group_id`, `raw_notification`, `received_at`, `read_at`, `dismissed_at`)"
            @" VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
//    [self.database executeUpdate:sql, ]
    return 0;
}

- (bool)setNotificationById:(unsigned int)notificationId asRead:(bool)asRead {
    return 0;
}

- (bool)setNotificationById:(unsigned int)notificationId asDismissed:(bool)asDismissed {
    return 0;
}

- (id)publicNotificationHistory {
    return nil;
}

- (bool)clearNotificationHistory {
    return 0;
}


@end
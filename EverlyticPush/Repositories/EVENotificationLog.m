#import <UserNotifications/UserNotifications.h>
#import "EVENotificationLog.h"
#import "FMDatabase.h"
#import "EVEHelpers.h"
#import "NSDate+EVEDateFormatter.h"
#import "EverlyticNotification.h"

@interface EVENotificationLog ()
@property(strong, nonatomic) FMDatabase *database;
@end

@implementation EVENotificationLog

+ (NSString *)createTableStatement {
    return [NSString stringWithFormat:@"CREATE TABLE `notification_log` ("
                                      @"  `_id` INTEGER PRIMARY KEY AUTOINCREMENT,"
                                      @"  `message_id` INTEGER UNIQUE,"
                                      @"  `subscription_id` INTEGER,"
                                      @"  `contact_id` INTEGER,"
                                      @"  `title` TEXT,"
                                      @"  `body` TEXT,"
                                      @"  `metadata` TEXT DEFAULT '{}',"
                                      @"  `actions` TEXT,"
                                      @"  `custom_parameters` TEXT,"
                                      @"  `group_id` INTEGER DEFAULT 0,"
                                      @"  `raw_notification` TEXT,"
                                      @"  `return_data` TEXT DEFAULT NULL,"
                                      @"  `received_at` TEXT NOT NULL,"
                                      @"  `read_at` TEXT DEFAULT NULL,"
                                      @"  `dismissed_at` TEXT DEFAULT NULL"
                                      @");"
                                      /*@"CREATE UNIQUE INDEX idx_unq_message_id ON `notification_log` (`message_id`)"*/];
}

+ (NSDictionary<NSNumber *, NSArray<NSString *> *> *)migrations {
    return @{};
}

- (bool)insertNotificationWithMessageId:(NSNumber *_Nonnull)messageId subscriptionId:(NSNumber *_Nonnull)subscriptionId contactId:(NSNumber *_Nonnull)contactId title:(NSString *_Nullable)title body:(NSString *_Nonnull)body metadata:(NSDictionary *_Nullable)metadata actions:(NSDictionary *_Nullable)actions customParameters:(NSDictionary *_Nullable)customParameters groupId:(NSNumber *_Nonnull)groupId returnData:(NSString *_Nullable)returnData receivedAt:(NSDate *_Nullable)receivedAt readAt:(NSDate *_Nullable)readAt dismissedAt:(NSDate *_Nullable)dismissedAt {
    id sql =
            @"INSERT or REPLACE INTO `notification_log` "
            "("
            "`message_id`, "
            "`subscription_id`, "
            "`contact_id`, "
            "`title`, "
            "`body`, "
            "`metadata`,"
            "`actions`, "
            "`custom_parameters`, "
            "`group_id`, "
            "`raw_notification`, "
            "`received_at`, "
            "`read_at`, "
            "`dismissed_at`, "
            "`return_data`"
            ")"
            @" VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

    return [_database executeUpdate:sql,
                                    messageId,
                                    subscriptionId,
                                    contactId,
                                    title,
                                    body,
                                    [EVEHelpers encodeJSONFromObject:metadata],
                                    [EVEHelpers encodeJSONFromObject:actions],
                                    [EVEHelpers encodeJSONFromObject:customParameters],
                                    groupId,
                    nil,
                                    [receivedAt dateToIso8601String],
                                    [readAt dateToIso8601String],
                                    [dismissedAt dateToIso8601String],
                                    returnData
    ];
}


- (bool)setNotificationByMessageId:(NSNumber *)messageId asRead:(bool)asRead {
    id sql = @"UPDATE `notification_log` SET `read_at` = ? WHERE `message_id` = ?";

    return [_database executeUpdate:sql,
                    asRead ? [[NSDate date] dateToIso8601String] : nil,
                                    messageId
    ];
}

- (bool)setNotificationByMessageId:(NSNumber *)messageId asDismissed:(bool)asDismissed {
    id sql = @"UPDATE `notification_log` SET `dismissed_at` = ? WHERE `message_id` = ?";

    return [_database executeUpdate:sql,
                    asDismissed ? [[NSDate date] dateToIso8601String] : nil,
                                    messageId
    ];
}


- (id)publicNotificationHistory {
    id sql = @"SELECT * FROM `notification_log`;";

    FMResultSet *results = [_database executeQuery:sql];

    NSLog(@"publicNotificationHistory(): result state is nil = %d", results == nil);

    NSMutableArray *notifications = [[NSMutableArray alloc] init];
    NSDateFormatter *const df = [EVEHelpers iso8601DateFormatter];
    while ([results next]) {
        NSLog(@"publicNotificationHistory(): retrieved result");

        id messageId = @([results intForColumn:@"message_id"]);
        id title = [results stringForColumn:@"title"];
        id body = [results stringForColumn:@"body"];
        id receivedAt = [df dateFromString:[results stringForColumn:@"received_at"]];
        id readAt = [df dateFromString:[results stringForColumn:@"read_at"]];
        id dismissedAt = [df dateFromString:[results stringForColumn:@"dismissed_at"]];
        id customAttributes = [EVEHelpers decodeJSONFromString:[results stringForColumn:@"custom_parameters"]];

        EverlyticNotification *nf = [[EverlyticNotification alloc]
                initWithMessageId:messageId
                            title:title
                             body:body
                       receivedAt:receivedAt
                           readAt:readAt
                      dismissedAt:dismissedAt
                 customAttributes:customAttributes
        ];

        [notifications addObject:nf];
    }

    [results close];

    NSLog(@"publicNotificationHistory(): notifications in array: %lu", notifications.count);

    return notifications;
}

- (bool)clearNotificationHistory {
    id sql = @"DELETE FROM `notification_log` WHERE 1=1";

    return [_database executeUpdate:sql];
}

+ (NSDictionary *)decodeActions:(NSDictionary *)dictionary {
    NSMutableDictionary *actions = [[NSMutableDictionary alloc] init];

    for (NSString *key in [dictionary allKeys]) {

        if ([key characterAtIndex:0] == kActionPrefix) {
            actions[[key substringFromIndex:1]] = dictionary[key];
        }
    }

    return actions;
}

+ (NSDictionary *)decodeCustomParameters:(NSDictionary *)dictionary {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    for (NSString *key in [dictionary allKeys]) {
        if ([key characterAtIndex:0] == kCustomAttributePrefix) {
            params[[key substringFromIndex:1]] = dictionary[key];
        }
    }

    return params;
}

- (NSNumber *)publicNotificationHistoryCount {
    id sql = @"SELECT count(message_id) from `notification_log`";

    FMResultSet *results = [_database executeQuery:sql];

    NSNumber *count = @0;

    if ([results next]) {
        count = @([results intForColumnIndex:0]);
    }

    return count;
}

@end
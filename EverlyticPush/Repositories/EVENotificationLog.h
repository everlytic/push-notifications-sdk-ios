#import <Foundation/Foundation.h>
#import "EVEDbRepository.h"

@class FMDatabase;
@class UNNotification;

static const int kActionPrefix = '@';
static const int kCustomAttributePrefix = '$';

@interface EVENotificationLog : EVEDbRepository

- (bool)insertNotificationWithMessageId:(NSNumber *_Nonnull)messageId
                         subscriptionId:(NSNumber *_Nonnull)subscriptionId
                              contactId:(NSNumber *_Nonnull)contactId
                                  title:(NSString *_Nullable)title
                                   body:(NSString *_Nonnull)body
                               metadata:(NSDictionary *_Nullable)metadata
                                actions:(NSDictionary *_Nullable)actions
                       customParameters:(NSDictionary *_Nullable)customParameters
                                groupId:(NSNumber *_Nonnull)groupId
                             returnData:(NSString *_Nullable)returnData
                             receivedAt:(NSDate *_Nullable)receivedAt
                                 readAt:(NSDate *_Nullable)readAt
                            dismissedAt:(NSDate *_Nullable)dismissedAt;

- (bool)setNotificationByMessageId:(NSNumber *_Nonnull)messageId asRead:(bool)asRead;

- (bool)setNotificationByMessageId:(NSNumber *)messageId asDismissed:(bool)asDismissed;

- (id)publicNotificationHistory;

- (NSNumber *)publicNotificationHistoryCount;

- (bool)clearNotificationHistory;

+ (NSDictionary *)decodeActions:(NSDictionary *)dictionary;

+ (NSDictionary *)decodeCustomParameters:(NSDictionary *)dictionary;
@end
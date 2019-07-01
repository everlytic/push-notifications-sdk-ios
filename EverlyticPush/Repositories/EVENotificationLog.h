#import <Foundation/Foundation.h>
#import "EVEDbRepository.h"

@class FMDatabase;
@class UNNotification;


@interface EVENotificationLog : EVEDbRepository

- (bool) insertNotification:(UNNotification *)notification subscriptionId:(long)subscriptionId contactId:(long)contactId;

- (bool) setNotificationById:(unsigned int)notificationId asRead:(bool)asRead;

- (bool) setNotificationById:(unsigned int)notificationId asDismissed:(bool)asDismissed;

- (id) publicNotificationHistory;

- (bool) clearNotificationHistory;
@end
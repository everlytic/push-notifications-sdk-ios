#import <Foundation/Foundation.h>
#import "EVEDbRepository.h"
#import "EVENotificationEvent.h"

@class EVENotificationEvent;


@interface EVENotificationEventsLog : EVEDbRepository

- (BOOL) insertNotificationEvent:(EVENotificationEvent *)event;

- (NSArray<EVENotificationEvent *> *) pendingEventsForType:(EVENotificationEventType)type;
- (NSArray<EVENotificationEvent *> *) pendingEvents;

- (BOOL) removeNotificationEventById:(NSNumber *)eventId;
- (BOOL) removeNotificationEventByNotificationCenterId:(NSString *)notificationCenterId;
@end
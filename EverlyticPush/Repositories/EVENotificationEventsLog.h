#import <Foundation/Foundation.h>
#import "EVEDbRepository.h"
#import "EVENotificationEvent.h"

@class EVENotificationEvent;


@interface EVENotificationEventsLog : EVEDbRepository

- (BOOL) insertNotificationEvent:(EVENotificationEvent *)event;

- (NSArray<EVENotificationEvent *> *) allPendingEventsForType:(EVENotificationEventType *)type;

- (BOOL) removeNotificationEventById:(unsigned int)eventId;
@end
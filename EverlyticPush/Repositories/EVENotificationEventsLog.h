#import <Foundation/Foundation.h>
#import "EVEDbRepository.h"
#import "EVENotificationEvent.h"

@class EVENotificationEvent;


@interface EVENotificationEventsLog : EVEDbRepository

- (bool) insertNotificationEvent:(EVENotificationEvent *)event;

- (NSArray<EVENotificationEvent *> *) allPendingEventsForType:(EVENotificationEventType *)type;

- (bool) removeNotificationEventById:(unsigned int)id;
@end
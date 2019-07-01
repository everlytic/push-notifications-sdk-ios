#import <Foundation/Foundation.h>
#import "EVEModel.h"

typedef enum {
    DELIVERY,
    CLICK,
    DISMISS,
    UNKNOWN
} EVENotificationEventType;

@interface EVENotificationEvent : NSObject<EVEModel>

@property (strong, nonatomic) NSNumber *subscription_id;
@property (strong, nonatomic) NSNumber *message_id;
@property (strong, nonatomic) NSDictionary *metadata;
@property (strong, nonatomic) NSDate *datetime;
@property (nonatomic) EVENotificationEventType *type;

@end
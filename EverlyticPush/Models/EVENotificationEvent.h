#import <Foundation/Foundation.h>
#import "EVEModel.h"

typedef enum {
    DELIVERY,
    CLICK,
    DISMISS,
    UNKNOWN
} EVENotificationEventType;

@interface EVENotificationEvent : NSObject<EVEModel>

- (instancetype) initWithType:(EVENotificationEventType)type notificationCenterId:(NSString *)nfcId subscriptionId:(unsigned long)subId messageId:(unsigned long)msgId metadata:(NSDictionary *)meta;

@property (strong, nonatomic) NSString *notification_center_id;
@property (nonatomic) unsigned long subscription_id;
@property (nonatomic) unsigned long message_id;
@property (strong, nonatomic) NSDictionary *metadata;
@property (strong, nonatomic) NSDate *datetime;
@property (nonatomic) EVENotificationEventType type;

- (NSString *) typeAsString;

@end

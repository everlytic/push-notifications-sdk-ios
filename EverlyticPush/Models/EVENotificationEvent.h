#import <Foundation/Foundation.h>
#import "EVEModel.h"

typedef enum {
    DELIVERY,
    CLICK,
    DISMISS,
    UNKNOWN
} EVENotificationEventType;

@interface EVENotificationEvent : NSObject<EVEModel>

- (instancetype)initWithType:(EVENotificationEventType)type notificationCenterId:(NSString *)nfcId subscriptionId:(NSNumber *)subId messageId:(NSNumber *)msgId metadata:(NSDictionary *)meta datetime:(NSDate *_Nullable)date;

@property (strong, nonatomic) NSString *notification_center_id;
@property (strong, nonatomic) NSNumber *subscription_id;
@property (strong, nonatomic) NSNumber *message_id;
@property (strong, nonatomic) NSDictionary *metadata;
@property (strong, nonatomic) NSDate *datetime;
@property (nonatomic) EVENotificationEventType type;

+ (EVENotificationEventType)typeFromString:(NSString *)string;
+ (NSString *)typeAsString:(EVENotificationEventType)type;

@end

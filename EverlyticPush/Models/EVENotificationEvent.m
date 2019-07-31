#import "EVENotificationEvent.h"
#import "EVEHelpers.h"
#import "NSDate+EVEDateFormatter.h"


@implementation EVENotificationEvent

- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"subscription_id": self.subscription_id,
            @"message_id": self.message_id,
            @"metadata": self.metadata,
            @"type": [EVENotificationEvent typeAsString:self.type],
            @"datetime": [self.datetime dateToIso8601String]
    };
}

- (instancetype)initWithId:(NSNumber *)id type:(EVENotificationEventType)type notificationCenterId:(NSString *)nfcId subscriptionId:(NSNumber *)subId messageId:(NSNumber *)msgId metadata:(NSDictionary *)meta datetime:(NSDate *_Nullable)date {
    self.id = id;
    self.type = type;
    self.notification_center_id = nfcId;
    self.message_id = msgId;
    self.subscription_id = subId;
    self.metadata = meta;
    self.datetime = (date == nil) ? [NSDate date] : date;
    return self;
}

+ (NSString *)typeAsString:(EVENotificationEventType)type {
    NSString *typeVal = nil;

    switch (type) {
        case DELIVERY:
            typeVal = @"DELIVERY";
            break;
        case CLICK:
            typeVal = @"CLICK";
            break;
        case DISMISS:
            typeVal = @"DISMISS";
            break;
        case UNKNOWN:
        default:
            typeVal = @"UNKNOWN";
    }

    return typeVal;
}


+(EVENotificationEventType) typeFromString:(NSString *)string {
    if ([string isEqualToString:@"DELIVERY"]) {
        return DELIVERY;
    }
    if ([string isEqualToString:@"CLICK"]) {
        return CLICK;
    }
    if ([string isEqualToString:@"DISMISS"]) {
        return DISMISS;
    }

    return UNKNOWN;
}

- (nonnull NSString *)serializeAsJson {
    return [EVEHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id _Nonnull)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

    [description appendFormat:@"event=%@", [self serializeAsJson]];

    [description appendString:@">"];
    return description;
}


@end

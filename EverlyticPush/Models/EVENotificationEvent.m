#import "EVENotificationEvent.h"
#import "EVEHelpers.h"
#import "NSDate+EVEDateFormatter.h"


@implementation EVENotificationEvent

- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"ios_notification_center_id": self.notification_center_id,
            @"subscription_id": @(self.subscription_id),
            @"message_id": @(self.message_id),
            @"metadata": self.metadata,
            @"type": self.typeAsString,
            @"datetime": [self.datetime dateToIso8601String]
    };
}

- (instancetype)initWithType:(EVENotificationEventType)type notificationCenterId:(NSString *)nfcId subscriptionId:(unsigned long)subId messageId:(unsigned long)msgId metadata:(NSDictionary *)meta {
    self.type = type;
    self.notification_center_id = nfcId;
    self.message_id = msgId;
    self.subscription_id = subId;
    self.metadata = meta;
    self.datetime = [NSDate date];
    return self;
}

- (NSString *)typeAsString {
    NSString *typeVal = nil;

    switch (self.type) {
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

- (nonnull NSString *)serializeAsJson {
    return [EVEHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id _Nonnull)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}


@end

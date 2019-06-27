#import "EVENotificationEvent.h"
#import "EVEHelpers.h"


@implementation EVENotificationEvent {

}

- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"subscription_id": self.subscription_id,
            @"message_id": self.message_id,
            @"metadata": self.metadata,
            @"datetime": [[EVEHelpers iso8601DateFormatter] stringFromDate:self.datetime]
    };
}

- (nonnull NSString *)serializeAsJson {
    return [EVEHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id _Nonnull)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}


@end
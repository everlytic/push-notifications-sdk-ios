#import "PMANotificationEvent.h"
#import "PMAHelpers.h"


@implementation PMANotificationEvent {

}

- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"subscription_id": self.subscription_id,
            @"message_id": self.message_id,
            @"metadata": self.metadata,
            @"datetime": [[PMAHelpers iso8601DateFormatter] stringFromDate:self.datetime]
    };
}

- (nonnull NSString *)serializeAsJson {
    return [PMAHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id _Nonnull)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}


@end
#import "EVEUnsubscribeEvent.h"
#import "EVEHelpers.h"
#import "NSDate+EVEDateFormatter.h"


@implementation EVEUnsubscribeEvent

- (instancetype)initWithSubscriptionId:(NSNumber *)subscriptionId deviceId:(NSString *)deviceId {
    self.subscription_id = subscriptionId;
    self.device_id = deviceId;
    self.datetime = [NSDate date];
    self.metadata = @{};
    return self;
}


- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"subscription_id": self.subscription_id,
            @"device_id": self.device_id,
            @"datetime": [self.datetime dateToIso8601String],
            @"metadata": self.metadata
    };
}

- (nonnull NSString *)serializeAsJson {
    return [EVEHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}


@end
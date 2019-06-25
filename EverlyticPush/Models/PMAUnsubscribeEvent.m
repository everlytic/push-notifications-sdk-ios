#import "PMAUnsubscribeEvent.h"
#import "PMAHelpers.h"


@implementation PMAUnsubscribeEvent

- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"subscription_id": self.subscription_id,
            @"device_id": self.device_id,
            @"datetime": self.datetime,
            @"metadata": self.metadata
    };
}

- (nonnull NSString *)serializeAsJson {
    return [PMAHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}


@end
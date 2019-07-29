#import "EVEApiResponse.h"
#import "EVEHelpers.h"


@implementation EVEApiResponse {

}

- (EVEApiResponse *)initWithStatus:(NSString *)status data:(NSDictionary *)data {

    self.status = status;
    self.data = data;

    self.isSuccessful = ![self.status isEqualToString:@"error"];

    return self;
}

- (NSString *)dataAsJsonString {
    return [EVEHelpers encodeJSONFromObject:self.data];
}


- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"status": self.status,
            @"data": self.data
    };
}

- (nonnull NSString *)serializeAsJson {
    return [EVEHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    NSDictionary *object = [EVEHelpers decodeJSONFromString:string];

    return [[EVEApiResponse alloc] initWithStatus:[object valueForKey:@"status"] data:[object valueForKey:@"data"]];
}


@end
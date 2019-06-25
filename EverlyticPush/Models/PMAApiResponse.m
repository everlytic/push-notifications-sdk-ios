#import "PMAApiResponse.h"
#import "PMAHelpers.h"


@implementation PMAApiResponse {

}

- (PMAApiResponse *)initWithStatus:(NSString *)status data:(NSDictionary *)data {

    self.status = status;
    self.data = data;

    self.isSuccessful = (BOOL *) ![self.status isEqualToString:@"error"];

    return self;
}

- (NSString *)dataAsJsonString {
    return [PMAHelpers encodeJSONFromObject:self.data];
}


- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"status": self.status,
            @"data": self.data
    };
}

- (nonnull NSString *)serializeAsJson {
    return [PMAHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    NSDictionary *object = [PMAHelpers decodeJSONFromString:string];

    return [[PMAApiResponse alloc] initWithStatus:[object valueForKey:@"status"] data:[object valueForKey:@"data"]];
}


@end

#import "PMAHelpers.h"


@implementation PMAHelpers
+ (id)decodeJSONFromString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];

    if (err) @throw err;

    return object;
}

@end
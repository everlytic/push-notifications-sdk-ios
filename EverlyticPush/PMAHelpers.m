
#import "PMAHelpers.h"


@implementation PMAHelpers
+ (id)decodeJSONFromString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];

    if (err) @throw err;

    return object;
}

+ (NSString *)encodeJSONFromObject:(id)object {
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:object options:0 error:nil]
                                 encoding:NSUTF8StringEncoding];
}


+ (NSDateFormatter *)iso8601DateFormatter {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];

    return dateFormatter;
}

@end
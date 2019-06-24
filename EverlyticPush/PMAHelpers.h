
#import <Foundation/Foundation.h>

@interface PMAHelpers : NSObject

+ (id)decodeJSONFromString:(NSString *)jsonString;
+ (id)encodeJSONFromObject:(id)object;

+ (NSDateFormatter *)iso8601DateFormatter;

@end
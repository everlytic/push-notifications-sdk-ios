
#import <Foundation/Foundation.h>

@interface EVEHelpers : NSObject

+ (id)decodeJSONFromString:(NSString *)jsonString;
+ (id)encodeJSONFromObject:(id)object;

+ (NSDateFormatter *)iso8601DateFormatter;

+ (BOOL) iosVersionIsGreaterOrEqualTo:(float) version;
+ (BOOL) iosVersionIsLessThan:(float) version;

@end
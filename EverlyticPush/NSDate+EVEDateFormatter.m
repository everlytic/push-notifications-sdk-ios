#import "NSDate+EVEDateFormatter.h"
#import "EVEHelpers.h"


@implementation NSDate (EVEDateFormatter)

- (NSString *)dateToIso8601String {
    return [[EVEHelpers iso8601DateFormatter] stringFromDate:self];
}


@end
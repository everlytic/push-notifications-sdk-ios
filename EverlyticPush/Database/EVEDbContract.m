#import "EVEDbContract.h"
#import "EVENotificationLog.h"
#import "EVENotificationEventsLog.h"


@implementation EVEDbContract

- (NSArray<NSString *> *)tableCreateStatements {

    return @[
            [EVENotificationLog createTableStatement],
            [EVENotificationEventsLog createTableStatement]
    ];
}

- (NSArray<NSArray *> *)migrations {
    return @[];
}


@end
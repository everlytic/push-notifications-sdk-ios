#import <Foundation/Foundation.h>
#import "EVENotificationSystemSettings.h"


@interface EVENotificationSystemSettings10 : NSObject<EVENotificationSystemSettings>

- (instancetype) initWithDelegate:(id <UNUserNotificationCenterDelegate>)delegate;

@end
#import <UIKit/UIKit.h>
#import "EVENotificationSystemSettings8.h"

@interface EVENotificationSystemSettings8 ()
@property (strong, nonatomic) UIApplication *application;
@end

@implementation EVENotificationSystemSettings8

- (instancetype)initWithApplication:(UIApplication *)application {
    self.application = application;
    return self;
}


- (void)promptForNotifications:(void (^)(BOOL accepted))completionHandler {
    UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[self application] registerUserNotificationSettings:settings];
}


@end
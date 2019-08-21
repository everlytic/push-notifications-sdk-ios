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

- (void)getNotificationAuthorizationStatus:(void (^)(BOOL authorized))completionHandler {

    BOOL authorized = NO;

    if (([[self application] currentUserNotificationSettings].types & UIUserNotificationTypeAlert) != 0) {
        authorized = YES;
    }

    if (([[self application] currentUserNotificationSettings].types & UIUserNotificationTypeSound) != 0) {
        authorized = YES;
    }

    if (([[self application] currentUserNotificationSettings].types & UIUserNotificationTypeBadge) != 0) {
        authorized = YES;
    }

    completionHandler(authorized);
}


@end
#import <UserNotifications/UserNotifications.h>
#import "EVENotificationSystemSettings10.h"
#import "EVEHelpers.h"

@interface EVENotificationSystemSettings10 ()
@property(strong, nonatomic) id <UNUserNotificationCenterDelegate> notificationDelegate;
@property(strong, nonatomic) UNUserNotificationCenter *notificationCenter;
@end

@implementation EVENotificationSystemSettings10
NSString *const kEverlyticNotificationGeneral = @"everlytic-notification-general";

- (instancetype)initWithDelegate:(id <UNUserNotificationCenterDelegate>)delegate {
    self.notificationDelegate = delegate;
    self.notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    self.notificationCenter.delegate = self.notificationDelegate;
    return self;
}

- (void)promptForNotifications:(void (^)(BOOL accepted))completionHandler {
    UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;

    UNNotificationCategoryOptions categoryOptions = UNNotificationCategoryOptionCustomDismissAction;

    id category = [UNNotificationCategory
            categoryWithIdentifier:kEverlyticNotificationGeneral
                           actions:nil
                 intentIdentifiers:@[kEverlyticNotificationGeneral]
                           options:categoryOptions
    ];

    [self.notificationCenter setNotificationCategories:[[NSSet alloc] initWithArray:@[category]]];
    [self.notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        settings.authorizationStatus;
    }];
    [self.notificationCenter
            requestAuthorizationWithOptions:authOptions
                          completionHandler:^(BOOL granted, NSError *_Nullable error) {
                              if (completionHandler != nil) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      completionHandler(granted);
                                  });
                              }
                          }
    ];

}

- (void)getNotificationAuthorizationStatus:(void (^)(BOOL authorized))completionHandler {
    [self.notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        BOOL authorized = NO;

        if ([EVEHelpers iosVersionIsGreaterOrEqualTo:12]) {
            if (settings.authorizationStatus == UNAuthorizationStatusProvisional) {
                authorized = YES;
            }
        }

        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            authorized = YES;
        }

        completionHandler(authorized);
    }];
}


@end
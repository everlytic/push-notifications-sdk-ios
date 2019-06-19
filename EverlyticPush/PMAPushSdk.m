#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "PMAPushSdk.h"
#import "PMAFIRMessagingDelegate.h"
#import "Models/PMA_Subscription.h"
@import Firebase;

@interface PMAPushSdk () <UNUserNotificationCenterDelegate>

@end

@implementation PMAPushSdk

PMAFIRMessagingDelegate *pmafirMessagingDelegate;
PMASdkConfiguration *sdkConfiguration;

- (PMAPushSdk *)initWithConfiguration:(PMASdkConfiguration *)configuration {
    sdkConfiguration = configuration;
    if ([FIRApp defaultApp] == nil) {
        NSLog(@"[FIRApp defaultApp] is nil, configuring FIRApp now...");
        [FIRApp configure];
        pmafirMessagingDelegate = [[PMAFIRMessagingDelegate alloc] init];
        [FIRMessaging messaging].delegate = pmafirMessagingDelegate;
    }
    
    return self;
}

- (void)promptForNotificationWithUserResponse:(void (^)(BOOL consentGranted))completionHandler {
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
                UNAuthorizationOptionSound | UNAuthorizationOptionBadge;

        [[UNUserNotificationCenter currentNotificationCenter]
                requestAuthorizationWithOptions:authOptions
                              completionHandler:^(BOOL granted, NSError *_Nullable error) {
                                  if (completionHandler != nil) {
                                      completionHandler(granted);
                                  }
                              }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
                (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
                [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[self application] registerUserNotificationSettings:settings];
    }


    [[self application] registerForRemoteNotifications];
}

- (void)subscribeUserWithEmailAddress:(NSString *)emailAddress {

    PMA_ContactData *contact = [[PMA_ContactData alloc] initWithEmail:emailAddress pushToken:]

    PMA_Subscription *subscription = [[PMA_Subscription alloc]
            initWithPushProjectUuid:sdkConfiguration.projectId
            contactData:<#(PMA_ContactData *)contactData#> deviceData:<#(PMA_DeviceData *)deviceData#>];
}


- (UIApplication *)application {
    return [UIApplication sharedApplication];
}

@end

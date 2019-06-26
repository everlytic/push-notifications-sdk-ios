#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "PMAPushSdk.h"
#import "PMAFIRMessagingDelegate.h"
#import "Models/PMASubscriptionEvent.h"
#import "PMADefaults.h"
#import "Http/PMAHttp.h"
#import "PMAApi.h"
#import "PMAApiSubscription.h"
@import Firebase;

@interface PMAPushSdk () <UNUserNotificationCenterDelegate>

@property (strong, nonatomic) PMAHttp *http;
@property (strong, nonatomic) PMAApi *api;
@property (strong, nonatomic) PMAFIRMessagingDelegate *pmafirMessagingDelegate;
@property (strong, nonatomic) PMASdkConfiguration *sdkConfiguration;

@end

@implementation PMAPushSdk



- (PMAPushSdk *)initWithConfiguration:(PMASdkConfiguration *)configuration {
    self.sdkConfiguration = configuration;

    if ([PMADefaults deviceId] == nil) {
        [PMADefaults setDeviceId:[[NSUUID UUID] UUIDString]];
    }

    if ([FIRApp defaultApp] == nil) {
        NSLog(@"[FIRApp defaultApp] is nil, configuring FIRApp now...");
        [FIRApp configure];
        self.pmafirMessagingDelegate = [[PMAFIRMessagingDelegate alloc] init];
        [FIRMessaging messaging].delegate = self.pmafirMessagingDelegate;
    }

    self.http = [[PMAHttp alloc] initWithSdkConfiguration:self.sdkConfiguration];
    self.api = [[PMAApi alloc] initWithHttpInstance:self.http];
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

- (void)subscribeUserWithEmailAddress:(NSString *)emailAddress completionHandler:(void(^)(BOOL, NSError *)) completionHandler{

    PMA_ContactData *contact = [[PMA_ContactData alloc] initWithEmail:emailAddress pushToken:PMADefaults.fcmToken];
    PMA_DeviceData *deviceData = [[PMA_DeviceData alloc] initWithId:PMADefaults.deviceId];
    PMASubscriptionEvent *subscription = [[PMASubscriptionEvent alloc]
            initWithPushProjectUuid:self.sdkConfiguration.projectId
                        contactData:contact deviceData:deviceData];

    [self.api subscribeWithSubscriptionEvent:subscription completionHandler:^(PMAApiSubscription *subscription, NSError *error) {
        NSLog(@"subscription=%@, error=%@", subscription.pns_id, error);
    }];
}


- (UIApplication *)application {
    return [UIApplication sharedApplication];
}

@end

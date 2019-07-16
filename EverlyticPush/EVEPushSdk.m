#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "EVEPushSdk.h"
#import "EVEFIRMessagingDelegate.h"
#import "Models/EVESubscriptionEvent.h"
#import "EVEDefaults.h"
#import "Network/EVEHttp.h"
#import "EVEApi.h"
#import "EVEApiSubscription.h"
#import <objc/runtime.h>
#import "EVESwizzleHelpers.h"
#import "EVEUIApplicationDelegate.h"

@import Firebase;

@interface EVEPushSdk () <UNUserNotificationCenterDelegate>

@property(strong, nonatomic) EVEHttp *http;
@property(strong, nonatomic) EVEApi *api;
@property(strong, nonatomic) EVEFIRMessagingDelegate *pmafirMessagingDelegate;
@property(strong, nonatomic) EVESdkConfiguration *sdkConfiguration;

@end

@implementation EVEPushSdk

+ (void)load {
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        [EVEUIApplicationDelegate swizzleApplicationDelegate];
    });
}

- (EVEPushSdk *)initWithConfiguration:(EVESdkConfiguration *)configuration {
    self.sdkConfiguration = configuration;

    if ([EVEDefaults deviceId] == nil) {
        [EVEDefaults setDeviceId:[[NSUUID UUID] UUIDString]];
    }

    if ([FIRApp defaultApp] == nil) {
        NSLog(@"[FIRApp defaultApp] is nil, configuring FIRApp now...");
        [FIRApp configure];
        self.pmafirMessagingDelegate = [[EVEFIRMessagingDelegate alloc] init];
        [FIRMessaging messaging].delegate = self.pmafirMessagingDelegate;
    }

    self.http = [[EVEHttp alloc] initWithSdkConfiguration:self.sdkConfiguration];
    self.api = [[EVEApi alloc] initWithHttpInstance:self.http];
    return self;
}

- (void)promptForNotificationPermissionWithUserResponse:(void (^)(BOOL consentGranted))completionHandler {
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

- (void)subscribeUserWithEmailAddress:(NSString *)emailAddress completionHandler:(void (^)(BOOL, NSError *))completionHandler {

    PMA_ContactData *contact = [[PMA_ContactData alloc] initWithEmail:emailAddress pushToken:EVEDefaults.fcmToken];
    PMA_DeviceData *deviceData = [[PMA_DeviceData alloc] initWithId:EVEDefaults.deviceId];
    EVESubscriptionEvent *subscriptionEvent = [[EVESubscriptionEvent alloc]
            initWithPushProjectUuid:self.sdkConfiguration.projectId
                        contactData:contact deviceData:deviceData];

    [self.api subscribeWithSubscriptionEvent:subscriptionEvent completionHandler:^(EVEApiSubscription *subscription, NSError *error) {
        NSLog(@"subscription=%ld, error=%@", subscription.pns_id, error);

        [EVEDefaults setSubscriptionId:(NSInteger *) subscription.pns_id];
    }];
}


- (UIApplication *)application {
    return [UIApplication sharedApplication];
}

@end
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
#import "EVEUIApplicationDelegate.h"
#import "EVENotificationEventsLog.h"
#import "EVEDatabase.h"
#import "EverlyticNotification.h"
#import "EVENotificationLog.h"
#import "EVEUnsubscribeEvent.h"
#import "EVEApiResponse.h"
#import "EVENotificationSystemSettings.h"
#import "EVEHelpers.h"
#import "EVENotificationSystemSettings10.h"
#import "EVENotificationSystemSettings8.h"
#import "EVENotificationCenterDelegate.h"
#import "EVEEventsHelpers.h"

@import Firebase;

@interface EVEPushSdk ()
@property(strong, nonatomic) EVEHttp *http;
@property(strong, nonatomic) EVEApi *api;
@property(strong, nonatomic) EVEFIRMessagingDelegate *firebaseMessagingDelegate;
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
        self.firebaseMessagingDelegate = [[EVEFIRMessagingDelegate alloc] init];
        [FIRMessaging messaging].delegate = self.firebaseMessagingDelegate;
    }

    self.http = [[EVEHttp alloc] initWithSdkConfiguration:self.sdkConfiguration reachabilityBlock:^(EVEReachability *reachability, SCNetworkConnectionFlags i) {
        [EVEEventsHelpers uploadPendingEventsWithCompletionHandler:nil];
    }];

    self.api = [[EVEApi alloc] initWithHttpInstance:self.http];
    [self notificationSettings]; // gets the objects set up for any delegates
    return self;
}

- (void)promptForNotificationPermissionWithUserResponse:(void (^)(BOOL consentGranted))completionHandler {
    [[self notificationSettings] promptForNotifications:completionHandler];
    [[self application] registerForRemoteNotifications];
}

- (void)subscribeUserWithUniqueId:(NSString *_Nullable)uniqueId emailAddress:(NSString *_Nullable)emailAddress completionHandler:(void (^)(BOOL, NSError *))completionHandler {

    if (uniqueId == nil && emailAddress == nil) {
        NSLog(@"Both uniqueId and email address are nil. Please provide a valid uniqueId, email, or both");
        completionHandler(false, [NSError errorWithDomain:@"EverlyticPush" code:0 userInfo:@{@"message": @"Both uniqueId and email address are nil. Please provide a valid uniqueId, email, or both"}]);
        return;
    }

    EVE_ContactData *contact = [[EVE_ContactData alloc] initWithEmail:emailAddress uniqueId:uniqueId pushToken:EVEDefaults.fcmToken];
    EVE_DeviceData *deviceData = [[EVE_DeviceData alloc] initWithId:EVEDefaults.deviceId];
    EVESubscriptionEvent *subscriptionEvent = [[EVESubscriptionEvent alloc]
            initWithPushProjectUuid:self.sdkConfiguration.projectId
                        contactData:contact deviceData:deviceData];

    [self.api subscribeWithSubscriptionEvent:subscriptionEvent completionHandler:^(EVEApiSubscription *subscription, NSError *error) {
        NSLog(@"subscription=%@, error=%@", subscription.pns_id, error);
        [EVEDefaults setSubscriptionId:subscription.pns_id];

        if (completionHandler != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(subscription != nil, error);
            });
        }
    }];
}

- (void)unsubscribeUserWithCompletionHandler:(void (^ _Nullable)(BOOL))completionHandler {
    id subId = [EVEDefaults subscriptionId];
    id devId = [EVEDefaults deviceId];
    id event = [[EVEUnsubscribeEvent alloc] initWithSubscriptionId:subId deviceId:devId];

    [EVEDatabase inDatabase:^(FMDatabase *database) {
        EVENotificationLog *log = [[EVENotificationLog alloc] initWithDatabase:database];

        [log clearNotificationHistory];
    }];

    [self.api unsubscribeWithUnsubscribeEvent:event completionHandler:^(EVEApiResponse *response, NSError *error) {
        if (completionHandler != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(response.isSuccessful);
            });
        }
    }];
}


- (void)publicNotificationHistoryWithCompletionHandler:(void (^ _Nonnull)(NSArray<EverlyticNotification *> *_Nonnull))completionHandler {
    [EVEDatabase inDatabase:^(FMDatabase *database) {
        EVENotificationLog *log = [[EVENotificationLog alloc] initWithDatabase:database];
        id notifications = [log publicNotificationHistory];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(notifications);
        });
    }];
}

- (NSNumber *_Nonnull)publicNotificationHistoryCount {
    __block NSNumber *count = @0;

    [EVEDatabase inDatabase:^(FMDatabase *database) {
        EVENotificationLog *log = [[EVENotificationLog alloc] initWithDatabase:database];
        count = [log publicNotificationHistoryCount];
    }];

    return count;
}

- (UIApplication *)application {
    return [UIApplication sharedApplication];
}

static NSObject <EVENotificationSystemSettings> *_notificationSettings;

- (NSObject <EVENotificationSystemSettings> *)notificationSettings {
    if (_notificationSettings == nil) {
        if ([EVEHelpers iosVersionIsGreaterOrEqualTo:10]) {
            id delegate = [[EVENotificationCenterDelegate alloc] init];
            _notificationSettings = [[EVENotificationSystemSettings10 alloc] initWithDelegate:delegate];
        } else {
            _notificationSettings = [[EVENotificationSystemSettings8 alloc] initWithApplication:self.application];
        }
    }

    return _notificationSettings;
}

@end

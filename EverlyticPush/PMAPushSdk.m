//
// Created by Jason Dantuma on 2019-06-18.
// Copyright (c) 2019 Everlytic. All rights reserved.
//

#import "PMAPushSdk.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface PMAPushSdk () <UNUserNotificationCenterDelegate>

@end

@implementation PMAPushSdk

- (PMAPushSdk *)initWithConfiguration:(PMASdkConfiguration *)configuration {
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

- (UIApplication *)application {
    return [UIApplication sharedApplication];
}

@end
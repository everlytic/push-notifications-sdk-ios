//
//  EverlyticPush.m
//  EverlyticPush
//
//  Created by Jason Dantuma on 2019/06/18.
//  Copyright © 2019 Everlytic. All rights reserved.
//

#import "EverlyticPush.h"
#import "PMAPushSdk.h"
#import <UserNotifications/UserNotifications.h>
@import Firebase;

PMAPushSdk *sdk;

@implementation EverlyticPush

+(id)initWithPushConfig:(NSString *)pushConfig {
#if DEBUG
    NSLog(@"init was called with config=%@", pushConfig);
#endif

    PMASdkConfiguration *configuration = [PMASdkConfiguration initFromConfigString:pushConfig];

#if DEBUG
    NSLog(@"projectId=%@, url=%@", configuration.projectId, configuration.installUrl.absoluteString);
#endif
    
    sdk = [[PMAPushSdk alloc] initWithConfiguration:configuration];

    return self;
}

+ (void)promptForNotificationWithUserResponse:(void (^)(BOOL consentGranted))completionHandler {
    if (sdk != nil) {
        [sdk promptForNotificationWithUserResponse:completionHandler];
    }
}

+ (BOOL)hasNotificationConsent {
    return NO;
}


@end

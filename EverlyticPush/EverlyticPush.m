#import "EverlyticPush.h"
#import "PMAPushSdk.h"

@implementation EverlyticPush

PMAPushSdk *sdk;

+ (id)initWithPushConfig:(NSString *)pushConfig {
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

+ (void)promptForNotificationPermissionWithUserResponse:(void (^)(BOOL consentGranted))completionHandler {
    if (sdk == nil) {
        NSLog(@"Failed to prompt for notification access as the SDK is not initialized yet.");
        return;
    }

    [sdk promptForNotificationPermissionWithUserResponse:completionHandler];
}

+ (void)subscribeUserWithEmail:(NSString *)emailAddress completionHandler:(void (^)(BOOL, NSError *))handler {

    if (sdk == nil) {
        NSLog(@"Failed to subscribe user as the SDK is not initialized yet.");
        return;
    }

    NSString *emailTrimmed = [emailAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"Should subscribe user with email=%@", emailAddress);

    [sdk subscribeUserWithEmailAddress:emailTrimmed completionHandler:handler];
}


@end

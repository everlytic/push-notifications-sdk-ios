#import "EverlyticPush.h"
#import "PMAPushSdk.h"

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

+ (void)subscribeUserWithEmail:(NSString *)emailAddress completionHandler:(void (^)(BOOL subscriptionSuccess))handler {
    NSString *emailTrimmed = [emailAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"Should subscribe user with email=%@", emailAddress);
}


@end

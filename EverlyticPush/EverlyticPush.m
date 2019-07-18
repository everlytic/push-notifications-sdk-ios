#import "EverlyticPush.h"
#import "EVEPushSdk.h"
#import "EVEDefaults.h"

@implementation EverlyticPush

static EVEPushSdk *sdk;

+ (id)initWithPushConfig:(NSString *)configurationString {
#if DEBUG
    NSLog(@"init was called with config=%@", configurationString);
#endif

    EVESdkConfiguration *configuration = [EVESdkConfiguration initFromConfigString:configurationString];

#if DEBUG
    NSLog(@"projectId=%@, url=%@", configuration.projectId, configuration.installUrl.absoluteString);
#endif

    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk = [[EVEPushSdk alloc] initWithConfiguration:configuration];
    });

    [EVEDefaults setConfigurationString:configurationString];
    
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

+ (void)unsubscribeUserWithCompletionHandler:(void (^ _Nonnull)(BOOL subscriptionSuccess, NSError *_Nullable error))handler {
    if (sdk == nil) {
        NSLog(@"Failed to unsubscribe user as the SDK is not initialized yet.");
        return;
    }

    @throw [NSException exceptionWithName:@"NotImplementedException" reason:@"Not implemented yet" userInfo:nil];
}

+ (BOOL)contactIsSubscribed {
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:@"Not implemented yet" userInfo:nil];
    return NO;
}

+ (void)fetchNotificationHistoryWithCompletionListener:(void (^ _Nonnull)(void))completionHandler {
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:@"Not implemented yet" userInfo:nil];
}


@end

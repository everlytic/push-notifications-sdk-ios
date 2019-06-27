#import <Foundation/Foundation.h>
#import "EVESdkConfiguration.h"

@interface EVEPushSdk : NSObject

- (EVEPushSdk *_Nonnull)initWithConfiguration:(EVESdkConfiguration *_Nonnull)configuration;

- (void)promptForNotificationPermissionWithUserResponse:(void (^ _Nullable)(BOOL consentGranted))completionHandler;

- (void)subscribeUserWithEmailAddress:(NSString *_Nonnull)emailAddress completionHandler:(void (^ _Nullable)(BOOL, NSError *_Nullable))completionHandler;
@end
